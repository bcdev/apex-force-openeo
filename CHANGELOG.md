# CHANGELOG

## [Unreleased]

### Fixed

- Limit high parallelism for eodata downloads with `s5cmd` (#53)

## 0.6.0

### New

- Level 2 supports any continent (not just europe). Multiple continents are still not supported

### Fixed

- STAC catalog is generated in output root ("l2-ard") and not in "l2-ard/europe" subdirectory

