# The ggseg_atlas object

``` r

library(ggseg.formats)
# Several examples below print or plot via the sf path. Since the
# sf-optional milestone, sf is a Suggests dependency, so load it here.
library(sf)
#> Linking to GEOS 3.12.1, GDAL 3.8.4, PROJ 9.4.0; sf_use_s2() is TRUE
```

Everything in the ggsegverse ecosystem starts from a single object: the
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

dk()
#> 
#> ── dk ggseg atlas ──────────────────────────────────────────────────────────────
#> Type: cortical
#> Regions: 35
#> Hemispheres: left, right
#> Views: inferior, lateral, superior, medial
#> Palette: ✔
#> Rendering: ✔ ggseg
#> ✔ ggseg3d (vertices)
#> ────────────────────────────────────────────────────────────────────────────────
#>    hemi                            region                      label
#> 1  left banks of superior temporal sulcus                lh_bankssts
#> 2  left         caudal anterior cingulate lh_caudalanteriorcingulate
#> 3  left             caudal middle frontal     lh_caudalmiddlefrontal
#> 4  left                   corpus callosum          lh_corpuscallosum
#> 5  left                            cuneus                  lh_cuneus
#> 6  left                        entorhinal              lh_entorhinal
#> 7  left                          fusiform                lh_fusiform
#> 8  left                 inferior parietal        lh_inferiorparietal
#> 9  left                 inferior temporal        lh_inferiortemporal
#> 10 left                 isthmus cingulate        lh_isthmuscingulate
#>            lobe
#> 1      temporal
#> 2     cingulate
#> 3       frontal
#> 4  white matter
#> 5     occipital
#> 6      temporal
#> 7      temporal
#> 8      parietal
#> 9      temporal
#> 10    cingulate
#> ... with 60 more rows
```

The print method gives you a quick overview: the atlas name, type, how
many regions it has, which hemispheres are present, what views the 2D
geometry provides, and whether palette and rendering data are available.
Below the summary you see the core table, the single source of truth for
region identity.

## Anatomy of an atlas

The five slots are accessed with `$`:

``` r

dk()$atlas
#> [1] "dk"
dk()$type
#> [1] "cortical"
```

`$atlas` is a short name (used to look up atlases by string) and `$type`
is one of `"cortical"`, `"subcortical"`, or `"tract"`.

The `$palette` is a named character vector mapping labels to hex
colours:

``` r

head(dk()$palette)
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

head(dk()$core)
#>   hemi                            region                      label
#> 1 left banks of superior temporal sulcus                lh_bankssts
#> 2 left         caudal anterior cingulate lh_caudalanteriorcingulate
#> 3 left             caudal middle frontal     lh_caudalmiddlefrontal
#> 4 left                   corpus callosum          lh_corpuscallosum
#> 5 left                            cuneus                  lh_cuneus
#> 6 left                        entorhinal              lh_entorhinal
#>           lobe
#> 1     temporal
#> 2    cingulate
#> 3      frontal
#> 4 white matter
#> 5    occipital
#> 6     temporal
```

Finally, `$data` is a `ggseg_atlas_data` object that holds the actual
geometry. Its contents depend on the atlas type.

``` r

class(dk()$data)
#> [1] "ggseg_data_cortical" "ggseg_atlas_data"
```

## Three atlas types

ggseg.formats ships three atlases that illustrate the three types.

**Cortical** atlases like `dk` parcellate the cortical surface. Their
data object is a `ggseg_data_cortical` containing sf polygons for 2D
rendering and vertex indices for 3D:

``` r

dk()$type
#> [1] "cortical"
names(dk()$data)
#> [1] "vertices" "geom"
```

**Subcortical** atlases like `aseg` represent deep brain structures.
Their data is a `ggseg_data_subcortical` with sf polygons and individual
3D meshes:

``` r

aseg()$type
#> [1] "subcortical"
names(aseg()$data)
#> [1] "meshes" "geom"
```

**Tract** atlases like `tracula` represent white matter bundles. Their
data is a `ggseg_data_tract` with sf polygons and centerlines that
generate tube meshes for 3D:

``` r

tracula()$type
#> [1] "tract"
names(tracula()$data)
#> [1] "centerlines" "geom"
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

