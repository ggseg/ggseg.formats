# Create cortical atlas data

Creates a data object for cortical brain atlases. Cortical atlases use
vertex indices that map regions to vertices on a shared brain surface
mesh (e.g., fsaverage5).

## Usage

``` r
brain_data_cortical(sf = NULL, vertices = NULL)
```

## Arguments

- sf:

  sf data.frame with columns label, view, geometry for 2D rendering.
  Optional but required for ggseg plotting.

- vertices:

  data.frame with columns label and vertices (list-column of integer
  vectors). Each vector contains vertex indices for that region.

## Value

An object of class c("brain_data_cortical", "ggseg_atlas_data")

## Examples

``` r
if (FALSE) { # \dontrun{
data <- brain_data_cortical(
  sf = sf_geometry,
  vertices = data.frame(
    label = c("bankssts", "caudalanteriorcingulate"),
    vertices = I(list(c(1, 2, 3), c(4, 5, 6)))
  )
)
} # }
```
