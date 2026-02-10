# Desikan-Killiany Cortical Atlas

Brain atlas for the Desikan-Killiany cortical parcellation with 34
regions per hemisphere (68 total) on the cortical surface.

## Usage

``` r
data(dk)
```

## Format

A `ggseg_atlas` object with components:

- atlas:

  Character. Atlas name ("dk")

- type:

  Character. Atlas type ("cortical")

- palette:

  Named character vector of colours for each region

- data:

  A `ggseg_data_cortical` object containing:

  vertices

  :   Data frame with `label` and `vertices` columns

  sf

  :   Simple features data frame for 2D rendering

## Details

This atlas is based on the FreeSurfer `aparc` annotation and is one of
the most widely used cortical parcellations in neuroimaging research.

The atlas works with both ggseg (2D polygon plots) and ggseg3d (3D mesh
visualizations) from a single object.

## Regions

The atlas contains 34 regions per hemisphere including: banks of
superior temporal sulcus, caudal anterior cingulate, caudal middle
frontal, cuneus, entorhinal, fusiform, inferior parietal, inferior
temporal, isthmus cingulate, lateral occipital, lateral orbitofrontal,
lingual, medial orbitofrontal, middle temporal, parahippocampal,
paracentral, pars opercularis, pars orbitalis, pars triangularis,
pericalcarine, postcentral, posterior cingulate, precentral, precuneus,
rostral anterior cingulate, rostral middle frontal, superior frontal,
superior parietal, superior temporal, supramarginal, frontal pole,
temporal pole, transverse temporal, and insula.

## Usage

    plot(dk)

    # 3D plot with ggseg3d
    library(ggseg3d)
    ggseg3d(atlas = dk)

## References

