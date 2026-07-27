# TRACULA White Matter Tract Atlas

Returns the TRACULA (TRActs Constrained by UnderLying Anatomy) white
matter bundle atlas in MNI space.

## Usage

``` r
tracula()
```

## Value

A `ggseg_atlas` object with components:

- atlas:

  Character. Atlas name ("tracula")

- type:

  Character. Atlas type ("tract")

- palette:

  Named character vector of colours for each tract

- data:

  A `ggseg_data_tract` object containing:

  centerlines

  :   List of centerline matrices per tract

  sf

  :   Simple features data frame for 2D rendering

## Details

This atlas contains major white matter tracts reconstructed from
diffusion MRI using FreeSurfer's TRACULA training data. It works with
both ggseg (2D slice projections) and ggseg3d (3D tube mesh
visualizations).

## References

Yendiki A, Panneck P, Srinivasan P, et al. (2011). Automated
probabilistic reconstruction of white-matter pathways in health and
disease using an atlas of the underlying anatomy. Frontiers in
Neuroinformatics, 5:23.
[doi:10.3389/fninf.2011.00023](https://doi.org/10.3389/fninf.2011.00023)

## See also

[`dk()`](https://ggsegverse.github.io/ggseg.formats/reference/dk.md) for
cortical parcellation,
[`aseg()`](https://ggsegverse.github.io/ggseg.formats/reference/aseg.md)
for subcortical structures,
[`ggseg_atlas()`](https://ggsegverse.github.io/ggseg.formats/reference/ggseg_atlas.md)
for the atlas class constructor

Other ggseg_atlases:
[`aseg()`](https://ggsegverse.github.io/ggseg.formats/reference/aseg.md),
[`dk()`](https://ggsegverse.github.io/ggseg.formats/reference/dk.md),
[`suit()`](https://ggsegverse.github.io/ggseg.formats/reference/suit.md)

## Examples

``` r
tracula()
#> 
#> ── tracula ggseg atlas ─────────────────────────────────────────────────────────
#> Type: tract
#> Regions: 26
#> Hemispheres: midline, left, right
#> Views: axial_2, axial_4, coronal_3, coronal_4, sagittal_midline, sagittal_left,
#> sagittal_right
#> Palette: ✔
#> Rendering: ✔ ggseg
#> ✔ ggseg3d (centerlines)
#> ────────────────────────────────────────────────────────────────────────────────
#>       hemi      region                label                           names
#> 1  midline       acomm       acomm.bbr.prep             anterior commissure
#> 2  midline    cc bodyc    cc.bodyc.bbr.prep    corpus callosum body central
#> 3  midline    cc bodyp    cc.bodyp.bbr.prep   corpus callosum body parietal
#> 4  midline   cc bodypf   cc.bodypf.bbr.prep corpus callosum body prefrontal
#> 5  midline   cc bodypm   cc.bodypm.bbr.prep   corpus callosum body premotor
#> 6  midline    cc bodyt    cc.bodyt.bbr.prep   corpus callosum body temporal
#> 7  midline     cc genu     cc.genu.bbr.prep            corpus callosum genu
#> 8  midline  cc rostrum  cc.rostrum.bbr.prep         corpus callosum rostrum
#> 9  midline cc splenium cc.splenium.bbr.prep        corpus callosum splenium
#> 10    left          af       lh.af.bbr.prep              arcuate fasciculus
#>              group
#> 1       commissure
#> 2  corpus callosum
#> 3  corpus callosum
#> 4  corpus callosum
#> 5  corpus callosum
#> 6  corpus callosum
#> 7  corpus callosum
#> 8  corpus callosum
#> 9  corpus callosum
#> 10     association
#> ... with 32 more rows
plot(tracula())

atlas_regions(tracula())
#>  [1] "acomm"       "af"          "ar"          "atr"         "cbd"        
#>  [6] "cbv"         "cc bodyc"    "cc bodyp"    "cc bodypf"   "cc bodypm"  
#> [11] "cc bodyt"    "cc genu"     "cc rostrum"  "cc splenium" "cst"        
#> [16] "emc"         "fat"         "fx"          "ilf"         "mcp"        
#> [21] "mlf"         "or"          "slf1"        "slf2"        "slf3"       
#> [26] "uf"         
```
