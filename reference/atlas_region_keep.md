# Keep only specified regions

Inverse of [`atlas_region_remove()`](atlas_region_remove.md) - keeps
only regions matching the pattern. Non-matching regions are removed from
core, palette, and 3D rendering data (vertices/meshes). The 2D geometry
(sf) is preserved to maintain brain surface continuity.

## Usage

``` r
atlas_region_keep(atlas, pattern, match_on = c("region", "label"))
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

Modified `brain_atlas` with only matching regions kept

## Examples

``` r
if (FALSE) { # \dontrun{
# Keep only basal ganglia structures
atlas <- atlas |> atlas_region_keep("caudate|putamen|pallidum")

# Keep only left hemisphere
atlas <- atlas |> atlas_region_keep("^lh_", match_on = "label")
} # }
```
