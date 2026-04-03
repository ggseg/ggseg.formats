# Get SUIT cerebellar surface mesh

Retrieves the shared SUIT cerebellar surface mesh used for vertex-based
cerebellar atlas rendering. The mesh contains 28,935 original surface
vertices plus 1,078 additional vertices forming a cap over the
peduncular surface (where the cerebellum meets the brainstem). The cap
vertices (indices 28,935–30,012) are duplicates of the boundary loop and
a centroid, designed to render as an opaque grey wall when not assigned
to any atlas region.

## Usage

``` r
get_cerebellar_mesh()
```

## Value

A list with `vertices` (data.frame with x, y, z) and `faces` (data.frame
with i, j, k, 0-based indices).

## Examples

``` r
mesh <- get_cerebellar_mesh()
nrow(mesh$vertices)
#> [1] 30013
```
