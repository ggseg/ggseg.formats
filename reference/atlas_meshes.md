# Get atlas meshes for 3D rendering

Returns meshes data joined with core region info and palette colours.
Used for subcortical and tract atlases.

## Usage

``` r
atlas_meshes(atlas)
```

## Arguments

- atlas:

  a ggseg_atlas object

## Value

data.frame with meshes ready for 3D rendering

## Examples

``` r
meshes <- atlas_meshes(aseg())
head(meshes)
#> ── <ggseg_meshes> data: 6 × 6 ──────────────────────────────────────────────────
#> # A tibble: 6 × 3
#>   label                  vertices faces
#>   <chr>                     <int> <int>
#> 1 Left-Cerebellum-Cortex    21232 42456
#> 2 Left-Cerebellum-Cortex    21232 42456
#> 3 Left-Thalamus              3726  7448
#> 4 Left-Thalamus              3726  7448
#> 5 Left-Thalamus              3726  7448
#> 6 Left-Thalamus              3726  7448
```
