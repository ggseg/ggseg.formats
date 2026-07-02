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
[`suit()`](https://ggsegverse.github.io/ggseg.formats/reference/suit.md),
[`tracula()`](https://ggsegverse.github.io/ggseg.formats/reference/tracula.md)

## Examples

``` r
aseg()
#> 
#> ── aseg ggseg atlas ────────────────────────────────────────────────────────────
#> Type: subcortical
#> Regions: 19
#> Hemispheres: left, NA, right
#> Views: axial_3, axial_4, axial_5, sagittal, axial_6, coronal_1, coronal_2
#> Palette: ✔
#> Rendering: ✔ ggseg
#> ✔ ggseg3d (meshes)
#> ────────────────────────────────────────────────────────────────────────────────
#>    hemi          region                  label     structure
#> 1  left      Cerebellum Left-Cerebellum-Cortex    cerebellum
#> 2  left      Cerebellum Left-Cerebellum-Cortex    cerebellum
#> 3  left        Thalamus          Left-Thalamus basal ganglia
#> 4  left        Thalamus          Left-Thalamus basal ganglia
#> 5  left Thalamus Proper          Left-Thalamus basal ganglia
#> 6  left Thalamus Proper          Left-Thalamus basal ganglia
#> 7  left         Caudate           Left-Caudate basal ganglia
#> 8  left         Caudate           Left-Caudate basal ganglia
#> 9  left         Putamen           Left-Putamen basal ganglia
#> 10 left         Putamen           Left-Putamen basal ganglia
#> ... with 37 more rows
plot(aseg())

atlas_regions(aseg())
#>  [1] "Amygdala"         "Brain Stem"       "Caudate"          "Cerebellum"      
#>  [5] "Hippocampus"      "Optic Chiasm"     "Pallidum"         "Putamen"         
#>  [9] "Thalamus"         "Thalamus Proper"  "accumbens area"   "cc anterior"     
#> [13] "cc central"       "cc mid anterior"  "cc mid posterior" "cc posterior"    
#> [17] "choroid plexus"   "ventraldc"        "vessel"          
```
