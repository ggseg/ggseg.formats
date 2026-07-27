# Get atlas vertices for 3D rendering

Returns vertices data joined with core region info and palette colours.
Used for cortical atlases with vertex-based rendering.

## Usage

``` r
atlas_vertices(atlas)
```

## Arguments

- atlas:

  a ggseg_atlas object

## Value

data.frame with vertices ready for 3D rendering

## Examples

``` r
verts <- atlas_vertices(dk())
head(verts)
#> ── <ggseg_vertices> data: 6 × 7 ────────────────────────────────────────────────
#> Vertices per region: 48 –232
#>                        label    vertices hemi                  region
#> 1                lh_bankssts <int [126]> left                bankssts
#> 2 lh_caudalanteriorcingulate  <int [67]> left caudalanteriorcingulate
#> 3     lh_caudalmiddlefrontal <int [232]> left     caudalmiddlefrontal
#> 4          lh_corpuscallosum <int [198]> left          corpuscallosum
#> 5                  lh_cuneus <int [102]> left                  cuneus
#> 6              lh_entorhinal  <int [48]> left              entorhinal
#>                               names         lobe  colour
#> 1 banks of superior temporal sulcus     temporal #196428
#> 2         caudal anterior cingulate    cingulate #7D64A0
#> 3             caudal middle frontal      frontal #641900
#> 4                   corpus callosum white matter #784632
#> 5                            cuneus    occipital #DC1464
#> 6                        entorhinal     temporal #DC140A
```
