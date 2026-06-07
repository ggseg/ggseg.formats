# Get the raw 2D geometry of an atlas

Returns the single 2D geometry object stored in `atlas$data$geom`, which
is either an sf-class data frame or a `brain_polygons` data.frame. Its
class determines which rendering path is used downstream.

## Usage

``` r
atlas_geom(atlas)
```

## Arguments

- atlas:

  a ggseg_atlas object

## Value

an sf or `brain_polygons` object, or `NULL` if the atlas has no 2D
geometry

## Details

For backward compatibility with released atlases built before the
unified `geom` slot, this falls back to the legacy `sf` slot. Reverse
dependencies should call this accessor (or
[`atlas_sf()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_sf.md)
/
[`atlas_polygons()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_polygons.md))
rather than reaching into `atlas$data` directly.

## Examples

``` r
g <- atlas_geom(dk())
atlas_geometry_type(dk())
#> [1] "sf"
```
