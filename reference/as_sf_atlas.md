# Rehydrate a ggseg atlas into sf-backed form

Inverse of
[`as_polygon_atlas()`](https://ggsegverse.github.io/ggseg.formats/reference/as_polygon_atlas.md).
Sets the single `geom` slot to an sf-class geometry table, converting
from polygons via
[`sfheaders::sf_multipolygon()`](https://dcooley.github.io/sfheaders/reference/sf_multipolygon.html)
if needed — sfheaders is pure Rcpp with no GDAL/GEOS/PROJ dependencies,
so the conversion itself does not require a full sf installation. Use
this when you want to run sf operations (buffers, intersections, CRS
transforms) on atlas geometry; those sf operations themselves still
require sf.

## Usage

``` r
as_sf_atlas(atlas)
```

## Arguments

- atlas:

  A `ggseg_atlas` (or legacy `brain_atlas`) object.

## Value

A `ggseg_atlas` whose `$data$geom` is an sf object.

## Details

Conversion is lossless, so a single representation is kept (no redundant
polygons alongside sf).

## Examples

``` r
if (FALSE) { # \dontrun{
library(sf)
atlas <- as_sf_atlas(as_polygon_atlas(dk()))
st_buffer(atlas_geom(atlas)$geometry[[1]], dist = 2)
} # }
```
