# SUIT Cerebellar Lobular Atlas

Returns the SUIT cerebellar parcellation (Diedrichsen et al., 2009): the
cerebellar cortex split into anatomical lobules plus the deep nuclei
(dentate, interposed, fastigial).

## Usage

``` r
suit()
```

## Value

A `ggseg_atlas` object with components:

- atlas:

  Character. Atlas name ("suit")

- type:

  Character. Atlas type ("cerebellar")

- palette:

  Named character vector of colours for each region

- data:

  A `ggseg_data_cerebellar` object containing:

  geom

  :   A `brain_polygons` table for 2D rendering

  vertices

  :   Vertex indices for surface lobules

  meshes

  :   Per-structure 3D meshes for the deep nuclei

## Details

Surface lobules carry vertex indices into the shared SUIT cerebellar
mesh (see
[`get_cerebellar_mesh()`](https://ggsegverse.github.io/ggseg.formats/reference/get_cerebellar_mesh.md));
deep nuclei carry individual 3D meshes. The 2D geometry is stored in the
sf-optional polygon (`geom`) representation, so the atlas renders with
ggseg without requiring sf installed.

## References

Diedrichsen J, Balsters JH, Flavell J, et al. (2009). A probabilistic MR
atlas of the human cerebellum. NeuroImage, 46(1):39-46.
[doi:10.1016/j.neuroimage.2009.01.045](https://doi.org/10.1016/j.neuroimage.2009.01.045)

## See also

[`dk()`](https://ggsegverse.github.io/ggseg.formats/reference/dk.md) for
cortical parcellation,
[`aseg()`](https://ggsegverse.github.io/ggseg.formats/reference/aseg.md)
for subcortical structures,
[`tracula()`](https://ggsegverse.github.io/ggseg.formats/reference/tracula.md)
for white-matter tracts,
[`ggseg_atlas()`](https://ggsegverse.github.io/ggseg.formats/reference/ggseg_atlas.md)
for the atlas class constructor

Other ggseg_atlases:
[`aseg()`](https://ggsegverse.github.io/ggseg.formats/reference/aseg.md),
[`dk()`](https://ggsegverse.github.io/ggseg.formats/reference/dk.md),
[`tracula()`](https://ggsegverse.github.io/ggseg.formats/reference/tracula.md)

## Examples

``` r
suit()
#> 
#> ── suit ggseg atlas ────────────────────────────────────────────────────────────
#> Type: cerebellar
#> Regions: 13
#> Hemispheres: left, right, vermis
#> Views: flatmap, nuclei
#> Palette: ✔
#> Rendering: ✔ ggseg
#> ✔ ggseg3d (meshes)
#> ────────────────────────────────────────────────────────────────────────────────
#> # A tibble: 34 × 3
#>    hemi   region     label           
#>    <chr>  <chr>      <chr>           
#>  1 left   I_IV       left_I_IV       
#>  2 right  I_IV       right_I_IV      
#>  3 left   V          left_V          
#>  4 right  V          right_V         
#>  5 left   VI         left_VI         
#>  6 vermis VI         vermis_VI       
#>  7 right  VI         right_VI        
#>  8 left   CrusI      left_CrusI      
#>  9 vermis CrusI      vermis_CrusI    
#> 10 right  CrusI      right_CrusI     
#> 11 left   CrusII     left_CrusII     
#> 12 vermis CrusII     vermis_CrusII   
#> 13 right  CrusII     right_CrusII    
#> 14 left   VIIb       left_VIIb       
#> 15 vermis VIIb       vermis_VIIb     
#> 16 right  VIIb       right_VIIb      
#> 17 left   VIIIa      left_VIIIa      
#> 18 vermis VIIIa      vermis_VIIIa    
#> 19 right  VIIIa      right_VIIIa     
#> 20 left   VIIIb      left_VIIIb      
#> 21 vermis VIIIb      vermis_VIIIb    
#> 22 right  VIIIb      right_VIIIb     
#> 23 left   IX         left_IX         
#> 24 vermis IX         vermis_IX       
#> 25 right  IX         right_IX        
#> 26 left   X          left_X          
#> 27 vermis X          vermis_X        
#> 28 right  X          right_X         
#> 29 left   Dentate    left_Dentate    
#> 30 right  Dentate    right_Dentate   
#> 31 left   Interposed left_Interposed 
#> 32 right  Interposed right_Interposed
#> 33 left   Fastigial  left_Fastigial  
#> 34 right  Fastigial  right_Fastigial 
atlas_regions(suit())
#>  [1] "CrusI"      "CrusII"     "Dentate"    "Fastigial"  "IX"        
#>  [6] "I_IV"       "Interposed" "V"          "VI"         "VIIIa"     
#> [11] "VIIIb"      "VIIb"       "X"         
atlas_geometry_type(suit())
#> [1] "polygon"
```
