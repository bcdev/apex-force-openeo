import sys
from datetime import datetime
from typing import Dict, Any
import subprocess
import re
from pathlib import Path

import pytest
import openeo
from openeo import processes
from openeo.rest.stac_resource import StacResource

L1C_COLLECTION_URL = "https://stac.dataspace.copernicus.eu/v1/collections/sentinel-2-l1c"
FORCE_WORKSPACE_URL = "https://s3.waw4-1.cloudferro.com/apex-force-results-waw4-1-exotc5yuexi2c5tvwqhoivj62fz8v0uupy0me"

@pytest.fixture()
def force_level2_example_url():
    return f"{FORCE_WORKSPACE_URL}/FORCE_level2_2026-07-01_161237/2026-07-01T16:12:37.807341-europe-level2.json"


@pytest.fixture
def openeo_environment():
    #return "production"
    return "staging"

@pytest.fixture
def backend_url(openeo_environment):
    match openeo_environment:
        case "production":
            url = "https://openeo.dataspace.copernicus.eu"
        case "staging":
            url = "https://openeo-staging.dataspace.copernicus.eu"
        case _:
            raise ValueError(f"Unknown environment {openeo_environment}")
    return url

@pytest.fixture
def connection(backend_url, openeo_environment):
    match openeo_environment:
        case "production":
            con = openeo.connect(backend_url).authenticate_oidc_client_credentials()
        case "staging":
            con = openeo.connect(backend_url).authenticate_oidc()
        case _:
            raise ValueError(f"Unknown environment {openeo_environment}")
    return con


@pytest.fixture
def spatial_extent():
    w, s, e, n = 11.0, 44.5, 11.1, 44.6
    extent = {"west": w, "south": s, "east": e, "north": n}
    return extent

@pytest.fixture()
def temporal_extent():
    extent=["2026-04-17", "2026-04-18"]
    return extent

def test_make_cwl_documents(tmp_path):
    tmp_path.mkdir(parents=True, exist_ok=True)
    make_cwl_documents(tmp_path)
    assert (tmp_path / "force_level2.cwl").exists()
    assert (tmp_path / "force_tsa.cwl").exists()

def make_cwl_documents(path):
    cwl_root = Path(__file__).parents[2].resolve() / "cwl"
    l2_cwl_source = cwl_root / "force-l2-workflow.cwl"

    with open(path / "force_level2.cwl", "w") as fp_l2:
        subprocess.run([sys.executable, "-m", "cwltool", "--pack", str(l2_cwl_source)], stdout=fp_l2)

    tsa_cwl_source = cwl_root / "force-tsa-workflow.cwl"
    with open(path / "force_tsa.cwl", "w") as fp_tsa:
        subprocess.run([sys.executable, "-m", "cwltool", "--pack", str(tsa_cwl_source)], stdout=fp_tsa)


def test_query_returns_results(connection, temporal_extent, spatial_extent):
    query_pg = construct_process_graph(temporal_extent, spatial_extent)
    query_res = connection.execute(query_pg)

    assert isinstance(query_res, dict)
    assert "features" in query_res
    features = query_res["features"]
    assert len(features) > 0


def test_tsa_current(connection, tmp_path, temporal_extent, subtests, force_level2_example_url):
    now = datetime.now().isoformat()
    cwl_path = tmp_path / "cwl"
    cwl_path.mkdir(parents=True, exist_ok=True)
    make_cwl_documents(cwl_path)
    cwl_tsa_path = cwl_path / "force_tsa.cwl"
    cwl_tsa = cwl_tsa_path.read_text()

    x_tile_range = [31, 31]
    y_tile_range = [29, 29]

    force_tsa_stac_resource = StacResource(
        graph = openeo.processes.process(
            process_id="run_cwl_to_stac",
            arguments=dict(
                cwl=cwl_tsa,
                context=dict(
                    stac_url=force_level2_example_url,
                    name=f"TSA_{now}",
                    date_range=temporal_extent,
                    x_tile_range=x_tile_range,
                    y_tile_range=y_tile_range,
                    stm=["AVG"],
                    output_stm=True,
                )
            )
        ),
        connection=connection,
    )

    tsa_job = force_tsa_stac_resource.create_job(title=f"Test TSA {now}")
    with subtests.test(msg="TSA job completes"):
        tsa_job.start_and_wait()

    tsa_results = tsa_job.get_results()
    tsa_target = tmp_path / "tsa"
    tsa_target.mkdir(parents=True, exist_ok=True)

    tsa_results.download_files(tsa_target)

    with subtests.test(msg="TSA: expected files are present", tmp_path=tmp_path):
        for root, dirs, files in tsa_target.walk():
            print(f"{root=}\t{dirs=}\t{files=}")
        datacube_base = tsa_target
        assert datacube_base.exists()
        assert tmp_path.glob("CITEME*") is not None
        # TODO: hardcoded europe, will break when AOI changes
        tiles = datacube_base.glob("X*Y*")
        assert tiles is not None
        first_tile = next(tiles)
        img = first_tile.glob("*.tif")
        assert img is not None

