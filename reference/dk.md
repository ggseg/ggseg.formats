# Desikan-Killiany Cortical Atlas

Returns the Desikan-Killiany cortical parcellation atlas with 34 regions
per hemisphere (68 total) on the cortical surface.

## Usage

``` r
dk()
```

## Value

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

## References

Desikan RS, Segonne F, Fischl B, et al. (2006). An automated labeling
system for subdividing the human cerebral cortex on MRI scans into gyral
based regions of interest. NeuroImage, 31(3):968-980.
[doi:10.1016/j.neuroimage.2006.01.021](https://doi.org/10.1016/j.neuroimage.2006.01.021)

Fischl B, van der Kouwe A, Destrieux C, et al. (2004). Automatically
parcellating the human cerebral cortex. Cerebral Cortex, 14(1):11-22.
[doi:10.1093/cercor/bhg087](https://doi.org/10.1093/cercor/bhg087)

## See also

[`aseg()`](https://ggsegverse.github.io/ggseg.formats/reference/aseg.md)
for subcortical structures,
[`ggseg_atlas()`](https://ggsegverse.github.io/ggseg.formats/reference/ggseg_atlas.md)
for the atlas class constructor

Other ggseg_atlases:
[`aseg()`](https://ggsegverse.github.io/ggseg.formats/reference/aseg.md),
[`tracula()`](https://ggsegverse.github.io/ggseg.formats/reference/tracula.md)

## Examples

``` r
dk()
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
#>    hemi  region                            label                       lobe     
#>    <chr> <chr>                             <chr>                       <chr>    
#>  1 left  banks of superior temporal sulcus lh_bankssts                 temporal 
#>  2 left  caudal anterior cingulate         lh_caudalanteriorcingulate  cingulate
#>  3 left  caudal middle frontal             lh_caudalmiddlefrontal      frontal  
#>  4 left  corpus callosum                   lh_corpuscallosum           white ma…
#>  5 left  cuneus                            lh_cuneus                   occipital
#>  6 left  entorhinal                        lh_entorhinal               temporal 
#>  7 left  fusiform                          lh_fusiform                 temporal 
#>  8 left  inferior parietal                 lh_inferiorparietal         parietal 
#>  9 left  inferior temporal                 lh_inferiortemporal         temporal 
#> 10 left  isthmus cingulate                 lh_isthmuscingulate         cingulate
#> 11 left  lateral occipital                 lh_lateraloccipital         occipital
#> 12 left  lateral orbitofrontal             lh_lateralorbitofrontal     frontal  
#> 13 left  lingual                           lh_lingual                  occipital
#> 14 left  medial orbitofrontal              lh_medialorbitofrontal      frontal  
#> 15 left  middle temporal                   lh_middletemporal           temporal 
#> 16 left  parahippocampal                   lh_parahippocampal          temporal 
#> 17 left  paracentral                       lh_paracentral              frontal  
#> 18 left  pars opercularis                  lh_parsopercularis          frontal  
#> 19 left  pars orbitalis                    lh_parsorbitalis            frontal  
#> 20 left  pars triangularis                 lh_parstriangularis         frontal  
#> 21 left  pericalcarine                     lh_pericalcarine            occipital
#> 22 left  postcentral                       lh_postcentral              parietal 
#> 23 left  posterior cingulate               lh_posteriorcingulate       cingulate
#> 24 left  precentral                        lh_precentral               frontal  
#> 25 left  precuneus                         lh_precuneus                parietal 
#> 26 left  rostral anterior cingulate        lh_rostralanteriorcingulate cingulate
#> 27 left  rostral middle frontal            lh_rostralmiddlefrontal     frontal  
#> 28 left  superior frontal                  lh_superiorfrontal          frontal  
#> 29 left  superior parietal                 lh_superiorparietal         parietal 
#> 30 left  superior temporal                 lh_superiortemporal         temporal 
#> 31 left  supramarginal                     lh_supramarginal            parietal 
#> 32 left  frontal pole                      lh_frontalpole              frontal  
#> 33 left  temporal pole                     lh_temporalpole             temporal 
#> 34 left  transverse temporal               lh_transversetemporal       temporal 
#> 35 left  insula                            lh_insula                   insula   
#> 36 right banks of superior temporal sulcus rh_bankssts                 temporal 
#> 37 right caudal anterior cingulate         rh_caudalanteriorcingulate  cingulate
#> 38 right caudal middle frontal             rh_caudalmiddlefrontal      frontal  
#> 39 right corpus callosum                   rh_corpuscallosum           white ma…
#> 40 right cuneus                            rh_cuneus                   occipital
#> 41 right entorhinal                        rh_entorhinal               temporal 
#> 42 right fusiform                          rh_fusiform                 temporal 
#> 43 right inferior parietal                 rh_inferiorparietal         parietal 
#> 44 right inferior temporal                 rh_inferiortemporal         temporal 
#> 45 right isthmus cingulate                 rh_isthmuscingulate         cingulate
#> 46 right lateral occipital                 rh_lateraloccipital         occipital
#> 47 right lateral orbitofrontal             rh_lateralorbitofrontal     frontal  
#> 48 right lingual                           rh_lingual                  occipital
#> 49 right medial orbitofrontal              rh_medialorbitofrontal      frontal  
#> 50 right middle temporal                   rh_middletemporal           temporal 
#> 51 right parahippocampal                   rh_parahippocampal          temporal 
#> 52 right paracentral                       rh_paracentral              frontal  
#> 53 right pars opercularis                  rh_parsopercularis          frontal  
#> 54 right pars orbitalis                    rh_parsorbitalis            frontal  
#> 55 right pars triangularis                 rh_parstriangularis         frontal  
#> 56 right pericalcarine                     rh_pericalcarine            occipital
#> 57 right postcentral                       rh_postcentral              parietal 
#> 58 right posterior cingulate               rh_posteriorcingulate       cingulate
#> 59 right precentral                        rh_precentral               frontal  
#> 60 right precuneus                         rh_precuneus                parietal 
#> 61 right rostral anterior cingulate        rh_rostralanteriorcingulate cingulate
#> 62 right rostral middle frontal            rh_rostralmiddlefrontal     frontal  
#> 63 right superior frontal                  rh_superiorfrontal          frontal  
#> 64 right superior parietal                 rh_superiorparietal         parietal 
#> 65 right superior temporal                 rh_superiortemporal         temporal 
#> 66 right supramarginal                     rh_supramarginal            parietal 
#> 67 right frontal pole                      rh_frontalpole              frontal  
#> 68 right temporal pole                     rh_temporalpole             temporal 
#> 69 right transverse temporal               rh_transversetemporal       temporal 
#> 70 right insula                            rh_insula                   insula   

atlas_regions(dk())
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
atlas_labels(dk())
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
