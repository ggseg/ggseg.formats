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
[`suit()`](https://ggsegverse.github.io/ggseg.formats/reference/suit.md),
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
#>    hemi                  region                      label
#> 1  left                bankssts                lh_bankssts
#> 2  left caudalanteriorcingulate lh_caudalanteriorcingulate
#> 3  left     caudalmiddlefrontal     lh_caudalmiddlefrontal
#> 4  left          corpuscallosum          lh_corpuscallosum
#> 5  left                  cuneus                  lh_cuneus
#> 6  left              entorhinal              lh_entorhinal
#> 7  left                fusiform                lh_fusiform
#> 8  left        inferiorparietal        lh_inferiorparietal
#> 9  left        inferiortemporal        lh_inferiortemporal
#> 10 left        isthmuscingulate        lh_isthmuscingulate
#>                                names         lobe
#> 1  banks of superior temporal sulcus     temporal
#> 2          caudal anterior cingulate    cingulate
#> 3              caudal middle frontal      frontal
#> 4                    corpus callosum white matter
#> 5                             cuneus    occipital
#> 6                         entorhinal     temporal
#> 7                           fusiform     temporal
#> 8                  inferior parietal     parietal
#> 9                  inferior temporal     temporal
#> 10                 isthmus cingulate    cingulate
#> ... with 60 more rows
plot(dk())

atlas_regions(dk())
#>  [1] "bankssts"                 "caudalanteriorcingulate" 
#>  [3] "caudalmiddlefrontal"      "corpuscallosum"          
#>  [5] "cuneus"                   "entorhinal"              
#>  [7] "frontalpole"              "fusiform"                
#>  [9] "inferiorparietal"         "inferiortemporal"        
#> [11] "insula"                   "isthmuscingulate"        
#> [13] "lateraloccipital"         "lateralorbitofrontal"    
#> [15] "lingual"                  "medialorbitofrontal"     
#> [17] "middletemporal"           "paracentral"             
#> [19] "parahippocampal"          "parsopercularis"         
#> [21] "parsorbitalis"            "parstriangularis"        
#> [23] "pericalcarine"            "postcentral"             
#> [25] "posteriorcingulate"       "precentral"              
#> [27] "precuneus"                "rostralanteriorcingulate"
#> [29] "rostralmiddlefrontal"     "superiorfrontal"         
#> [31] "superiorparietal"         "superiortemporal"        
#> [33] "supramarginal"            "temporalpole"            
#> [35] "transversetemporal"      
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
