# The ggseg_atlas object

``` r
library(ggseg.formats)
```

Everything in the ggseg ecosystem starts from a single object: the
`ggseg_atlas`. Whether you are making a 2D cortical flatmap with ggseg
or spinning a 3D mesh in ggseg3d, the atlas is the container that holds
the geometry, the region metadata, and the colour palette together. This
vignette walks through the structure so you know exactly what you are
working with.

## What is a ggseg_atlas?

A `ggseg_atlas` is an S3 object that bundles five pieces of information
into one handle. Let’s print the bundled Desikan-Killiany atlas to see
what that looks like:

``` r
dk
#> 
#> ── dk ggseg atlas ──────────────────────────────────────────────────────────────
#> Type: cortical
#> Regions: 35
#> Hemispheres: left, right
#> Views: inferior, lateral, medial, superior
#> Palette: ✔
#> Rendering: ✔ ggseg
#> ✔ ggseg3d (vertices)
#> ────────────────────────────────────────────────────────────────────────────────
#> # A tibble: 70 × 4
#>    hemi  region                            label                       lobe     
#>    <chr> <chr>                             <chr>                       <chr>    
#>  1 left  banks of superior temporal sulcus lh_bankssts                 temporal 
#>  2 left  caudal anterior cingulate         lh_caudalanteriorcingulate  cingulate
#>  3 left  caudal middle frontal             lh_caudalmiddlefrontal      frontal  
#>  4 left  corpus callosum                   lh_corpuscallosum           white ma…
#>  5 left  cuneus                            lh_cuneus                   occipital
#>  6 left  entorhinal                        lh_entorhinal               temporal 
#>  7 left  fusiform                          lh_fusiform                 temporal 
#>  8 left  inferior parietal                 lh_inferiorparietal         parietal 
#>  9 left  inferior temporal                 lh_inferiortemporal         temporal 
#> 10 left  isthmus cingulate                 lh_isthmuscingulate         cingulate
#> 11 left  lateral occipital                 lh_lateraloccipital         occipital
#> 12 left  lateral orbitofrontal             lh_lateralorbitofrontal     frontal  
#> 13 left  lingual                           lh_lingual                  occipital
#> 14 left  medial orbitofrontal              lh_medialorbitofrontal      frontal  
#> 15 left  middle temporal                   lh_middletemporal           temporal 
#> 16 left  parahippocampal                   lh_parahippocampal          temporal 
#> 17 left  paracentral                       lh_paracentral              frontal  
#> 18 left  pars opercularis                  lh_parsopercularis          frontal  
#> 19 left  pars orbitalis                    lh_parsorbitalis            frontal  
#> 20 left  pars triangularis                 lh_parstriangularis         frontal  
#> 21 left  pericalcarine                     lh_pericalcarine            occipital
#> 22 left  postcentral                       lh_postcentral              parietal 
#> 23 left  posterior cingulate               lh_posteriorcingulate       cingulate
#> 24 left  precentral                        lh_precentral               frontal  
#> 25 left  precuneus                         lh_precuneus                parietal 
#> 26 left  rostral anterior cingulate        lh_rostralanteriorcingulate cingulate
#> 27 left  rostral middle frontal            lh_rostralmiddlefrontal     frontal  
#> 28 left  superior frontal                  lh_superiorfrontal          frontal  
#> 29 left  superior parietal                 lh_superiorparietal         parietal 
#> 30 left  superior temporal                 lh_superiortemporal         temporal 
#> 31 left  supramarginal                     lh_supramarginal            parietal 
#> 32 left  frontal pole                      lh_frontalpole              frontal  
#> 33 left  temporal pole                     lh_temporalpole             temporal 
#> 34 left  transverse temporal               lh_transversetemporal       temporal 
#> 35 left  insula                            lh_insula                   insula   
#> 36 right banks of superior temporal sulcus rh_bankssts                 temporal 
#> 37 right caudal anterior cingulate         rh_caudalanteriorcingulate  cingulate
#> 38 right caudal middle frontal             rh_caudalmiddlefrontal      frontal  
#> 39 right corpus callosum                   rh_corpuscallosum           white ma…
#> 40 right cuneus                            rh_cuneus                   occipital
#> 41 right entorhinal                        rh_entorhinal               temporal 
#> 42 right fusiform                          rh_fusiform                 temporal 
#> 43 right inferior parietal                 rh_inferiorparietal         parietal 
#> 44 right inferior temporal                 rh_inferiortemporal         temporal 
#> 45 right isthmus cingulate                 rh_isthmuscingulate         cingulate
#> 46 right lateral occipital                 rh_lateraloccipital         occipital
#> 47 right lateral orbitofrontal             rh_lateralorbitofrontal     frontal  
#> 48 right lingual                           rh_lingual                  occipital
#> 49 right medial orbitofrontal              rh_medialorbitofrontal      frontal  
#> 50 right middle temporal                   rh_middletemporal           temporal 
#> 51 right parahippocampal                   rh_parahippocampal          temporal 
#> 52 right paracentral                       rh_paracentral              frontal  
#> 53 right pars opercularis                  rh_parsopercularis          frontal  
#> 54 right pars orbitalis                    rh_parsorbitalis            frontal  
#> 55 right pars triangularis                 rh_parstriangularis         frontal  
#> 56 right pericalcarine                     rh_pericalcarine            occipital
#> 57 right postcentral                       rh_postcentral              parietal 
#> 58 right posterior cingulate               rh_posteriorcingulate       cingulate
#> 59 right precentral                        rh_precentral               frontal  
#> 60 right precuneus                         rh_precuneus                parietal 
#> 61 right rostral anterior cingulate        rh_rostralanteriorcingulate cingulate
#> 62 right rostral middle frontal            rh_rostralmiddlefrontal     frontal  
#> 63 right superior frontal                  rh_superiorfrontal          frontal  
#> 64 right superior parietal                 rh_superiorparietal         parietal 
#> 65 right superior temporal                 rh_superiortemporal         temporal 
#> 66 right supramarginal                     rh_supramarginal            parietal 
#> 67 right frontal pole                      rh_frontalpole              frontal  
#> 68 right temporal pole                     rh_temporalpole             temporal 
#> 69 right transverse temporal               rh_transversetemporal       temporal 
#> 70 right insula                            rh_insula                   insula
```