Desikan RS, Ségonne F, Fischl B, et al. (2006). An automated labeling
system for subdividing the human cerebral cortex on MRI scans into gyral
based regions of interest. NeuroImage, 31(3):968-980.
[doi:10.1016/j.neuroimage.2006.01.021](https://doi.org/10.1016/j.neuroimage.2006.01.021)

Fischl B, van der Kouwe A, Destrieux C, et al. (2004). Automatically
parcellating the human cerebral cortex. Cerebral Cortex, 14(1):11-22.
[doi:10.1093/cercor/bhg087](https://doi.org/10.1093/cercor/bhg087)

## See also

[aseg](https://ggseg.github.io/ggseg.formats/reference/aseg.md) for
subcortical structures,
[`ggseg_atlas()`](https://ggseg.github.io/ggseg.formats/reference/ggseg_atlas.md)
for the atlas class constructor

Other ggseg_atlases:
[`aseg`](https://ggseg.github.io/ggseg.formats/reference/aseg.md),
[`tracula`](https://ggseg.github.io/ggseg.formats/reference/tracula.md)

## Examples

``` r
data(dk)
dk
#> 
#> ── dk ggseg atlas ──────────────────────────────────────────────────────────────
#> Type: cortical
#> Regions: 35
#> Hemispheres: left, right
#> Views: inferior, lateral, medial, superior
#> Palette: ✔
#> Rendering: ✔ ggseg
#> ✔ ggseg3d (vertices)
#> ────────────────────────────────────────────────────────────────────────────────
#> # A tibble: 70 × 4
#>    hemi  region                            label                      lobe      
#>    <chr> <chr>                             <chr>                      <chr>     
#>  1 left  banks of superior temporal sulcus lh_bankssts                temporal  
#>  2 left  caudal anterior cingulate         lh_caudalanteriorcingulate cingulate 
#>  3 left  caudal middle frontal             lh_caudalmiddlefrontal     frontal   
#>  4 left  corpus callosum                   lh_corpuscallosum          white mat…
#>  5 left  cuneus                            lh_cuneus                  occipital 
#>  6 left  entorhinal                        lh_entorhinal              temporal  
#>  7 left  fusiform                          lh_fusiform                temporal  
#>  8 left  inferior parietal                 lh_inferiorparietal        parietal  
#>  9 left  inferior temporal                 lh_inferiortemporal        temporal  
#> 10 left  isthmus cingulate                 lh_isthmuscingulate        cingulate 
#> # ℹ 60 more rows

# List regions
atlas_regions(dk)
#>  [1] "banks of superior temporal sulcus" "caudal anterior cingulate"        
#>  [3] "caudal middle frontal"             "corpus callosum"                  
#>  [5] "cuneus"                            "entorhinal"                       
#>  [7] "frontal pole"                      "fusiform"                         
#>  [9] "inferior parietal"                 "inferior temporal"                
#> [11] "insula"                            "isthmus cingulate"                
#> [13] "lateral occipital"                 "lateral orbitofrontal"            
#> [15] "lingual"                           "medial orbitofrontal"             
#> [17] "middle temporal"                   "paracentral"                      
#> [19] "parahippocampal"                   "pars opercularis"                 
#> [21] "pars orbitalis"                    "pars triangularis"                
#> [23] "pericalcarine"                     "postcentral"                      
#> [25] "posterior cingulate"               "precentral"                       
#> [27] "precuneus"                         "rostral anterior cingulate"       
#> [29] "rostral middle frontal"            "superior frontal"                 
#> [31] "superior parietal"                 "superior temporal"                
#> [33] "supramarginal"                     "temporal pole"                    
#> [35] "transverse temporal"              

# List labels
atlas_labels(dk)
#>  [1] "lh_bankssts"                 "lh_caudalanteriorcingulate" 
#>  [3] "lh_caudalmiddlefrontal"      "lh_corpuscallosum"          
#>  [5] "lh_cuneus"                   "lh_entorhinal"              
#>  [7] "lh_frontalpole"              "lh_fusiform"                
#>  [9] "lh_inferiorparietal"         "lh_inferiortemporal"        
#> [11] "lh_insula"                   "lh_isthmuscingulate"        
#> [13] "lh_lateraloccipital"         "lh_lateralorbitofrontal"    
#> [15] "lh_lingual"                  "lh_medialorbitofrontal"     
#> [17] "lh_middletemporal"           "lh_paracentral"             
#> [19] "lh_parahippocampal"          "lh_parsopercularis"         
#> [21] "lh_parsorbitalis"            "lh_parstriangularis"        
#> [23] "lh_pericalcarine"            "lh_postcentral"             
#> [25] "lh_posteriorcingulate"       "lh_precentral"              
#> [27] "lh_precuneus"                "lh_rostralanteriorcingulate"
#> [29] "lh_rostralmiddlefrontal"     "lh_superiorfrontal"         
#> [31] "lh_superiorparietal"         "lh_superiortemporal"        
#> [33] "lh_supramarginal"            "lh_temporalpole"            
#> [35] "lh_transversetemporal"       "rh_bankssts"                
#> [37] "rh_caudalanteriorcingulate"  "rh_caudalmiddlefrontal"     
#> [39] "rh_corpuscallosum"           "rh_cuneus"                  
#> [41] "rh_entorhinal"               "rh_frontalpole"             
#> [43] "rh_fusiform"                 "rh_inferiorparietal"        
#> [45] "rh_inferiortemporal"         "rh_insula"                  
#> [47] "rh_isthmuscingulate"         "rh_lateraloccipital"        
#> [49] "rh_lateralorbitofrontal"     "rh_lingual"                 
#> [51] "rh_medialorbitofrontal"      "rh_middletemporal"          
#> [53] "rh_paracentral"              "rh_parahippocampal"         
#> [55] "rh_parsopercularis"          "rh_parsorbitalis"           
#> [57] "rh_parstriangularis"         "rh_pericalcarine"           
#> [59] "rh_postcentral"              "rh_posteriorcingulate"      
#> [61] "rh_precentral"               "rh_precuneus"               
#> [63] "rh_rostralanteriorcingulate" "rh_rostralmiddlefrontal"    
#> [65] "rh_superiorfrontal"          "rh_superiorparietal"        
#> [67] "rh_superiortemporal"         "rh_supramarginal"           
#> [69] "rh_temporalpole"             "rh_transversetemporal"      
```
