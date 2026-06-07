# Create subcortical atlas data

Creates a data object for subcortical brain atlases. Subcortical atlases
use individual 3D meshes for each structure (e.g., hippocampus,
amygdala).

## Usage

``` r
ggseg_data_subcortical(geom = NULL, meshes = NULL, ...)

brain_data_subcortical(sf = NULL, meshes = NULL)
```

## Arguments

- geom:

  2D geometry for rendering, stored in the single `geom` slot: either an
  sf data.frame (columns `label`, `view`, `geometry`) or a
  `brain_polygons` data.frame (see
  [`sf_to_polygons()`](https://ggsegverse.github.io/ggseg.formats/reference/sf_to_polygons.md)).
  The class of `geom` determines the rendering path used downstream.

- meshes:

  data.frame with columns label and mesh (list-column). Each mesh is a
  list with:

  - vertices: data.frame with x, y, z columns

  - faces: data.frame with i, j, k columns (1-based triangle indices)

- ...:

  Captures a deprecated `sf` argument: if supplied it is converted to
  the polygon representation via
  [`sf_to_polygons()`](https://ggsegverse.github.io/ggseg.formats/reference/sf_to_polygons.md)
  and a deprecation warning is issued. Prefer passing 2D geometry via
  `geom`.

- sf:

  Deprecated. Pass 2D geometry via `geom` instead.

## Value

An object of class c("ggseg_data_subcortical", "ggseg_atlas_data")

## Examples

``` r
data <- ggseg_data_subcortical(
  meshes = data.frame(
    label = "hippocampus_left",
    mesh = I(list(list(
      vertices = data.frame(x = 1:10, y = 1:10, z = 1:10),
      faces = data.frame(i = 1:3, j = 2:4, k = 3:5)
    )))
  )
)
```