The print method gives you a quick overview: the atlas name, type, how
many regions it has, which hemispheres are present, what views the 2D
geometry provides, and whether palette and rendering data are available.
Below the summary you see the core table, the single source of truth for
region identity.

## Anatomy of an atlas

The five slots are accessed with `$`:

``` r
dk$atlas
#> [1] "dk"
dk$type
#> [1] "cortical"
```

`$atlas` is a short name (used to look up atlases by string) and `$type`
is one of `"cortical"`, `"subcortical"`, or `"tract"`.

The `$palette` is a named character vector mapping labels to hex
colours:

``` r
head(dk$palette)
#>                lh_bankssts lh_caudalanteriorcingulate 
#>                  "#196428"                  "#7D64A0" 
#>     lh_caudalmiddlefrontal          lh_corpuscallosum 
#>                  "#641900"                  "#784632" 
#>                  lh_cuneus              lh_entorhinal 
#>                  "#DC1464"                  "#DC140A"
```

`$core` is a data frame with one row per region. It always has `region`
and `label` columns, and will often include `hemi` and additional
metadata like `lobe` or `structure`:

``` r
head(dk$core)
#> # A tibble: 6 × 4
#>   hemi  region                            label                      lobe       
#>   <chr> <chr>                             <chr>                      <chr>      
#> 1 left  banks of superior temporal sulcus lh_bankssts                temporal   
#> 2 left  caudal anterior cingulate         lh_caudalanteriorcingulate cingulate  
#> 3 left  caudal middle frontal             lh_caudalmiddlefrontal     frontal    
#> 4 left  corpus callosum                   lh_corpuscallosum          white matt…
#> 5 left  cuneus                            lh_cuneus                  occipital  
#> 6 left  entorhinal                        lh_entorhinal              temporal
```

