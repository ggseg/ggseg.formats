# FreeSurfer Automatic Subcortical Segmentation Atlas

Returns the FreeSurfer automatic subcortical segmentation (aseg) atlas
containing deep brain structures including the thalamus, caudate,
putamen, pallidum, hippocampus, amygdala, accumbens, and ventricles.

## Usage

``` r
aseg()
```

## Value

A `ggseg_atlas` object with components:

- atlas:

  Character. Atlas name ("aseg")

- type:

  Character. Atlas type ("subcortical")

- palette:

  Named character vector of colours for each region

- data:

  A `ggseg_data_subcortical` object containing:

  meshes

  :   Data frame with `label` and `mesh` columns

  sf

  :   Simple features data frame for 2D rendering

## Details

This atlas is derived from FreeSurfer's `aseg.mgz` volumetric
segmentation. It works with both ggseg (2D slice views) and ggseg3d (3D
mesh visualizations) from a single object.

## Structures

The atlas contains bilateral structures:

- Thalamus

- Caudate

- Putamen

- Pallidum (globus pallidus)

- Hippocampus

- Amygdala

- Accumbens (nucleus accumbens)

- Ventral diencephalon

Plus midline and ventricular structures:

- Lateral ventricles

- Third ventricle

- Fourth ventricle

- Brain stem

- Cerebellar cortex

- Cerebellar white matter

## References

Fischl B, Salat DH, Busa E, et al. (2002). Whole brain segmentation:
automated labeling of neuroanatomical structures in the human brain.
Neuron, 33(3):341-355.
[doi:10.1016/S0896-6273(02)00569-X](https://doi.org/10.1016/S0896-6273%2802%2900569-X)

## See also

[`dk()`](https://ggsegverse.github.io/ggseg.formats/reference/dk.md) for
cortical parcellation,
[`ggseg_atlas()`](https://ggsegverse.github.io/ggseg.formats/reference/ggseg_atlas.md)
for the atlas class constructor

Other ggseg_atlases:
[`dk()`](https://ggsegverse.github.io/ggseg.formats/reference/dk.md),
[`tracula()`](https://ggsegverse.github.io/ggseg.formats/reference/tracula.md)

## Examples

``` r
aseg()
#> 
#> ── aseg ggseg atlas ────────────────────────────────────────────────────────────
#> Type: subcortical
#> Regions: 19
#> Hemispheres: left, NA, right
#> Views: axial_3, axial_4, axial_5, axial_6, coronal_1, coronal_2, sagittal
#> Palette: ✔
#> Rendering: ✔ ggseg
#> ✔ ggseg3d (meshes)
#> ────────────────────────────────────────────────────────────────────────────────
#> # A tibble: 47 × 4
#>    hemi  region           label                   structure    
#>    <chr> <chr>            <chr>                   <chr>        
#>  1 left  Cerebellum       Left-Cerebellum-Cortex  cerebellum   
#>  2 left  Cerebellum       Left-Cerebellum-Cortex  cerebellum   
#>  3 left  Thalamus         Left-Thalamus           basal ganglia
#>  4 left  Thalamus         Left-Thalamus           basal ganglia
#>  5 left  Thalamus Proper  Left-Thalamus           basal ganglia
#>  6 left  Thalamus Proper  Left-Thalamus           basal ganglia
#>  7 left  Caudate          Left-Caudate            basal ganglia
#>  8 left  Caudate          Left-Caudate            basal ganglia
#>  9 left  Putamen          Left-Putamen            basal ganglia
#> 10 left  Putamen          Left-Putamen            basal ganglia
#> 11 left  Pallidum         Left-Pallidum           basal ganglia
#> 12 left  Pallidum         Left-Pallidum           basal ganglia
#> 13 NA    Brain Stem       Brain-Stem              brainstem    
#> 14 left  Hippocampus      Left-Hippocampus        limbic       
#> 15 left  Hippocampus      Left-Hippocampus        limbic       
#> 16 left  Amygdala         Left-Amygdala           limbic       
#> 17 left  Amygdala         Left-Amygdala           limbic       
#> 18 left  accumbens area   Left-Accumbens-area     NA           
#> 19 left  ventraldc        Left-VentralDC          NA           
#> 20 left  vessel           Left-vessel             NA           
#> 21 left  choroid plexus   Left-choroid-plexus     NA           
#> 22 right Cerebellum       Right-Cerebellum-Cortex cerebellum   
#> 23 right Cerebellum       Right-Cerebellum-Cortex cerebellum   
#> 24 right Thalamus         Right-Thalamus          basal ganglia
#> 25 right Thalamus         Right-Thalamus          basal ganglia
#> 26 right Thalamus Proper  Right-Thalamus          basal ganglia
#> 27 right Thalamus Proper  Right-Thalamus          basal ganglia
#> 28 right Caudate          Right-Caudate           basal ganglia
#> 29 right Caudate          Right-Caudate           basal ganglia
#> 30 right Putamen          Right-Putamen           basal ganglia
#> 31 right Putamen          Right-Putamen           basal ganglia
#> 32 right Pallidum         Right-Pallidum          basal ganglia
#> 33 right Pallidum         Right-Pallidum          basal ganglia
#> 34 right Hippocampus      Right-Hippocampus       limbic       
#> 35 right Hippocampus      Right-Hippocampus       limbic       
#> 36 right Amygdala         Right-Amygdala          limbic       
#> 37 right Amygdala         Right-Amygdala          limbic       
#> 38 right accumbens area   Right-Accumbens-area    NA           
#> 39 right ventraldc        Right-VentralDC         NA           
#> 40 right vessel           Right-vessel            NA           
#> 41 right choroid plexus   Right-choroid-plexus    NA           
#> 42 NA    Optic Chiasm     Optic-Chiasm            other        
#> 43 NA    cc posterior     CC_Posterior            NA           
#> 44 NA    cc mid posterior CC_Mid_Posterior        NA           
#> 45 NA    cc central       CC_Central              NA           
#> 46 NA    cc mid anterior  CC_Mid_Anterior         NA           
#> 47 NA    cc anterior      CC_Anterior             NA           

atlas_regions(aseg())
#>  [1] "Amygdala"         "Brain Stem"       "Caudate"          "Cerebellum"      
#>  [5] "Hippocampus"      "Optic Chiasm"     "Pallidum"         "Putamen"         
#>  [9] "Thalamus"         "Thalamus Proper"  "accumbens area"   "cc anterior"     
#> [13] "cc central"       "cc mid anterior"  "cc mid posterior" "cc posterior"    
#> [17] "choroid plexus"   "ventraldc"        "vessel"          
```