def test_complete_pipeline_current_cwl(connection, temporal_extent, spatial_extent, tmp_path, subtests):
    cwl_path = tmp_path / "cwl"
    cwl_path.mkdir(parents=True, exist_ok=True)
    make_cwl_documents(cwl_path)
    cwl_level2_path = cwl_path / "force_level2.cwl"
    cwl_tsa_path = cwl_path / "force_tsa.cwl"
    cwl_level2 = cwl_level2_path.read_text()
    cwl_tsa = cwl_tsa_path.read_text()

    query_pg = construct_process_graph(temporal_extent, spatial_extent)
    now = datetime.now().isoformat()
    w, s, e, n = spatial_extent["west"], spatial_extent["south"], spatial_extent["east"], spatial_extent["north"]

    aoi = f'{{ "type": "Feature", "geometry": {{ "type": "Polygon", "coordinates": [[[{w},{s}],[{w},{n}],[{e},{n}],[{e},{s}],[{w},{s}]]] }}, "properties": {{ "name": "FORCE test" }} }}'

    force_l2_stac_resource = StacResource(
        graph=openeo.internal.graph_building.PGNode(
            process_id="run_cwl_to_stac",
            arguments=dict(
                cwl=cwl_level2,
                context=dict(
                    stac_document=query_pg,
                    name=now,
                    aoi=aoi,
                    do_brdf=True
                ),
            )
        ),
        connection=connection,
    )
    merge_path = f"FORCE_level2_automated_test_{datetime.now().strftime('%Y-%m-%d_%H%M%S')}"
    force_l2_stac_resource = force_l2_stac_resource.export_workspace(
        workspace="apex-force-results-workspace",
        merge=merge_path
    )

    l2_job = force_l2_stac_resource.create_job(title=f"Test FORCE level 2 (current CWL) {now}")
    with subtests.test(msg="Level 2 job completes"):
        l2_job.start_and_wait()

    l2_results = l2_job.get_results()
    l2_target = tmp_path / "level2"
    l2_target.mkdir(parents=True, exist_ok=True)

    l2_results.download_files(l2_target)

    with subtests.test(msg="Level 2: expected files are present", tmp_path=tmp_path):
        for root, dirs, files in l2_target.walk():
            print(f"{root=}\n{dirs=}\n{files=}\n\n")
        datacube_base = l2_target
        assert datacube_base.exists()
        assert tmp_path.glob("CITEME*") is not None
        # TODO hardcoded europe breaks when aoi is changed
        tiles = (datacube_base / "europe").glob("X*Y*")
        assert tiles is not None
        first_tile = next(tiles)
        img = first_tile.glob("*.tif")
        ovv = first_tile.glob("*.jpg")
        assert img is not None
        assert ovv is not None

    # TSA

    l2_results_href = get_workspace_catalog_url(merge_path)
    print(l2_results_href)

    # TODO hardcoded tile (breaks if AOI changes)
    x_tile_range = [31, 31]
    y_tile_range = [29, 29]

    force_tsa_stac_resource = StacResource(
        graph = openeo.processes.process(
            process_id="run_cwl_to_stac",
            arguments=dict(
                cwl=cwl_tsa,
                context=dict(
                    stac_url=l2_results_href,
                    name=f"TSA_{now}",
                    date_range=temporal_extent,
                    x_tile_range=x_tile_range,
                    y_tile_range=y_tile_range,
                    stm=["AVG"],
                    output_stm=True,
                )
            )
        ),
        connection=connection,
    )

    tsa_job = force_tsa_stac_resource.create_job(title=f"Test TSA (current CWL) {now}")
    with subtests.test(msg="TSA job completes"):
        tsa_job.start_and_wait()

    tsa_results = tsa_job.get_results()
    tsa_target = tmp_path / "tsa"
    tsa_target.mkdir(parents=True, exist_ok=True)

    tsa_results.download_files(tsa_target)

    with subtests.test(msg="TSA: expected files are present", tmp_path=tmp_path):
        for root, dirs, files in tsa_target.walk():
            print(f"{root=}\t{dirs=}\t{files=}")
        datacube_base = tsa_target
        assert datacube_base.exists()
        assert tmp_path.glob("CITEME*") is not None
        tiles = datacube_base.glob("X*Y*")
        assert tiles is not None
        first_tile = next(tiles)
        img = first_tile.glob("*.tif")
        assert img is not None

