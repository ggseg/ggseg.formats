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
#> ── <ggseg_vertices> data: 6 × 6 ────────────────────────────────────────────────
#> Vertices per region: 48 –232
#>                        label    vertices hemi                            region
#> 1                lh_bankssts <int [126]> left banks of superior temporal sulcus
#> 2 lh_caudalanteriorcingulate  <int [67]> left         caudal anterior cingulate
#> 3     lh_caudalmiddlefrontal <int [232]> left             caudal middle frontal
#> 4          lh_corpuscallosum <int [198]> left                   corpus callosum
#> 5                  lh_cuneus <int [102]> left                            cuneus
#> 6              lh_entorhinal  <int [48]> left                        entorhinal
#>           lobe  colour
#> 1     temporal #196428
#> 2    cingulate #7D64A0
#> 3      frontal #641900
#> 4 white matter #784632
#> 5    occipital #DC1464
#> 6     temporal #DC140A
```
