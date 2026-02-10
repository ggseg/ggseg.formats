# TRACULA White Matter Tract Atlas

Brain atlas for FreeSurfer's TRACULA (TRActs Constrained by UnderLying
Anatomy) white matter bundles in MNI space.

## Usage

``` r
data(tracula)
```

## Format

A `ggseg_atlas` object with components:

- atlas:

  Character. Atlas name ("tracula")

- type:

  Character. Atlas type ("tract")

- palette:

  Named character vector of colours for each tract

- data:

  A `ggseg_data_tract` object containing:

  centerlines

  :   List of centerline matrices per tract

  sf

  :   Simple features data frame for 2D rendering

## Details

This atlas contains major white matter tracts reconstructed from
diffusion MRI using FreeSurfer's TRACULA training data. It works with
both ggseg (2D slice projections) and ggseg3d (3D tube mesh
visualizations).

## References

Yendiki A, Panneck P, Srinivasan P, et al. (2011). Automated
probabilistic reconstruction of white-matter pathways in health and
disease using an atlas of the underlying anatomy. Frontiers in
Neuroinformatics, 5:23.
[doi:10.3389/fninf.2011.00023](https://doi.org/10.3389/fninf.2011.00023)

## See also

[dk](https://ggseg.github.io/ggseg.formats/reference/dk.md) for cortical
parcellation,
[aseg](https://ggseg.github.io/ggseg.formats/reference/aseg.md) for
subcortical structures,
[`ggseg_atlas()`](https://ggseg.github.io/ggseg.formats/reference/ggseg_atlas.md)
for the atlas class constructor

Other ggseg_atlases:
[`aseg`](https://ggseg.github.io/ggseg.formats/reference/aseg.md),
[`dk`](https://ggseg.github.io/ggseg.formats/reference/dk.md)

## Examples

``` r
data(tracula)
tracula
#> 
#> ── tracula ggseg atlas ─────────────────────────────────────────────────────────
#> Type: tract
#> Regions: 26
#> Hemispheres: midline, left, right
#> Views: axial_2, axial_4, coronal_3, coronal_4, sagittal_left, sagittal_midline,
#> sagittal_right
#> Palette: ✔
#> Rendering: ✔ ggseg
#> ✔ ggseg3d (centerlines)
#> ────────────────────────────────────────────────────────────────────────────────
#> # A tibble: 42 × 4
#>    hemi    region              label                group          
#>    <chr>   <chr>               <chr>                <chr>          
#>  1 midline anterior commissure acomm.bbr.prep       commissure     
#>  2 midline CC body central     cc.bodyc.bbr.prep    corpus callosum
#>  3 midline CC body parietal    cc.bodyp.bbr.prep    corpus callosum
#>  4 midline CC body prefrontal  cc.bodypf.bbr.prep   corpus callosum
#>  5 midline CC body premotor    cc.bodypm.bbr.prep   corpus callosum
#>  6 midline CC body temporal    cc.bodyt.bbr.prep    corpus callosum
#>  7 midline CC genu             cc.genu.bbr.prep     corpus callosum
#>  8 midline CC rostrum          cc.rostrum.bbr.prep  corpus callosum
#>  9 midline CC splenium         cc.splenium.bbr.prep corpus callosum
#> 10 left    arcuate fasciculus  lh.af.bbr.prep       association    
#> # ℹ 32 more rows

# List regions
atlas_regions(tracula)
#>  [1] "CC body central"                  "CC body parietal"                
#>  [3] "CC body prefrontal"               "CC body premotor"                
#>  [5] "CC body temporal"                 "CC genu"                         
#>  [7] "CC rostrum"                       "CC splenium"                     
#>  [9] "SLF I"                            "SLF II"                          
#> [11] "SLF III"                          "acoustic radiation"              
#> [13] "anterior commissure"              "anterior thalamic radiation"     
#> [15] "arcuate fasciculus"               "cingulum dorsal"                 
#> [17] "cingulum ventral"                 "corticospinal tract"             
#> [19] "extreme capsule"                  "fornix"                          
#> [21] "frontal aslant tract"             "inferior longitudinal fasciculus"
#> [23] "middle cerebellar peduncle"       "middle longitudinal fasciculus"  
#> [25] "optic radiation"                  "uncinate fasciculus"             

data(tracula)
tracula
#> 
#> ── tracula ggseg atlas ─────────────────────────────────────────────────────────
#> Type: tract
#> Regions: 26
#> Hemispheres: midline, left, right
#> Views: axial_2, axial_4, coronal_3, coronal_4, sagittal_left, sagittal_midline,
#> sagittal_right
#> Palette: ✔
#> Rendering: ✔ ggseg
#> ✔ ggseg3d (centerlines)
#> ────────────────────────────────────────────────────────────────────────────────
#> # A tibble: 42 × 4
#>    hemi    region              label                group          
#>    <chr>   <chr>               <chr>                <chr>          
#>  1 midline anterior commissure acomm.bbr.prep       commissure     
#>  2 midline CC body central     cc.bodyc.bbr.prep    corpus callosum
#>  3 midline CC body parietal    cc.bodyp.bbr.prep    corpus callosum
#>  4 midline CC body prefrontal  cc.bodypf.bbr.prep   corpus callosum
#>  5 midline CC body premotor    cc.bodypm.bbr.prep   corpus callosum
#>  6 midline CC body temporal    cc.bodyt.bbr.prep    corpus callosum
#>  7 midline CC genu             cc.genu.bbr.prep     corpus callosum
#>  8 midline CC rostrum          cc.rostrum.bbr.prep  corpus callosum
#>  9 midline CC splenium         cc.splenium.bbr.prep corpus callosum
#> 10 left    arcuate fasciculus  lh.af.bbr.prep       association    
#> # ℹ 32 more rows
```
