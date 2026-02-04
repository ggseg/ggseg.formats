# Create subcortical atlas data

Creates a data object for subcortical brain atlases. Subcortical atlases
use individual 3D meshes for each structure (e.g., hippocampus,
amygdala).

## Usage

``` r
subcortical_data(sf = NULL, meshes = NULL)
```

## Arguments

- sf:

  sf data.frame with columns label, view, geometry for 2D rendering.
  Optional.

- meshes:

  data.frame with columns label and mesh (list-column). Each mesh is a
  list with:

  - vertices: data.frame with x, y, z columns

  - faces: data.frame with i, j, k columns (1-based triangle indices)

## Value

An object of class c("subcortical_data", "brain_atlas_data")

## Examples

``` r
if (FALSE) { # \dontrun{
data <- subcortical_data(
  meshes = data.frame(
    label = "hippocampus_left",
    mesh = I(list(list(
      vertices = data.frame(x = 1:10, y = 1:10, z = 1:10),
      faces = data.frame(i = 1:3, j = 2:4, k = 3:5)
    )))
  )
)
} # }
```