Finally, `$data` is a `ggseg_atlas_data` object that holds the actual
geometry. Its contents depend on the atlas type.

``` r
class(dk$data)
#> [1] "ggseg_data_cortical" "ggseg_atlas_data"
```

## Three atlas types

ggseg.formats ships three atlases that illustrate the three types.

**Cortical** atlases like `dk` parcellate the cortical surface. Their
data object is a `ggseg_data_cortical` containing sf polygons for 2D
rendering and vertex indices for 3D:

``` r
dk$type
#> [1] "cortical"
names(dk$data)
#> [1] "sf"       "vertices"
```

**Subcortical** atlases like `aseg` represent deep brain structures.
Their data is a `ggseg_data_subcortical` with sf polygons and individual
3D meshes:

``` r
aseg$type
#> [1] "subcortical"
names(aseg$data)
#> [1] "sf"     "meshes"
```

**Tract** atlases like `tracula` represent white matter bundles. Their
data is a `ggseg_data_tract` with sf polygons and centerlines that
generate tube meshes for 3D:

``` r
tracula$type
#> [1] "tract"
names(tracula$data)
#> [1] "sf"          "centerlines"
```

In every case the sf component drives 2D plotting and the type-specific
component (vertices, meshes, or centerlines) drives 3D.

## Core: the region table

The `$core` data frame is the single source of truth for what regions an
atlas contains. Every manipulation function updates core first and then
propagates changes to geometry and palette.

The required columns are `region` (a human-readable name) and `label` (a
unique identifier that links core to geometry). Most atlases also carry
`hemi`:

``` r
str(dk$core)
#> tibble [70 × 4] (S3: tbl_df/tbl/data.frame)
#>  $ hemi  : chr [1:70] "left" "left" "left" "left" ...
#>  $ region: chr [1:70] "banks of superior temporal sulcus" "caudal anterior cingulate" "caudal middle frontal" "corpus callosum" ...
#>  $ label : chr [1:70] "lh_bankssts" "lh_caudalanteriorcingulate" "lh_caudalmiddlefrontal" "lh_corpuscallosum" ...
#>  $ lobe  : chr [1:70] "temporal" "cingulate" "frontal" "white matter" ...
```

Some atlases include additional metadata columns. The `dk` atlas, for
instance, has `lobe`:

``` r
unique(dk$core$lobe)
#> [1] "temporal"     "cingulate"    "frontal"      "white matter" "occipital"   
#> [6] "parietal"     "insula"
```

