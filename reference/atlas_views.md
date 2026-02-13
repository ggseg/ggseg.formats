# Get available views in atlas

Get available views in atlas

## Usage

``` r
atlas_views(atlas)

brain_views(atlas)
```

## Arguments

- atlas:

  A `ggseg_atlas` object

## Value

Character vector of view names, or NULL if no sf data

## Examples

``` r
atlas_views(aseg())
#> [1] "axial_3"   "axial_5"   "coronal_2" "coronal_3" "coronal_4" "sagittal" 
atlas_views(tracula())
#> [1] "axial_2"          "axial_4"          "coronal_3"        "coronal_4"       
#> [5] "sagittal_left"    "sagittal_midline" "sagittal_right"  
```
