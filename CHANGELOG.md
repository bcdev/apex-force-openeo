# CHANGELOG

## \[Unreleased\]

### Fixed

- Limit high parallelism for eodata downloads with `s5cmd` (#53)
- Add missing keys to CWL documents as required by the [EOAP Best Practice](http://www.opengis.net/doc/BP/eoap/1.0) `req/app-pck/clt`, `req/app-pck/wf` and `req/app-pck/wf-inputs` (#56)
- Make `stac_url` parameter of the TSA workflow a required parameter (previously declared as optional but required implicitly)

## 0.6.0

### New

- Level 2 supports any continent (not just europe). Multiple continents are still not supported

### Fixed

- STAC catalog is generated in output root ("l2-ard") and not in "l2-ard/europe" subdirectory

