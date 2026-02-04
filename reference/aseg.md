# FreeSurfer Automatic Subcortical Segmentation Atlas

Brain atlas for FreeSurfer's automatic subcortical segmentation (aseg),
containing deep brain structures including the thalamus, caudate,
putamen, pallidum, hippocampus, amygdala, accumbens, and ventricles.

## Usage

``` r
data(aseg)
```

## Format

A `brain_atlas` object with components:

- atlas:

  Character. Atlas name ("aseg")

- type:

  Character. Atlas type ("subcortical")

- palette:

  Named character vector of colours for each region

- data:

  A `subcortical_data` object containing:

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

## Usage

    # 2D plot with ggseg
    library(ggseg)
    plot(aseg)

    # 3D plot with ggseg3d
    library(ggseg3d)
    ggseg3d(atlas = aseg, hemisphere = "subcort") |>
      add_glassbrain()

## References

Fischl B, Salat DH, Busa E, et al. (2002). Whole brain segmentation:
automated labeling of neuroanatomical structures in the human brain.
Neuron, 33(3):341-355.
[doi:10.1016/S0896-6273(02)00569-X](https://doi.org/10.1016/S0896-6273%2802%2900569-X)

## See also

[dk](dk.md) for cortical parcellation, [`brain_atlas()`](brain_atlas.md)
for the atlas class constructor

Other ggseg_atlases: [`dk`](dk.md)

## Examples

``` r
data(aseg)
aseg
#> 
#> ── aseg ggseg atlas ────────────────────────────────────────────────────────────
#> Type: subcortical
#> Regions: 18
#> Hemispheres: right, left, midline
#> Views: coronal, sagittal
#> Palette: ✔
#> Rendering: ✔ ggseg
#> ✔ ggseg3d (meshes)
#> ────────────────────────────────────────────────────────────────────────────────
#> # A tibble: 29 × 3
#>    hemi  region            label                  
#>    <chr> <chr>             <chr>                  
#>  1 right NA                NA                     
#>  2 left  NA                NA                     
#>  3 left  thalamus proper   Left-Thalamus-Proper   
#>  4 right thalamus proper   Right-Thalamus-Proper  
#>  5 right lateral ventricle Right-Lateral-Ventricle
#>  6 left  hippocampus       Left-Hippocampus       
#>  7 left  lateral ventricle Left-Lateral-Ventricle 
#>  8 right putamen           Right-Putamen          
#>  9 right amygdala          Right-Amygdala         
#> 10 left  putamen           Left-Putamen           
#> # ℹ 19 more rows

# List regions
brain_regions(aseg)
#>  [1] "3rd ventricle"           "4th ventricle"          
#>  [3] "CC anterior"             "CC central"             
#>  [5] "CC mid anterior"         "CC mid posterior"       
#>  [7] "CC posterior"            "amygdala"               
#>  [9] "brain stem"              "caudate"                
#> [11] "cerebellum cortex"       "cerebellum white matter"
#> [13] "hippocampus"             "lateral ventricle"      
#> [15] "pallidum"                "putamen"                
#> [17] "thalamus proper"         "ventral DC"             
```