str(dk()$core)
#> Classes 'tbl_df', 'tbl' and 'data.frame':    70 obs. of  4 variables:
#>  $ hemi  : chr  "left" "left" "left" "left" ...
#>  $ region: chr  "banks of superior temporal sulcus" "caudal anterior cingulate" "caudal middle frontal" "corpus callosum" ...
#>  $ label : chr  "lh_bankssts" "lh_caudalanteriorcingulate" "lh_caudalmiddlefrontal" "lh_corpuscallosum" ...
#>  $ lobe  : chr  "temporal" "cingulate" "frontal" "white matter" ...
```

Some atlases include additional metadata columns. The `dk` atlas, for
instance, has `lobe`:

``` r

unique(dk()$core$lobe)
#> [1] "temporal"     "cingulate"    "frontal"      "white matter" "occipital"   
#> [6] "parietal"     "insula"
```

You can add your own metadata with
[`atlas_core_add()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_manipulation.md)
(covered in the manipulation vignette).

## Querying an atlas

A set of accessor functions lets you pull information out without
reaching into slots directly.

[`atlas_regions()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_regions.md)
returns the sorted unique region names:

``` r

atlas_regions(dk())
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

[`atlas_labels()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_labels.md)
returns the unique labels (the identifiers used to join geometry):

``` r

head(atlas_labels(dk()))
#> [1] "lh_bankssts"                "lh_caudalanteriorcingulate"
#> [3] "lh_caudalmiddlefrontal"     "lh_corpuscallosum"         
#> [5] "lh_cuneus"                  "lh_entorhinal"
```

[`atlas_views()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_views.md)
returns the available 2D views:

``` r

atlas_views(dk())
#> [1] "inferior" "lateral"  "superior" "medial"
atlas_views(aseg())
#> [1] "axial_3"   "axial_4"   "axial_5"   "sagittal"  "axial_6"   "coronal_1"
#> [7] "coronal_2"
atlas_views(tracula())
#> [1] "axial_2"          "axial_4"          "coronal_3"        "coronal_4"       
#> [5] "sagittal_midline" "sagittal_left"    "sagittal_right"
```

[`atlas_type()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_type.md)
returns the type string:

``` r

atlas_type(dk())
#> [1] "cortical"
atlas_type(aseg())
#> [1] "subcortical"
atlas_type(tracula())
#> [1] "tract"
```

[`atlas_palette()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_palette.md)
retrieves the colour palette from an atlas object:

``` r

head(atlas_palette(dk()))
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

[`atlas_sf()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_sf.md)
returns an sf data frame for 2D rendering:

``` r

sf_data <- atlas_sf(dk())
sf_data
#> ── <ggseg_sf> data: 191 × 7 ────────────────────────────────────────────────────
#> Views: lateral, medial, inferior, superior
#> Simple feature collection with 191 features and 6 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 84.2049 ymin: 0 xmax: 5359.689 ymax: 429.9372
#> CRS:           NA
#> First 10 features:
#>                      label     view hemi                            region
#> 186             lh_unknown  lateral <NA>                              <NA>
#> 187             lh_unknown   medial <NA>                              <NA>
#> 188             rh_unknown  lateral <NA>                              <NA>
#> 189             rh_unknown   medial <NA>                              <NA>
#> 190             lh_unknown inferior <NA>                              <NA>
#> 191             rh_unknown inferior <NA>                              <NA>
#> 1              lh_bankssts  lateral left banks of superior temporal sulcus
#> 2              lh_bankssts superior left banks of superior temporal sulcus
#> 3              lh_bankssts inferior left banks of superior temporal sulcus
#> 4   lh_caudalmiddlefrontal  lateral left             caudal middle frontal
#>         lobe                       geometry  colour
#> 186     <NA> MULTIPOLYGON (((926.5936 60...    <NA>
#> 187     <NA> MULTIPOLYGON (((1782.84 18....    <NA>
#> 188     <NA> MULTIPOLYGON (((3849.766 60...    <NA>
#> 189     <NA> MULTIPOLYGON (((4318.844 20...    <NA>
#> 190     <NA> MULTIPOLYGON (((367.1256 13...    <NA>
#> 191     <NA> MULTIPOLYGON (((3190.519 5....    <NA>
#> 1   temporal MULTIPOLYGON (((1121.478 12... #196428
#> 2   temporal MULTIPOLYGON (((2448.464 20... #196428
#> 3   temporal MULTIPOLYGON (((534.4782 21... #196428
#> 4    frontal MULTIPOLYGON (((911.758 248... #641900
```

