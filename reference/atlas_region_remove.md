# Remove regions from atlas

Completely removes regions matching a pattern from the atlas. Affected
regions are removed from core, palette, sf geometry, and 3D rendering
data (vertices/meshes). Use
[`atlas_region_contextual()`](atlas_region_contextual.md) instead if you
want to keep the geometry for visual context.

## Usage

``` r
atlas_region_remove(atlas, pattern, match_on = c("region", "label"))
```

## Arguments

- atlas:

  A `brain_atlas` object

- pattern:

  Character pattern to match against region names or labels. Uses
  `grepl(..., ignore.case = TRUE)`.

- match_on:

  Column to match against: "region" (default) or "label"

## Value

Modified `brain_atlas` with matching regions completely removed

## Examples

``` r
if (FALSE) { # \dontrun{
# Remove white matter from subcortical atlas
atlas <- atlas |> atlas_region_remove("White-Matter")

# Remove by label pattern
atlas <- atlas |> atlas_region_remove("^lh_", match_on = "label")
} # }
```
