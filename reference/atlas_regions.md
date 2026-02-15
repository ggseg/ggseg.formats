# Extract unique region names from an atlas

Extract unique region names from an atlas

## Usage

``` r
atlas_regions(x)

brain_regions(x)
```

## Arguments

- x:

  brain atlas

## Value

Character vector of region names

## Examples

``` r
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
atlas_regions(aseg())
#>  [1] "Amygdala"         "Brain Stem"       "Caudate"          "Cerebellum"      
#>  [5] "Hippocampus"      "Optic Chiasm"     "Pallidum"         "Putamen"         
#>  [9] "Thalamus"         "Thalamus Proper"  "accumbens area"   "cc anterior"     
#> [13] "cc central"       "cc mid anterior"  "cc mid posterior" "cc posterior"    
#> [17] "choroid plexus"   "ventraldc"        "vessel"          
```
