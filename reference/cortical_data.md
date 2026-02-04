# Create cortical atlas data

Creates a data object for cortical brain atlases. Cortical atlases use
vertex indices that map regions to vertices on a shared brain surface
mesh (e.g., fsaverage5).

## Usage

``` r
cortical_data(sf = NULL, vertices = NULL)
```

## Arguments

- sf:

  sf data.frame with columns label, view, geometry for 2D rendering.
  Optional but required for ggseg plotting.

- vertices:

  data.frame with columns label and vertices (list-column of integer
  vectors). Each vector contains vertex indices for that region.

## Value

An object of class c("cortical_data", "brain_atlas_data")

## Examples

``` r
if (FALSE) { # \dontrun{
data <- cortical_data(
  sf = sf_geometry,
  vertices = data.frame(
    label = c("bankssts", "caudalanteriorcingulate"),
    vertices = I(list(c(1, 2, 3), c(4, 5, 6)))
  )
)
} # }
```
