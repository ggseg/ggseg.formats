

<!-- README.md is generated from README.Rmd. Please edit that file -->

# ggseg.formats

<!-- badges: start -->

[![R-CMD-check](https://github.com/ggseg/ggseg.formats/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ggseg/ggseg.formats/actions/workflows/R-CMD-check.yaml)
[![CRAN
status](https://www.r-pkg.org/badges/version/ggseg.formats)](https://CRAN.R-project.org/package=ggseg.formats)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![pkgcheck](https://github.com/ggseg/ggseg.formats/workflows/pkgcheck/badge.svg)](https://github.com/ggseg/ggseg.formats/actions?query=workflow%3Apkgcheck)
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
```

``` r
plot(dk())
```

<img src="man/figures/README-plot-dk-1.png" style="width:100.0%" />

``` r
plot(aseg())
```

<img src="man/figures/README-plot-aseg-1.png" style="width:100.0%" />

``` r
plot(tracula())
```

<img src="man/figures/README-plot-tracula-1.png" style="width:100.0%" />

## Quick example

Atlas objects are designed for exploration and customisation. You can
query regions, filter views, and pipe operations together:

``` r
aseg_small <- aseg() |>
  atlas_region_keep("hippocampus|amygdala|thalamus") |>
  atlas_view_keep("coronal_3|axial_3") |>
  atlas_view_gather()
plot(aseg_small)
```

<img src="man/figures/README-subset-aseg-1.png" style="width:100.0%" />

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

- `vignette("ggseg.formats")` — understanding atlas structure and
  accessors
- `vignette("atlas-manipulation")` — region, view, and metadata
  manipulation
