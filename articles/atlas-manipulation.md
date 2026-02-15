# Customising brain atlases

``` r
library(ggseg.formats)
```

Say you are preparing a figure that focuses on the subcortical
structures visible in a single sagittal slice. You want to drop the
views you don’t need, remove small polygon fragments that clutter the
image, turn some regions into non-legend context, and add a metadata
column so you can facet by structure type. Every one of those steps is a
single function call, and they all pipe together.

## The manipulation toolkit

ggseg.formats provides three groups of manipulation functions. **Region
functions** (`atlas_region_*`) control which regions are active in the
atlas. **View functions** (`atlas_view_*`) control the 2D sf
geometry—which views are present and how they are arranged. **Core
functions** (`atlas_core_*`) enrich the region metadata. All of them
accept a `ggseg_atlas` as the first argument, return a new
`ggseg_atlas`, and play nicely with the pipe.

## Keeping and removing regions

[`atlas_region_remove()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_manipulation.md)
strips a region entirely—from core, palette, sf geometry, and 3D data.
The `pattern` argument is passed to
[`grepl()`](https://rdrr.io/r/base/grep.html) with `ignore.case = TRUE`,
so partial matches work:

``` r
no_cc <- atlas_region_remove(dk(), "corpus callosum")
"corpus callosum" %in% atlas_regions(no_cc)
#> [1] FALSE
```

[`atlas_region_keep()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_manipulation.md)
is the inverse: it keeps only the regions that match and turns
everything else into context geometry (sf is preserved for surface
continuity, but non-matching regions leave core and palette):

``` r
frontal <- atlas_region_keep(dk(), "frontal")
atlas_regions(frontal)
#> [1] "caudal middle frontal"  "frontal pole"           "lateral orbitofrontal" 
#> [4] "medial orbitofrontal"   "rostral middle frontal" "superior frontal"
```

Both functions accept a `match_on` argument to choose whether the
pattern matches against `"region"` (the default, human-readable name) or
`"label"` (the unique identifier):

``` r
lh_only <- atlas_region_keep(dk(), "^lh_", match_on = "label")
head(atlas_labels(lh_only))
#> [1] "lh_bankssts"                "lh_caudalanteriorcingulate"
#> [3] "lh_caudalmiddlefrontal"     "lh_corpuscallosum"         
#> [5] "lh_cuneus"                  "lh_entorhinal"
```

## Context regions

Sometimes you want a region’s polygon to stay visible (rendered in grey)
but not appear in the legend or carry data. This is what
[`atlas_region_contextual()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_manipulation.md)
does. It removes the region from core, palette, and 3D data but leaves
the sf geometry in place:

``` r
ctx <- atlas_region_contextual(aseg(), "ventricle")
"lateral ventricle" %in% atlas_regions(ctx)
#> [1] FALSE
```

Compare that to
[`atlas_region_remove()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_manipulation.md),
which would delete the ventricle polygons entirely, leaving gaps in the
2D slices.

## Renaming regions

[`atlas_region_rename()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_manipulation.md)
changes the `region` column without touching `label` (so geometry links
stay intact). Pass a fixed string:

``` r
renamed <- atlas_region_rename(
  dk(),
  "banks of superior temporal sulcus",
  "STS banks"
)
"STS banks" %in% atlas_regions(renamed)
#> [1] TRUE
```

Or pass a function for programmatic renaming:

``` r
upper <- atlas_region_rename(dk(), ".*", toupper)
head(atlas_regions(upper))
#> [1] "BANKS OF SUPERIOR TEMPORAL SULCUS" "CAUDAL ANTERIOR CINGULATE"        
#> [3] "CAUDAL MIDDLE FRONTAL"             "CORPUS CALLOSUM"                  
#> [5] "CUNEUS"                            "ENTORHINAL"
```

## Managing views

[`atlas_views()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_views.md)
tells you what 2D views an atlas has:

``` r
atlas_views(aseg())
#> [1] "axial_3"   "axial_4"   "axial_5"   "axial_6"   "coronal_1" "coronal_2"
#> [7] "sagittal"
```

[`atlas_view_keep()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_manipulation.md)
and
[`atlas_view_remove()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_manipulation.md)
filter views by pattern. If you only want the sagittal slice:

``` r
sag <- atlas_view_keep(aseg(), "sagittal")
atlas_views(sag)
#> [1] "sagittal"
```

Or remove several views at once by passing a vector:

``` r
fewer <- atlas_view_remove(aseg(), c("axial_3", "coronal_2"))
atlas_views(fewer)
#> [1] "axial_4"   "axial_5"   "axial_6"   "coronal_1" "sagittal"
```

## Cleaning up geometry

After filtering regions you may have small polygon fragments left
over—tiny slivers where a region just barely crossed a slice plane.
[`atlas_view_remove_small()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_manipulation.md)
removes region polygons below a minimum area threshold. Context polygons
(those not in core) are never removed:

``` r
cleaned <- atlas_view_remove_small(aseg(), min_area = 50)
#> ℹ Removed 20 geometries below area 50
```

You can scope the removal to specific views:

``` r
cleaned_sag <- atlas_view_remove_small(
  aseg(),
  min_area = 50,
  views = "sagittal"
)
#> ℹ Removed 2 geometries below area 50
```

[`atlas_view_remove_region()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_manipulation.md)
removes a specific region’s sf geometry without touching core, palette,
or 3D data. This is useful when a region’s 2D projection is misleading
but you still want it in 3D:

``` r
no_stem_sf <- atlas_view_remove_region(
  aseg(),
  "brain stem",
  match_on = "region"
)
```

## Reordering and gathering

