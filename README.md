
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ggseg.formats

<!-- badges: start -->

[![R-CMD-check](https://github.com/ggseg/ggseg.formats/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ggseg/ggseg.formats/actions/workflows/R-CMD-check.yaml)
[![CRAN
status](https://www.r-pkg.org/badges/version/ggseg.formats)](https://CRAN.R-project.org/package=ggseg.formats)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

ggseg.formats provides the `ggseg_atlas` S3 class that powers the
[ggseg](https://ggseg.github.io/ggseg/) ecosystem for 2D and 3D brain
visualisation. It ships three bundled atlases, a set of accessor
functions for querying atlas contents, and a pipe-friendly manipulation
API for subsetting, renaming, and enriching atlas objects.

## Bundled atlases

The package includes three atlases covering the main atlas types:

- **dk** — Desikan-Killiany cortical parcellation (68 regions)
- **aseg** — FreeSurfer automatic subcortical segmentation
- **tracula** — TRACULA white matter tract atlas

``` r
library(ggseg.formats)
dk
#> 
#> ── dk ggseg atlas ──────────────────────────────────────────────────────────────
#> Type: cortical
#> Regions: 36
#> Hemispheres: left, right
#> Views: inferior, lateral, medial, superior
#> Palette: ✔
#> Rendering: ✔ ggseg
#> ✔ ggseg3d (vertices)
#> ────────────────────────────────────────────────────────────────────────────────
#> # A tibble: 72 × 4
#>    hemi  region                            label                      lobe      
#>    <chr> <chr>                             <chr>                      <chr>     
#>  1 left  banks of superior temporal sulcus lh_bankssts                temporal  
#>  2 left  caudal anterior cingulate         lh_caudalanteriorcingulate cingulate 
#>  3 left  caudal middle frontal             lh_caudalmiddlefrontal     frontal   
#>  4 left  corpus callosum                   lh_corpuscallosum          white mat…
#>  5 left  cuneus                            lh_cuneus                  occipital 
#>  6 left  entorhinal                        lh_entorhinal              temporal  
#>  7 left  fusiform                          lh_fusiform                temporal  
#>  8 left  inferior parietal                 lh_inferiorparietal        parietal  
#>  9 left  inferior temporal                 lh_inferiortemporal        temporal  
#> 10 left  isthmus cingulate                 lh_isthmuscingulate        cingulate 
#> # ℹ 62 more rows
```

``` r
plot(dk)
```

<img src="man/figures/README-plot-dk-1.png" alt="" width="100%" />

``` r
plot(aseg)
```

<img src="man/figures/README-plot-aseg-1.png" alt="" width="100%" />

``` r
plot(tracula)
```

<img src="man/figures/README-plot-tracula-1.png" alt="" width="100%" />

## Quick example

Atlas objects are designed for exploration and customisation. You can
query regions, filter views, and pipe operations together:

``` r
aseg |>
  atlas_region_keep("hippocampus|amygdala|thalamus") |>
  atlas_view_keep("sagittal") |>
  atlas_view_gather()
#> 
#> ── aseg ggseg atlas ────────────────────────────────────────────────────────────
#> Type: subcortical
#> Regions: 3
#> Hemispheres: left, right
#> Views: sagittal
#> Palette: ✔
#> Rendering: ✔ ggseg
#> ✔ ggseg3d (meshes)
#> ────────────────────────────────────────────────────────────────────────────────
#> # A tibble: 6 × 4
#>   hemi  region      label             structure
#>   <chr> <chr>       <chr>             <chr>    
#> 1 left  thalamus    Left-Thalamus     thalamus 
#> 2 left  hippocampus Left-Hippocampus  limbic   
#> 3 left  amygdala    Left-Amygdala     limbic   
#> 4 right thalamus    Right-Thalamus    thalamus 
#> 5 right hippocampus Right-Hippocampus limbic   
#> 6 right amygdala    Right-Amygdala    limbic
```

## Installation

Install from the ggseg r-universe:

``` r
options(repos = c(
    ggseg = 'https://ggseg.r-universe.dev',
    CRAN = 'https://cloud.r-project.org'))

install.packages('ggseg.formats')
```

Or install the development version from GitHub:

``` r
# install.packages("devtools")
devtools::install_github("ggseg/ggseg.formats")
```

## Learn more

- [The ggseg_atlas
  object](https://ggseg.github.io/ggseg.formats/articles/brain-atlas-class.html)
  — understanding atlas structure and accessors
- [Customising brain
  atlases](https://ggseg.github.io/ggseg.formats/articles/atlas-manipulation.html)
  — region, view, and metadata manipulation
