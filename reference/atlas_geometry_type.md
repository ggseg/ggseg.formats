# Classify or test an atlas's 2D geometry

Classify or test an atlas's 2D geometry

## Usage

``` r
atlas_geometry_type(atlas)

is_atlas_sf(atlas)

is_atlas_polygon(atlas)
```

## Arguments

- atlas:

  a ggseg_atlas object

## Value

`atlas_geometry_type()` returns `"sf"` or `"polygon"`, and errors if the
atlas has no recognised 2D geometry. `is_atlas_sf()` /
`is_atlas_polygon()` return a logical scalar (`FALSE` for non-atlases).

## Examples

``` r
atlas_geometry_type(dk())
#> [1] "sf"
is_atlas_polygon(dk())
#> [1] FALSE
```
