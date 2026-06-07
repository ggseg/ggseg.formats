# Create cortical atlas data

Creates a data object for cortical brain atlases. Cortical atlases use
vertex indices that map regions to vertices on a shared brain surface
mesh (e.g., fsaverage5).

## Usage

``` r
ggseg_data_cortical(geom = NULL, vertices = NULL, ...)

brain_data_cortical(sf = NULL, vertices = NULL)
```

## Arguments

- geom:

  2D geometry for rendering, stored in the single `geom` slot: either an
  sf data.frame (columns `label`, `view`, `geometry`) or a
  `brain_polygons` data.frame (see
  [`sf_to_polygons()`](https://ggsegverse.github.io/ggseg.formats/reference/sf_to_polygons.md)).
  The class of `geom` determines the rendering path used downstream.

- vertices:

  data.frame with columns label and vertices (list-column of integer
  vectors). Each vector contains vertex indices for that region.

- ...:

  Captures a deprecated `sf` argument: if supplied it is converted to
  the polygon representation via
  [`sf_to_polygons()`](https://ggsegverse.github.io/ggseg.formats/reference/sf_to_polygons.md)
  and a deprecation warning is issued. Prefer passing 2D geometry via
  `geom`.

- sf:

  Deprecated. Pass 2D geometry via `geom` instead.

## Value

An object of class c("ggseg_data_cortical", "ggseg_atlas_data")

## Examples

``` r
data <- ggseg_data_cortical(
  vertices = data.frame(
    label = c("bankssts", "caudalanteriorcingulate"),
    vertices = I(list(c(1L, 2L, 3L), c(4L, 5L, 6L)))
  )
)
```
