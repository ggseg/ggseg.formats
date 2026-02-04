# Create tract atlas data

Creates a data object for white matter tract atlases. Tract atlases use
tube meshes generated from streamline centerlines.

## Usage

``` r
tract_data(sf = NULL, meshes = NULL)
```

## Arguments

- sf:

  sf data.frame with columns label, view, geometry for 2D rendering.
  Optional.

- meshes:

  data.frame with columns label and mesh (list-column). Each mesh is a
  list with:

  - vertices: data.frame with x, y, z columns

  - faces: data.frame with i, j, k columns

  - metadata: list with n_centerline_points, centerline, tangents
    (required for orientation coloring and data projection)

## Value

An object of class c("tract_data", "brain_atlas_data")

## Examples

``` r
if (FALSE) { # \dontrun{
data <- tract_data(meshes = tube_meshes_df)
} # }
```
