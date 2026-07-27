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
#> ── <ggseg_meshes> data: 6 × 7 ──────────────────────────────────────────────────
#>                    label vertices faces
#> 1 Left-Cerebellum-Cortex    10618 21228
#> 2          Left-Thalamus     1864  3724
#> 3           Left-Caudate     1512  3028
#> 4           Left-Putamen     1998  3992
#> 5          Left-Pallidum      723  1442
#> 6             Brain-Stem     4608  9212
```
