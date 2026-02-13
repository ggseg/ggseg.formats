# TRACULA White Matter Tract Atlas

Returns the TRACULA (TRActs Constrained by UnderLying Anatomy) white
matter bundle atlas in MNI space.

## Usage

``` r
tracula()
```

## Value

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

[`dk()`](https://ggseg.github.io/ggseg.formats/reference/dk.md) for
cortical parcellation,
[`aseg()`](https://ggseg.github.io/ggseg.formats/reference/aseg.md) for
subcortical structures,
[`ggseg_atlas()`](https://ggseg.github.io/ggseg.formats/reference/ggseg_atlas.md)
for the atlas class constructor

Other ggseg_atlases:
[`aseg()`](https://ggseg.github.io/ggseg.formats/reference/aseg.md),
[`dk()`](https://ggseg.github.io/ggseg.formats/reference/dk.md)

## Examples

``` r
tracula()
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
#>    hemi    region                           label                group          
#>    <chr>   <chr>                            <chr>                <chr>          
#>  1 midline anterior commissure              acomm.bbr.prep       commissure     
#>  2 midline CC body central                  cc.bodyc.bbr.prep    corpus callosum
#>  3 midline CC body parietal                 cc.bodyp.bbr.prep    corpus callosum
#>  4 midline CC body prefrontal               cc.bodypf.bbr.prep   corpus callosum
#>  5 midline CC body premotor                 cc.bodypm.bbr.prep   corpus callosum
#>  6 midline CC body temporal                 cc.bodyt.bbr.prep    corpus callosum
#>  7 midline CC genu                          cc.genu.bbr.prep     corpus callosum
#>  8 midline CC rostrum                       cc.rostrum.bbr.prep  corpus callosum
#>  9 midline CC splenium                      cc.splenium.bbr.prep corpus callosum
#> 10 left    arcuate fasciculus               lh.af.bbr.prep       association    
#> 11 left    acoustic radiation               lh.ar.bbr.prep       association    
#> 12 left    anterior thalamic radiation      lh.atr.bbr.prep      association    
#> 13 left    cingulum dorsal                  lh.cbd.bbr.prep      limbic         
#> 14 left    cingulum ventral                 lh.cbv.bbr.prep      limbic         
#> 15 left    corticospinal tract              lh.cst.bbr.prep      projection     
#> 16 left    extreme capsule                  lh.emc.bbr.prep      limbic         
#> 17 left    frontal aslant tract             lh.fat.bbr.prep      association    
#> 18 left    fornix                           lh.fx.bbr.prep       association    
#> 19 left    inferior longitudinal fasciculus lh.ilf.bbr.prep      limbic         
#> 20 left    middle longitudinal fasciculus   lh.mlf.bbr.prep      association    
#> 21 left    optic radiation                  lh.or.bbr.prep       association    
#> 22 left    SLF I                            lh.slf1.bbr.prep     association    
#> 23 left    SLF II                           lh.slf2.bbr.prep     association    
#> 24 left    SLF III                          lh.slf3.bbr.prep     association    
#> 25 left    uncinate fasciculus              lh.uf.bbr.prep       limbic         
#> 26 midline middle cerebellar peduncle       mcp.bbr.prep         cerebellar     
#> 27 right   arcuate fasciculus               rh.af.bbr.prep       association    
#> 28 right   acoustic radiation               rh.ar.bbr.prep       association    
#> 29 right   anterior thalamic radiation      rh.atr.bbr.prep      association    
#> 30 right   cingulum dorsal                  rh.cbd.bbr.prep      limbic         
#> 31 right   cingulum ventral                 rh.cbv.bbr.prep      limbic         
#> 32 right   corticospinal tract              rh.cst.bbr.prep      projection     
#> 33 right   extreme capsule                  rh.emc.bbr.prep      limbic         
#> 34 right   frontal aslant tract             rh.fat.bbr.prep      association    
#> 35 right   fornix                           rh.fx.bbr.prep       association    
#> 36 right   inferior longitudinal fasciculus rh.ilf.bbr.prep      limbic         
#> 37 right   middle longitudinal fasciculus   rh.mlf.bbr.prep      association    
#> 38 right   optic radiation                  rh.or.bbr.prep       association    
#> 39 right   SLF I                            rh.slf1.bbr.prep     association    
#> 40 right   SLF II                           rh.slf2.bbr.prep     association    
#> 41 right   SLF III                          rh.slf3.bbr.prep     association    
#> 42 right   uncinate fasciculus              rh.uf.bbr.prep       limbic         

atlas_regions(tracula())
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
```