When you remove views, the remaining geometry keeps its original
coordinates, which can leave awkward gaps.
[`atlas_view_gather()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_manipulation.md)
repositions views side-by-side with a configurable gap:

``` r
trimmed <- aseg() |>
  atlas_view_keep(c("sagittal", "coronal_3", "axial_3")) |>
  atlas_view_gather()
atlas_views(trimmed)
#> [1] "axial_3"  "sagittal"
```

[`atlas_view_reorder()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_manipulation.md)
lets you choose the left-to-right order and repositions at the same
time. Views not mentioned in `order` are appended at the end:

``` r
reordered <- aseg() |>
  atlas_view_keep(c("sagittal", "coronal_3", "axial_3")) |>
  atlas_view_reorder(c("axial_3", "sagittal", "coronal_3"))
atlas_views(reordered)
#> [1] "axial_3"  "sagittal"
```

## Adding metadata

[`atlas_core_add()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_manipulation.md)
left-joins a data frame onto the core table. This is useful for
attaching grouping variables, statistical results, or any other
per-region information. Here we add a custom network column to a handful
of regions:

``` r
network_info <- data.frame(
  region = c(
    "superior frontal",
    "precuneus",
    "inferior parietal",
    "posterior cingulate"
  ),
  network = "default mode"
)
enriched <- atlas_core_add(dk(), network_info)
enriched$core[!is.na(enriched$core$network), c("region", "network")]
#> # A tibble: 8 × 2
#>   region              network     
#>   <chr>               <chr>       
#> 1 inferior parietal   default mode
#> 2 posterior cingulate default mode
#> 3 precuneus           default mode
#> 4 superior frontal    default mode
#> 5 inferior parietal   default mode
#> 6 posterior cingulate default mode
#> 7 precuneus           default mode
#> 8 superior frontal    default mode
```

The `by` argument defaults to `"region"` but you can join on any shared
column.

## A full pipeline

Here is a realistic pipeline that prepares the `aseg` atlas for a
compact two-view figure of deep grey matter structures:

``` r
publication_aseg <- aseg() |>
  atlas_view_keep(c("sagittal", "coronal_3")) |>
  atlas_region_contextual("ventricle|choroid|white|cc") |>
  atlas_view_remove_small(min_area = 30) |>
  atlas_view_gather(gap = 0.1)
#> ℹ Removed 2 geometries below area 30

publication_aseg
#> 
#> ── aseg ggseg atlas ────────────────────────────────────────────────────────────
#> Type: subcortical
#> Regions: 12
#> Hemispheres: left, NA, right
#> Views: sagittal
#> Palette: ✔
#> Rendering: ✔ ggseg
#> ✔ ggseg3d (meshes)
#> ────────────────────────────────────────────────────────────────────────────────
#> # A tibble: 38 × 4
#>    hemi  region          label                   structure    
#>    <chr> <chr>           <chr>                   <chr>        
#>  1 left  Cerebellum      Left-Cerebellum-Cortex  cerebellum   
#>  2 left  Cerebellum      Left-Cerebellum-Cortex  cerebellum   
#>  3 left  Thalamus        Left-Thalamus           basal ganglia
#>  4 left  Thalamus        Left-Thalamus           basal ganglia
#>  5 left  Thalamus Proper Left-Thalamus           basal ganglia
#>  6 left  Thalamus Proper Left-Thalamus           basal ganglia
#>  7 left  Caudate         Left-Caudate            basal ganglia
#>  8 left  Caudate         Left-Caudate            basal ganglia
#>  9 left  Putamen         Left-Putamen            basal ganglia
#> 10 left  Putamen         Left-Putamen            basal ganglia
#> 11 left  Pallidum        Left-Pallidum           basal ganglia
#> 12 left  Pallidum        Left-Pallidum           basal ganglia
#> 13 NA    Brain Stem      Brain-Stem              brainstem    
#> 14 left  Hippocampus     Left-Hippocampus        limbic       
#> 15 left  Hippocampus     Left-Hippocampus        limbic       
#> 16 left  Amygdala        Left-Amygdala           limbic       
#> 17 left  Amygdala        Left-Amygdala           limbic       
#> 18 left  ventraldc       Left-VentralDC          NA           
#> 19 left  vessel          Left-vessel             NA           
#> 20 right Cerebellum      Right-Cerebellum-Cortex cerebellum   
#> 21 right Cerebellum      Right-Cerebellum-Cortex cerebellum   
#> 22 right Thalamus        Right-Thalamus          basal ganglia
#> 23 right Thalamus        Right-Thalamus          basal ganglia
#> 24 right Thalamus Proper Right-Thalamus          basal ganglia
#> 25 right Thalamus Proper Right-Thalamus          basal ganglia
#> 26 right Caudate         Right-Caudate           basal ganglia
#> 27 right Caudate         Right-Caudate           basal ganglia
#> 28 right Putamen         Right-Putamen           basal ganglia
#> 29 right Putamen         Right-Putamen           basal ganglia
#> 30 right Pallidum        Right-Pallidum          basal ganglia
#> 31 right Pallidum        Right-Pallidum          basal ganglia
#> 32 right Hippocampus     Right-Hippocampus       limbic       
#> 33 right Hippocampus     Right-Hippocampus       limbic       
#> 34 right Amygdala        Right-Amygdala          limbic       
#> 35 right Amygdala        Right-Amygdala          limbic       
#> 36 right ventraldc       Right-VentralDC         NA           
#> 37 right vessel          Right-vessel            NA           
#> 38 NA    Optic Chiasm    Optic-Chiasm            other
```

Each function returns a valid `ggseg_atlas`, so you can inspect
intermediate results, branch the pipeline, or hand the final object
straight to ggseg for plotting.
