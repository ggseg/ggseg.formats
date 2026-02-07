# Remove region geometry from views

Removes matching regions from the 2D sf data only. Core metadata,
palette, and 3D rendering data are unchanged. Use this for fine-grained
cleanup of specific regions in certain views, or before plotting to hide
regions without altering the atlas definition.

## Usage

``` r
atlas_view_remove_region(atlas, pattern, match_on = c("label", "region"))
```

## Arguments

- atlas:

  A `brain_atlas` object

- pattern:

  Character pattern to match against region names or labels. Uses
  `grepl(..., ignore.case = TRUE)`.

- match_on:

  Column to match against: "label" (default) or "region". When "region",
  labels are looked up from core metadata.

## Value

Modified `brain_atlas` with matching region geometries removed

## Examples

``` r
if (FALSE) { # \dontrun{
# Remove cortex outline from tract atlas views
atlas <- atlas |> atlas_view_remove_region("cortex")

# Remove specific label from 2D rendering
atlas <- atlas |> atlas_view_remove_region("lh_unknown", match_on = "label")
} # }
```
