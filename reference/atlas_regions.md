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

## See also

Other atlas accessors:
[`atlas_centerlines()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_centerlines.md),
[`atlas_geom()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_geom.md),
[`atlas_geometry_type()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_geometry_type.md),
[`atlas_labels()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_labels.md),
[`atlas_meshes()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_meshes.md),
[`atlas_palette()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_palette.md),
[`atlas_polygons()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_polygons.md),
[`atlas_sf()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_sf.md),
[`atlas_type()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_type.md),
[`atlas_vertices()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_vertices.md),
[`atlas_views()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_views.md)

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
