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
meshes <- atlas_meshes(aseg)
head(meshes)
#> ── <ggseg_meshes> data: 6 × 6 ──────────────────────────────────────────────────
#> # A tibble: 6 × 3
#>   label            vertices faces
#>   <chr>               <int> <int>
#> 1 Left-Thalamus        1864  3724
#> 2 Left-Caudate         1512  3028
#> 3 Left-Putamen         1998  3992
#> 4 Left-Pallidum         723  1442
#> 5 Brain-Stem           4608  9212
#> 6 Left-Hippocampus     1892  3780
```
