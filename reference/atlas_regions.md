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
atlas_regions(aseg())
#>  [1] "accumbens area"    "amygdala"          "brain stem"       
#>  [4] "caudate"           "cc anterior"       "cc central"       
#>  [7] "cc mid anterior"   "cc mid posterior"  "cc posterior"     
#> [10] "cerebellum cortex" "choroid plexus"    "hippocampus"      
#> [13] "optic chiasm"      "pallidum"          "putamen"          
#> [16] "thalamus"          "ventraldc"         "vessel"           
```
