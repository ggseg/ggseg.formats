# Get brain surface mesh

Retrieves a brain surface mesh for the specified hemisphere and surface
type. By default, provides the inflated fsaverage5 surface from internal
data. Other surfaces (pial, white, semi-inflated) require the ggseg3d
package.

## Usage

``` r
get_brain_mesh(
  hemisphere = c("lh", "rh"),
  surface = "inflated",
  brain_meshes = NULL
)
```

## Arguments

- hemisphere:

  `"lh"` or `"rh"`

- surface:

  Surface type (default `"inflated"`). Other surfaces require ggseg3d or
  a custom `brain_meshes` argument.

- brain_meshes:

  Optional user-supplied mesh data. Accepts either
  `list(lh = list(vertices, faces), rh = ...)` or the legacy
  `list(lh_inflated = list(vertices, faces), ...)` format.

## Value

A list with `vertices` (data.frame with x, y, z) and `faces` (data.frame
with i, j, k), or NULL if the mesh is not available.
