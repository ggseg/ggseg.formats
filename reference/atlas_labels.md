# Extract unique labels from an atlas

Extract unique labels from an atlas

## Usage

``` r
atlas_labels(x)

brain_labels(x)
```

## Arguments

- x:

  brain atlas

## Value

Character vector of atlas region labels

## Examples

``` r
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
atlas_labels(aseg())
#>  [1] "Brain-Stem"              "CC_Anterior"            
#>  [3] "CC_Central"              "CC_Mid_Anterior"        
#>  [5] "CC_Mid_Posterior"        "CC_Posterior"           
#>  [7] "Left-Accumbens-area"     "Left-Amygdala"          
#>  [9] "Left-Caudate"            "Left-Cerebellum-Cortex" 
#> [11] "Left-Hippocampus"        "Left-Pallidum"          
#> [13] "Left-Putamen"            "Left-Thalamus"          
#> [15] "Left-VentralDC"          "Left-choroid-plexus"    
#> [17] "Left-vessel"             "Optic-Chiasm"           
#> [19] "Right-Accumbens-area"    "Right-Amygdala"         
#> [21] "Right-Caudate"           "Right-Cerebellum-Cortex"
#> [23] "Right-Hippocampus"       "Right-Pallidum"         
#> [25] "Right-Putamen"           "Right-Thalamus"         
#> [27] "Right-VentralDC"         "Right-choroid-plexus"   
#> [29] "Right-vessel"           
```