def test_complete_pipeline_release(connection, temporal_extent, spatial_extent, tmp_path, subtests):
    query_pg = construct_process_graph(temporal_extent, spatial_extent)
    now = datetime.now().isoformat()
    w, s, e, n = spatial_extent["west"], spatial_extent["south"], spatial_extent["east"], spatial_extent["north"]

    aoi = f'{{ "type": "Feature", "geometry": {{ "type": "Polygon", "coordinates": [[[{w},{s}],[{w},{n}],[{e},{n}],[{e},{s}],[{w},{s}]]] }}, "properties": {{ "name": "FORCE test" }} }}'

    force_l2_stac_resource = StacResource(
        graph=openeo.internal.graph_building.PGNode(
            process_id="force_level2",
            arguments=dict(
                    stac_document=query_pg,
                    name=now,
                    aoi=aoi,
                    do_brdf=True
                ),
            ),
        connection=connection,
    )
    merge_path = f"FORCE_level2_automated_test_{datetime.now().strftime('%Y-%m-%d_%H%M%S')}"
    force_l2_stac_resource = force_l2_stac_resource.export_workspace(
        workspace="apex-force-results-workspace",
        merge=merge_path
    )

    l2_job = force_l2_stac_resource.create_job(title=f"Test FORCE level 2 (release) {now}")
    with subtests.test(msg="Level 2 job completes"):
        l2_job.start_and_wait()

    l2_results = l2_job.get_results()
    l2_target = tmp_path / "level2"
    l2_target.mkdir(parents=True, exist_ok=True)

    l2_results.download_files(l2_target)

    with subtests.test(msg="Level 2: expected files are present", tmp_path=tmp_path):
        for root, dirs, files in l2_target.walk():
            print(f"{root=}\n{dirs=}\n{files=}\n\n")
        datacube_base = l2_target
        assert datacube_base.exists()
        assert tmp_path.glob("CITEME*") is not None
        # TODO hardcoded europe breaks when aoi is changed
        tiles = (datacube_base / "europe").glob("X*Y*")
        assert tiles is not None
        first_tile = next(tiles)
        img = first_tile.glob("*.tif")
        ovv = first_tile.glob("*.jpg")
        assert img is not None
        assert ovv is not None

    # TSA

    l2_results_href = get_workspace_catalog_url(merge_path, continent="europe")
    print(l2_results_href)

    # TODO hardcoded tile (breaks if AOI changes)
    x_tile_range = [31, 31]
    y_tile_range = [29, 29]

    force_tsa_stac_resource = StacResource(
        graph = openeo.processes.process(
            process_id="force_tsa",
            arguments=dict(
                stac_url=l2_results_href,
                name=f"TSA_{now}",
                date_range=temporal_extent,
                x_tile_range=x_tile_range,
                y_tile_range=y_tile_range,
                stm=["AVG"],
                output_stm=True,
            )
        ),
        connection=connection,
    )

    tsa_job = force_tsa_stac_resource.create_job(title=f"Test TSA (release) {now}")
    with subtests.test(msg="TSA job completes"):
        tsa_job.start_and_wait()

    tsa_results = tsa_job.get_results()
    tsa_target = tmp_path / "tsa"
    tsa_target.mkdir(parents=True, exist_ok=True)

    tsa_results.download_files(tsa_target)

    with subtests.test(msg="TSA: expected files are present", tmp_path=tmp_path):
        for root, dirs, files in tsa_target.walk():
            print(f"{root=}\t{dirs=}\t{files=}")
        datacube_base = tsa_target
        assert datacube_base.exists()
        assert tmp_path.glob("CITEME*") is not None
        tiles = datacube_base.glob("X*Y*")
        assert tiles is not None
        first_tile = next(tiles)
        img = first_tile.glob("*.tif")
        assert img is not None

# helpers

def construct_process_graph(temporal_extent, spatial_extent):
    query_pg = openeo.processes.process(
        "query_stac",
        arguments={
            "url": L1C_COLLECTION_URL,
            "temporal_extent": temporal_extent,
            "spatial_extent": spatial_extent,
        }
    )
    return query_pg

def extract_canonical_link_from_job_results(job_results) -> Dict[str, Any]:
    canonical_link = next(l for l in job_results.get_metadata()["links"] if l["rel"] == "canonical")
    return canonical_link


def get_workspace_catalog_url(merge: str, continent: str | None=None):
    base =  f"{FORCE_WORKSPACE_URL}/{merge}"
    url = base
    if continent is not None:
        url = f"{base}/{continent}"
    return f"{url}/catalog.json"
