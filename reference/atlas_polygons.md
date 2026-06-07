# Get atlas polygons for 2D rendering

Returns the `brain_polygons` representation of the atlas geometry,
converting from sf when needed. The sf-optional counterpart to
[`atlas_sf()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_sf.md).

## Usage

``` r
atlas_polygons(atlas)
```

## Arguments

- atlas:

  a ggseg_atlas object

## Value

a `brain_polygons` data.frame

## Examples

``` r
polys <- atlas_polygons(dk())
```