You can add your own metadata with
[`atlas_core_add()`](https://ggseg.github.io/ggseg.formats/reference/atlas_manipulation.md)
(covered in the manipulation vignette).

## Querying an atlas

A set of accessor functions lets you pull information out without
reaching into slots directly.

[`atlas_regions()`](https://ggseg.github.io/ggseg.formats/reference/atlas_regions.md)
returns the sorted unique region names:

``` r
atlas_regions(dk)
#>  [1] "banks of superior temporal sulcus" "caudal anterior cingulate"        
#>  [3] "caudal middle frontal"             "corpus callosum"                  
#>  [5] "cuneus"                            "entorhinal"                       
#>  [7] "frontal pole"                      "fusiform"                         
#>  [9] "inferior parietal"                 "inferior temporal"                
#> [11] "insula"                            "isthmus cingulate"                
#> [13] "lateral occipital"                 "lateral orbitofrontal"            
#> [15] "lingual"                           "medial orbitofrontal"             
#> [17] "middle temporal"                   "paracentral"                      
#> [19] "parahippocampal"                   "pars opercularis"                 
#> [21] "pars orbitalis"                    "pars triangularis"                
#> [23] "pericalcarine"                     "postcentral"                      
#> [25] "posterior cingulate"               "precentral"                       
#> [27] "precuneus"                         "rostral anterior cingulate"       
#> [29] "rostral middle frontal"            "superior frontal"                 
#> [31] "superior parietal"                 "superior temporal"                
#> [33] "supramarginal"                     "temporal pole"                    
#> [35] "transverse temporal"
```

[`atlas_labels()`](https://ggseg.github.io/ggseg.formats/reference/atlas_labels.md)
returns the unique labels (the identifiers used to join geometry):

``` r
head(atlas_labels(dk))
#> [1] "lh_bankssts"                "lh_caudalanteriorcingulate"
#> [3] "lh_caudalmiddlefrontal"     "lh_corpuscallosum"         
#> [5] "lh_cuneus"                  "lh_entorhinal"
```

[`atlas_views()`](https://ggseg.github.io/ggseg.formats/reference/atlas_views.md)
returns the available 2D views:

``` r
atlas_views(dk)
#> [1] "inferior" "lateral"  "medial"   "superior"
atlas_views(aseg)
#> [1] "axial_3"   "axial_5"   "coronal_2" "coronal_3" "coronal_4" "sagittal"
atlas_views(tracula)
#> [1] "axial_2"          "axial_4"          "coronal_3"        "coronal_4"       
#> [5] "sagittal_left"    "sagittal_midline" "sagittal_right"
```

[`atlas_type()`](https://ggseg.github.io/ggseg.formats/reference/atlas_type.md)
returns the type string:

``` r
atlas_type(dk)
#> [1] "cortical"
atlas_type(aseg)
#> [1] "subcortical"
atlas_type(tracula)
#> [1] "tract"
```

[`atlas_palette()`](https://ggseg.github.io/ggseg.formats/reference/atlas_palette.md)
retrieves the colour palette. You can pass the atlas object directly or
its name as a string:

``` r
head(atlas_palette(dk))
#>                lh_bankssts lh_caudalanteriorcingulate 
#>                  "#196428"                  "#7D64A0" 
#>     lh_caudalmiddlefrontal          lh_corpuscallosum 
#>                  "#641900"                  "#784632" 
#>                  lh_cuneus              lh_entorhinal 
#>                  "#DC1464"                  "#DC140A"
```

## Extracting render-ready data

When you need the actual data frames that ggseg and ggseg3d consume, use
the `atlas_*()` extractors. These join core metadata and palette colours
onto the raw geometry so you get a single, ready-to-use table.

[`atlas_sf()`](https://ggseg.github.io/ggseg.formats/reference/atlas_sf.md)
returns an sf data frame for 2D rendering:

``` r
sf_data <- atlas_sf(dk)
sf_data
#> ── <ggseg_sf> data: 191 × 7 ────────────────────────────────────────────────────
#> Views: inferior, lateral, superior, medial
#> Simple feature collection with 191 features and 6 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 84.2049 ymin: 0 xmax: 5359.689 ymax: 429.9372
#> CRS:           NA
#> First 10 features:
#>                         label     view hemi                            region
#> 1                 lh_bankssts inferior left banks of superior temporal sulcus
#> 2                 lh_bankssts  lateral left banks of superior temporal sulcus
#> 3                 lh_bankssts superior left banks of superior temporal sulcus
#> 4  lh_caudalanteriorcingulate   medial left         caudal anterior cingulate
#> 5      lh_caudalmiddlefrontal inferior left             caudal middle frontal
#> 6      lh_caudalmiddlefrontal  lateral left             caudal middle frontal
#> 7      lh_caudalmiddlefrontal superior left             caudal middle frontal
#> 8           lh_corpuscallosum   medial left                   corpus callosum
#> 9           lh_corpuscallosum inferior left                   corpus callosum
#> 10                  lh_cuneus   medial left                            cuneus
#>            lobe                       geometry  colour
#> 1      temporal MULTIPOLYGON (((534.4782 21... #196428
#> 2      temporal MULTIPOLYGON (((1121.478 12... #196428
#> 3      temporal MULTIPOLYGON (((2448.464 20... #196428
#> 4     cingulate MULTIPOLYGON (((1921.971 20... #7D64A0
#> 5       frontal MULTIPOLYGON (((272.7879 22... #641900
#> 6       frontal MULTIPOLYGON (((911.758 248... #641900
#> 7       frontal MULTIPOLYGON (((2266.635 10... #641900
#> 8  white matter MULTIPOLYGON (((1873.925 12... #784632
#> 9  white matter MULTIPOLYGON (((486.2937 40... #784632
#> 10    occipital MULTIPOLYGON (((1422.294 16... #DC1464
```

[`atlas_vertices()`](https://ggseg.github.io/ggseg.formats/reference/atlas_vertices.md)
returns the vertex data for cortical 3D rendering:

``` r
vert_data <- atlas_vertices(dk)
vert_data
#> ── <ggseg_vertices> data: 70 × 6 ───────────────────────────────────────────────
#> Vertices per region: 18 –759
#> # A tibble: 70 × 6
#>    label                      vertices    hemi  region              lobe  colour
#>    <chr>                      <list>      <chr> <chr>               <chr> <chr> 
#>  1 lh_bankssts                <int [126]> left  banks of superior … temp… #1964…
#>  2 lh_caudalanteriorcingulate <int [67]>  left  caudal anterior ci… cing… #7D64…
#>  3 lh_caudalmiddlefrontal     <int [232]> left  caudal middle fron… fron… #6419…
#>  4 lh_corpuscallosum          <int [198]> left  corpus callosum     whit… #7846…
#>  5 lh_cuneus                  <int [102]> left  cuneus              occi… #DC14…
#>  6 lh_entorhinal              <int [48]>  left  entorhinal          temp… #DC14…
#>  7 lh_fusiform                <int [308]> left  fusiform            temp… #B4DC…
#>  8 lh_inferiorparietal        <int [484]> left  inferior parietal   pari… #DC3C…
#>  9 lh_inferiortemporal        <int [271]> left  inferior temporal   temp… #B428…
#> 10 lh_isthmuscingulate        <int [123]> left  isthmus cingulate   cing… #8C14…
#> # ℹ 60 more rows
```

[`atlas_meshes()`](https://ggseg.github.io/ggseg.formats/reference/atlas_meshes.md)
returns mesh data for subcortical or tract 3D rendering:

``` r
mesh_data <- atlas_meshes(aseg)
mesh_data
#> ── <ggseg_meshes> data: 27 × 6 ─────────────────────────────────────────────────
#> # A tibble: 27 × 3
#>    label               vertices faces
#>    <chr>                  <int> <int>
#>  1 Left-Thalamus           1864  3724
#>  2 Left-Caudate            1512  3028
#>  3 Left-Putamen            1998  3992
#>  4 Left-Pallidum            723  1442
#>  5 Brain-Stem              4608  9212
#>  6 Left-Hippocampus        1892  3780
#>  7 Left-Amygdala            710  1416
#>  8 Left-Accumbens-area      432   860
#>  9 Left-VentralDC          1683  3366
#> 10 Left-vessel               77   150
#> # ℹ 17 more rows
```

[`as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html) is a
convenience method that produces a merged sf data frame similar to
[`atlas_sf()`](https://ggseg.github.io/ggseg.formats/reference/atlas_sf.md)
but with atlas-level columns (`atlas`, `type`) attached:

``` r
df <- as.data.frame(dk)
names(df)
#> [1] "label"    "view"     "hemi"     "region"   "lobe"     "geometry" "atlas"   
#> [8] "type"     "colour"
```

## Checking and converting

[`is_ggseg_atlas()`](https://ggseg.github.io/ggseg.formats/reference/is_ggseg_atlas.md)
tests whether an object has the right class:

``` r
is_ggseg_atlas(dk)
#> [1] TRUE
is_ggseg_atlas(mtcars)
#> [1] FALSE
```

[`as_ggseg_atlas()`](https://ggseg.github.io/ggseg.formats/reference/as_ggseg_atlas.md)
coerces lists with the right structure into a proper `ggseg_atlas`:

``` r
atlas_list <- as.list(dk)
recovered <- as_ggseg_atlas(atlas_list)
is_ggseg_atlas(recovered)
#> [1] TRUE
```

If you have an atlas object from an older version of ggseg that stored
sf data directly in `$data` instead of using the new `ggseg_atlas_data`
wrapper,
[`convert_legacy_brain_atlas()`](https://ggseg.github.io/ggseg.formats/reference/convert_legacy_brain_atlas.md)
will migrate it to the unified format.
