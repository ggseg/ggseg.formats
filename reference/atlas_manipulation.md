# Manipulate brain atlas regions and views

Functions for modifying brain atlas objects. These cover three areas:

## Usage

``` r
atlas_region_remove(atlas, pattern, match_on = c("region", "label"))

atlas_region_contextual(atlas, pattern, match_on = c("region", "label"))

atlas_region_rename(atlas, pattern, replacement)

atlas_region_keep(atlas, pattern, match_on = c("region", "label"))

atlas_core_add(atlas, data, by = "region")

atlas_view_remove(atlas, views)

atlas_view_keep(atlas, views)

atlas_view_remove_region(
  atlas,
  pattern,
  match_on = c("label", "region"),
  views = NULL
)

atlas_view_remove_small(atlas, min_area, views = NULL)

atlas_view_gather(atlas, gap = 0.15)

atlas_view_reorder(atlas, order, gap = 0.15)
```

## Arguments

- atlas:

  A `ggseg_atlas` object

- pattern:

  Character pattern to match. Uses `grepl(..., ignore.case = TRUE)`.

- match_on:

  Column to match against: `"region"` or `"label"`.

- replacement:

  For `atlas_region_rename()`: replacement string or function.

- data:

  For `atlas_core_add()`: data.frame with metadata to join.

- by:

  For `atlas_core_add()`: column(s) to join by. Default `"region"`.

- views:

  For view functions: character vector of view names or patterns.
  Multiple values collapsed with `"|"` for matching.

- min_area:

  For `atlas_view_remove_small()`: minimum polygon area to keep. Context
  geometries are never removed.

- gap:

  Proportional gap between views (default 0.15 = 15% of max width).

- order:

  For `atlas_view_reorder()`: character vector of desired view order.
  Unspecified views appended at end.

## Value

Modified `ggseg_atlas` object

## Details

**Region manipulation** modifies which regions are active in the atlas:

- `atlas_region_remove()`: completely remove regions

- `atlas_region_contextual()`: keep geometry but remove from
  core/palette

- `atlas_region_rename()`: rename regions in core

- `atlas_region_keep()`: keep only matching regions

**View manipulation** modifies the 2D sf geometry data:

- `atlas_view_remove()`: remove entire views

- `atlas_view_keep()`: keep only matching views

- `atlas_view_remove_region()`: remove specific region geometry from sf

- `atlas_view_remove_small()`: remove small polygon fragments

- `atlas_view_gather()`: reposition views to close gaps

- `atlas_view_reorder()`: change view order

**Core manipulation** modifies atlas metadata:

- `atlas_core_add()`: join additional metadata columns

## Functions

- `atlas_region_contextual()`: Keep geometry for visual context but
  remove from core, palette, and 3D data. Context geometries render grey
  and don't appear in legends.

- `atlas_region_rename()`: Rename regions matching a pattern. Only
  affects the `region` column, not `label`. If `replacement` is a
  function, it receives matched names and returns new names.

- `atlas_region_keep()`: Keep only matching regions. Non-matching
  regions are removed from core, palette, and 3D data but sf geometry is
  preserved for surface continuity.

- `atlas_core_add()`: Join additional metadata columns to atlas core.

- `atlas_view_remove()`: Remove views matching pattern from sf data.

- `atlas_view_keep()`: Keep only views matching pattern.

- `atlas_view_remove_region()`: Remove specific region geometry from sf
  data only. Core, palette, and 3D data are unchanged.

- `atlas_view_remove_small()`: Remove region geometries below a minimum
  area threshold. Context geometries (labels not in core) are never
  removed. Optionally scope to specific views.

- `atlas_view_gather()`: Reposition remaining views to close gaps after
  view removal.

- `atlas_view_reorder()`: Reorder views and reposition. Views not in
  `order` are appended at end.

## Examples

``` r
if (FALSE) { # \dontrun{
atlas <- atlas |>
  atlas_region_remove("White-Matter") |>
  atlas_region_contextual("cortex") |>
  atlas_view_keep(c("axial_3", "coronal_2", "sagittal")) |>
  atlas_view_remove_small(min_area = 50) |>
  atlas_view_gather()
} # }
```
