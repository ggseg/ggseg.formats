# Create tract atlas data

Creates a data object for white matter tract atlases. Stores centerlines
compactly; tube meshes are generated at render time for efficiency.

## Usage

``` r
ggseg_data_tract(
  sf = NULL,
  centerlines = NULL,
  tube_radius = 5,
  tube_segments = 8,
  meshes = NULL
)

brain_data_tract(
  sf = NULL,
  centerlines = NULL,
  tube_radius = 5,
  tube_segments = 8,
  meshes = NULL
)
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

- tube_radius:

  Radius for tube mesh generation. Default 5.

- tube_segments:

  Number of segments around tube circumference. Default 8.

- meshes:

  Deprecated. Use centerlines instead. If provided, will be converted to
  centerlines format.

## Value

An object of class c("ggseg_data_tract", "ggseg_atlas_data")

## Examples

``` r
if (FALSE) { # \dontrun{
centerlines_df <- data.frame(
  label = "cst_left",
  points = I(list(matrix(rnorm(150), ncol = 3))),
  tangents = I(list(matrix(rnorm(150), ncol = 3)))
)
data <- ggseg_data_tract(centerlines = centerlines_df)
} # }
```
