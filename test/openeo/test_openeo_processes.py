import sys
from datetime import datetime
from typing import Dict, Any
import subprocess
import importlib
import re

import pytest
import openeo
from openeo import processes
from openeo.rest.stac_resource import StacResource

L1C_COLLECTION_URL = "https://stac.dataspace.copernicus.eu/v1/collections/sentinel-2-l1c"

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
    with importlib.resources.path("cwl", "force-l2-workflow.cwl") as l2_cwl_source:
        with open(path / "force_level2.cwl", "w") as fp_l2:
            subprocess.run([sys.executable, "-m", "cwltool", "--pack", l2_cwl_source], stdout=fp_l2)
    with importlib.resources.path("cwl", "force-tsa-workflow.cwl") as tsa_cwl_source:
        with open(path / "force_tsa.cwl", "w") as fp_tsa:
            subprocess.run([sys.executable, "-m", "cwltool", "--pack", tsa_cwl_source], stdout=fp_tsa)


def test_query_returns_results(connection, temporal_extent, spatial_extent):
    query_pg = construct_process_graph(temporal_extent, spatial_extent)
    query_res = connection.execute(query_pg)

    assert isinstance(query_res, dict)
    assert "features" in query_res
    features = query_res["features"]
    assert len(features) > 0


@pytest.mark.skip(reason="Requires job reference. Subset of test_complete_pipeline. Useful for debugging.")
def test_tsa(connection, tmp_path , temporal_extent, subtests):
    now = datetime.now().isoformat()
    cwl_path = tmp_path / "cwl"
    cwl_path.mkdir(parents=True, exist_ok=True)
    make_cwl_documents(cwl_path)
    cwl_tsa_path = cwl_path / "force_tsa.cwl"
    cwl_tsa = cwl_tsa_path.read_text()

    l2_job = connection.job("j-26070208482245c8ba296120762b51b0")
    l2_results_href = extract_workspace_href_from_job_results(l2_job.get_results())
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

def test_complete_pipeline(connection, temporal_extent, spatial_extent, tmp_path, subtests):
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
        #graph=openeo.processes.process(
        # TODO needed only with export workspace
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
    merge_path = f"FORCE_level2_{datetime.now().strftime('%Y-%m-%d_%H%M%S')}"
    force_l2_stac_resource = force_l2_stac_resource.export_workspace(
        workspace="apex-force-results-workspace",
        merge=merge_path
    )

    l2_job = force_l2_stac_resource.create_job(title=f"FORCE level 2 test {now}")
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

    l2_results_href = extract_workspace_href_from_job_results(l2_results)
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
        tiles = datacube_base.glob("X*Y*")
        assert tiles is not None
        first_tile = next(tiles)
        img = first_tile.glob("*.tif")
        assert img is not None

def test_level2_custom_processes(connection, temporal_extent, spatial_extent):
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
    merge_path = f"FORCE_level2_custom_processes_{datetime.now().strftime('%Y-%m-%d_%H%M%S')}"
    force_l2_stac_resource = force_l2_stac_resource.export_workspace(
        workspace="apex-force-results-workspace",
        merge=merge_path
    )

    l2_job = force_l2_stac_resource.create_job(title=f"FORCE level 2 test custom process{now}")
    l2_job.start_and_wait()


def test_level2_with_large_query(connection, spatial_extent):
    temporal_extent = ["2026-04-01", "2026-05-01"]
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
    l2_job = force_l2_stac_resource.create_job(title=f"FORCE level 2 test large query {now}")
    l2_job.start_and_wait()

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

def extract_workspace_href_from_job_results(job_results) -> str:
    storage_root = "s3.waw4-1.cloudferro.com"
    # Always present
    reference_asset = "europe/datacube-definition.prj"
    datacube_def_asset = job_results.get_metadata()["assets"][reference_asset]
    href = next(iter(datacube_def_asset["alternate"].values()))["href"]
    no_suffix = href.removesuffix(reference_asset).rstrip("/")
    no_prefix = no_suffix.removeprefix("s3:").lstrip("/")
    modified_href = f"https://{storage_root}/{no_prefix}/catalog.json"
    return modified_href

def extract_catalog_url_from_job_logs(job_logs) -> str:
    pattern = r"v\.generate_public_url\(\)='(http[^']+catalog(ue)?.json)'"
    log_with_item_url = next(iter(l.message for l in job_logs if re.search(pattern, l.message)))
    catalog_url = re.search(pattern, log_with_item_url).group(1)
    return catalog_url
