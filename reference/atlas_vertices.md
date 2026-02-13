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
verts <- atlas_vertices(dk)
head(verts)
#> ── <ggseg_vertices> data: 6 × 6 ────────────────────────────────────────────────
#> Vertices per region: 48 –232
#> # A tibble: 6 × 6
#>   label                      vertices    hemi  region               lobe  colour
#>   <chr>                      <list>      <chr> <chr>                <chr> <chr> 
#> 1 lh_bankssts                <int [126]> left  banks of superior t… temp… #1964…
#> 2 lh_caudalanteriorcingulate <int [67]>  left  caudal anterior cin… cing… #7D64…
#> 3 lh_caudalmiddlefrontal     <int [232]> left  caudal middle front… fron… #6419…
#> 4 lh_corpuscallosum          <int [198]> left  corpus callosum      whit… #7846…
#> 5 lh_cuneus                  <int [102]> left  cuneus               occi… #DC14…
#> 6 lh_entorhinal              <int [48]>  left  entorhinal           temp… #DC14…
```
