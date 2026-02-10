# FreeSurfer Automatic Subcortical Segmentation Atlas

Brain atlas for FreeSurfer's automatic subcortical segmentation (aseg),
containing deep brain structures including the thalamus, caudate,
putamen, pallidum, hippocampus, amygdala, accumbens, and ventricles.

## Usage

``` r
data(aseg)
```

## Format

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

[dk](https://ggseg.github.io/ggseg.formats/reference/dk.md) for cortical
parcellation,
[`ggseg_atlas()`](https://ggseg.github.io/ggseg.formats/reference/ggseg_atlas.md)
for the atlas class constructor

Other ggseg_atlases:
[`dk`](https://ggseg.github.io/ggseg.formats/reference/dk.md),
[`tracula`](https://ggseg.github.io/ggseg.formats/reference/tracula.md)

## Examples

``` r
data(aseg)
aseg
#> 
#> ── aseg ggseg atlas ────────────────────────────────────────────────────────────
#> Type: subcortical
#> Regions: 17
#> Hemispheres: left, NA, right
#> Views: axial_3, axial_5, coronal_2, coronal_3, coronal_4, sagittal
#> Palette: ✔
#> Rendering: ✔ ggseg
#> ✔ ggseg3d (meshes)
#> ────────────────────────────────────────────────────────────────────────────────
#> # A tibble: 27 × 4
#>    hemi  region               label               structure    
#>    <chr> <chr>                <chr>               <chr>        
#>  1 left  thalamus             Left-Thalamus       thalamus     
#>  2 left  caudate              Left-Caudate        basal ganglia
#>  3 left  putamen              Left-Putamen        basal ganglia
#>  4 left  pallidum             Left-Pallidum       basal ganglia
#>  5 NA    brain stem           Brain-Stem          brain stem   
#>  6 left  hippocampus          Left-Hippocampus    limbic       
#>  7 left  amygdala             Left-Amygdala       limbic       
#>  8 left  nucleus accumbens    Left-Accumbens-area basal ganglia
#>  9 left  ventral diencephalon Left-VentralDC      diencephalon 
#> 10 left  vessel               Left-vessel         NA           
#> # ℹ 17 more rows

# List regions
atlas_regions(aseg)
#>  [1] "amygdala"                      "brain stem"                   
#>  [3] "caudate"                       "choroid plexus"               
#>  [5] "corpus callosum anterior"      "corpus callosum central"      
#>  [7] "corpus callosum mid-anterior"  "corpus callosum mid-posterior"
#>  [9] "corpus callosum posterior"     "hippocampus"                  
#> [11] "nucleus accumbens"             "optic chiasm"                 
#> [13] "pallidum"                      "putamen"                      
#> [15] "thalamus"                      "ventral diencephalon"         
#> [17] "vessel"                       
```