[`atlas_vertices()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_vertices.md)
returns the vertex data for cortical 3D rendering:

``` r

vert_data <- atlas_vertices(dk())
vert_data
#> ── <ggseg_vertices> data: 70 × 6 ───────────────────────────────────────────────
#> Vertices per region: 18 –759
#>                         label    vertices hemi
#> 1                 lh_bankssts <int [126]> left
#> 2  lh_caudalanteriorcingulate  <int [67]> left
#> 3      lh_caudalmiddlefrontal <int [232]> left
#> 4           lh_corpuscallosum <int [198]> left
#> 5                   lh_cuneus <int [102]> left
#> 6               lh_entorhinal  <int [48]> left
#> 7                 lh_fusiform <int [308]> left
#> 8         lh_inferiorparietal <int [484]> left
#> 9         lh_inferiortemporal <int [271]> left
#> 10        lh_isthmuscingulate <int [123]> left
#>                               region         lobe  colour
#> 1  banks of superior temporal sulcus     temporal #196428
#> 2          caudal anterior cingulate    cingulate #7D64A0
#> 3              caudal middle frontal      frontal #641900
#> 4                    corpus callosum white matter #784632
#> 5                             cuneus    occipital #DC1464
#> 6                         entorhinal     temporal #DC140A
#> 7                           fusiform     temporal #B4DC8C
#> 8                  inferior parietal     parietal #DC3CDC
#> 9                  inferior temporal     temporal #B42878
#> 10                 isthmus cingulate    cingulate #8C148C
#> ... with 60 more rows
```

[`atlas_meshes()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_meshes.md)
returns mesh data for subcortical or tract 3D rendering:

``` r

mesh_data <- atlas_meshes(aseg())
mesh_data
#> ── <ggseg_meshes> data: 47 × 6 ─────────────────────────────────────────────────
#>                     label vertices faces
#> 1  Left-Cerebellum-Cortex    21232 42456
#> 2  Left-Cerebellum-Cortex    21232 42456
#> 3           Left-Thalamus     3726  7448
#> 4           Left-Thalamus     3726  7448
#> 5           Left-Thalamus     3726  7448
#> 6           Left-Thalamus     3726  7448
#> 7            Left-Caudate     3026  6056
#> 8            Left-Caudate     3026  6056
#> 9            Left-Putamen     3994  7984
#> 10           Left-Putamen     3994  7984
#> ... with 37 more rows
```

[`as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html) is a
convenience method that produces a merged sf data frame similar to
[`atlas_sf()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_sf.md)
but with atlas-level columns (`atlas`, `type`) attached:

``` r

df <- as.data.frame(dk())
names(df)
#> [1] "label"    "view"     "hemi"     "region"   "lobe"     "geometry" "atlas"   
#> [8] "type"     "colour"
```

## Checking and converting

[`is_ggseg_atlas()`](https://ggsegverse.github.io/ggseg.formats/reference/is_ggseg_atlas.md)
tests whether an object has the right class:

``` r

is_ggseg_atlas(dk())
#> [1] TRUE
is_ggseg_atlas(mtcars)
#> [1] FALSE
```

[`as_ggseg_atlas()`](https://ggsegverse.github.io/ggseg.formats/reference/as_ggseg_atlas.md)
coerces lists with the right structure into a proper `ggseg_atlas`:

``` r

atlas_list <- as.list(dk())
recovered <- as_ggseg_atlas(atlas_list)
is_ggseg_atlas(recovered)
#> [1] TRUE
```

If you have an atlas object from an older version of ggseg that stored
sf data directly in `$data` instead of using the new `ggseg_atlas_data`
wrapper,
[`convert_legacy_brain_atlas()`](https://ggsegverse.github.io/ggseg.formats/reference/convert_legacy_brain_atlas.md)
will migrate it to the unified format.
