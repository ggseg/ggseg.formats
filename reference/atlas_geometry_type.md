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

`atlas_geometry_type()` returns `"sf"`, `"polygon"`, or `NA`.
`is_atlas_sf()` / `is_atlas_polygon()` return a logical scalar.

## Examples

``` r
atlas_geometry_type(dk())
#> [1] "sf"
is_atlas_polygon(dk())
#> [1] FALSE
```
