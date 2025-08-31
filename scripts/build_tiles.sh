#!/bin/bash
set -euo pipefail
DB="runs"

# Export exactly what QGIS uses (no simplify while debugging)
ogr2ogr -f GeoJSON docs/streets_unrun.geojson \
  PG:"dbname=${DB}" runmap.streets_unrun
ogr2ogr -f GeoJSON docs/coverage_buffer_m.geojson \
  PG:"dbname=${DB}" runmap.coverage_buffer_m

# Tile (no drops, zooms for phone use)
tippecanoe --force \
  -o docs/runmap.mbtiles \
  -Z 11 -z 16 \
  -L coverage:docs/coverage_buffer_m.geojson \
  -L streets_unrun:docs/streets_unrun.geojson \
  --no-feature-limit --no-tile-size-limit --coalesce

pmtiles convert docs/runmap.mbtiles docs/runmap.pmtiles
echo "Tiles updated: docs/runmap.pmtiles"
