# Mark regions as context-only

Removes matching regions from core, palette, and 3D rendering data
(vertices/meshes). The 2D geometry (sf) is preserved so these regions
display grey and provide visual context, but won't appear in legends.

## Usage

``` r
atlas_region_contextual(atlas, pattern, match_on = c("region", "label"))
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

Modified `brain_atlas` with matching regions as context-only

## Details

For cortical atlases, the shared brain mesh provides 3D context
naturally. For subcortical/tract atlases, use glass brains for 3D
context instead.

## Examples

``` r
if (FALSE) { # \dontrun{
# Keep medial wall geometry for visual context but don't label it
atlas <- atlas |> atlas_region_contextual("unknown")

# Make cortex context-only in subcortical atlas
atlas <- atlas |> atlas_region_contextual("Cortex", match_on = "label")
} # }
```
