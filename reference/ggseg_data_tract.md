# Create tract atlas data

Creates a data object for white matter tract atlases. Stores centerlines
compactly; tube meshes are generated at render time for efficiency.

## Usage

``` r
ggseg_data_tract(sf = NULL, centerlines = NULL, meshes = NULL, ...)

brain_data_tract(sf = NULL, centerlines = NULL, meshes = NULL, ...)
```

## Arguments

- sf:

  sf data.frame with columns label, view, geometry for 2D rendering.
  Optional.

- centerlines:

  data.frame with columns:

  - label: tract identifier (character)

  - points: list-column of n x 3 matrices (centerline coordinates)

  - tangents: list-column of n x 3 matrices (for orientation coloring)

- meshes:

  Deprecated. Use centerlines instead. If provided, will be converted to
  centerlines format.

- ...:

  Absorbs legacy fields (e.g. tube_radius, tube_segments) from old
  cached atlas objects.

## Value

An object of class c("ggseg_data_tract", "ggseg_atlas_data")

## Examples

``` r
centerlines_df <- data.frame(
  label = "cst_left",
  points = I(list(matrix(rnorm(150), ncol = 3))),
  tangents = I(list(matrix(rnorm(150), ncol = 3)))
)
data <- ggseg_data_tract(centerlines = centerlines_df)
```
