# Desikan-Killiany Cortical Atlas

Brain atlas for the Desikan-Killiany cortical parcellation with 34
regions per hemisphere (68 total) on the cortical surface.

## Usage

``` r
data(dk)
```

## Format

A `brain_atlas` object with components:

- atlas:

  Character. Atlas name ("dk")

- type:

  Character. Atlas type ("cortical")

- palette:

  Named character vector of colours for each region

- data:

  A `cortical_data` object containing:

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

    # 2D plot with ggseg
    library(ggseg)
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

[aseg](aseg.md) for subcortical structures,
[`brain_atlas()`](brain_atlas.md) for the atlas class constructor

Other ggseg_atlases: [`aseg`](aseg.md)

## Examples

``` r
data(dk)
dk
#> 
#> ── dk ggseg atlas ──────────────────────────────────────────────────────────────
#> Type: cortical
#> Regions: 35
#> Hemispheres: left, right
#> Views: lateral, medial
#> Palette: ✔
#> Rendering: ✔ ggseg
#> ✔ ggseg3d (vertices)
#> ────────────────────────────────────────────────────────────────────────────────
#> # A tibble: 90 × 3
#>    hemi  region                label                  
#>    <chr> <chr>                 <chr>                  
#>  1 left  NA                    lh_unknown             
#>  2 left  bankssts              lh_bankssts            
#>  3 left  caudal middle frontal lh_caudalmiddlefrontal 
#>  4 left  fusiform              lh_fusiform            
#>  5 left  inferior parietal     lh_inferiorparietal    
#>  6 left  inferior temporal     lh_inferiortemporal    
#>  7 left  lateral occipital     lh_lateraloccipital    
#>  8 left  lateral orbitofrontal lh_lateralorbitofrontal
#>  9 left  middle temporal       lh_middletemporal      
#> 10 left  pars opercularis      lh_parsopercularis     
#> # ℹ 80 more rows

# List regions
brain_regions(dk)
#>  [1] "bankssts"                   "caudal anterior cingulate" 
#>  [3] "caudal middle frontal"      "corpus callosum"           
#>  [5] "cuneus"                     "entorhinal"                
#>  [7] "frontal pole"               "fusiform"                  
#>  [9] "inferior parietal"          "inferior temporal"         
#> [11] "insula"                     "isthmus cingulate"         
#> [13] "lateral occipital"          "lateral orbitofrontal"     
#> [15] "lingual"                    "medial orbitofrontal"      
#> [17] "middle temporal"            "paracentral"               
#> [19] "parahippocampal"            "pars opercularis"          
#> [21] "pars orbitalis"             "pars triangularis"         
#> [23] "pericalcarine"              "postcentral"               
#> [25] "posterior cingulate"        "precentral"                
#> [27] "precuneus"                  "rostral anterior cingulate"
#> [29] "rostral middle frontal"     "superior frontal"          
#> [31] "superior parietal"          "superior temporal"         
#> [33] "supramarginal"              "temporal pole"             
#> [35] "transverse temporal"       

# List labels
brain_labels(dk)
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
#> [35] "lh_transversetemporal"       "lh_unknown"                 
#> [37] "rh_bankssts"                 "rh_caudalanteriorcingulate" 
#> [39] "rh_caudalmiddlefrontal"      "rh_corpuscallosum"          
#> [41] "rh_cuneus"                   "rh_entorhinal"              
#> [43] "rh_frontalpole"              "rh_fusiform"                
#> [45] "rh_inferiorparietal"         "rh_inferiortemporal"        
#> [47] "rh_insula"                   "rh_isthmuscingulate"        
#> [49] "rh_lateraloccipital"         "rh_lateralorbitofrontal"    
#> [51] "rh_lingual"                  "rh_medialorbitofrontal"     
#> [53] "rh_middletemporal"           "rh_paracentral"             
#> [55] "rh_parahippocampal"          "rh_parsopercularis"         
#> [57] "rh_parsorbitalis"            "rh_parstriangularis"        
#> [59] "rh_pericalcarine"            "rh_postcentral"             
#> [61] "rh_posteriorcingulate"       "rh_precentral"              
#> [63] "rh_precuneus"                "rh_rostralanteriorcingulate"
#> [65] "rh_rostralmiddlefrontal"     "rh_superiorfrontal"         
#> [67] "rh_superiorparietal"         "rh_superiortemporal"        
#> [69] "rh_supramarginal"            "rh_temporalpole"            
#> [71] "rh_transversetemporal"       "rh_unknown"                 
```
