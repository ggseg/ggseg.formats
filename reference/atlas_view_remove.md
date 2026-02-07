# Remove views from atlas

Removes 2D views matching the pattern from the atlas sf data. Use this
to curate which views are included in the final atlas after generating
many projection views.

## Usage

``` r
atlas_view_remove(atlas, views)
```

## Arguments

- atlas:

  A `brain_atlas` object

- pattern:

  Character pattern to match against view names. Uses
  `grepl(..., ignore.case = TRUE)`.

## Value

Modified `brain_atlas` with matching views removed

## Examples

``` r
if (FALSE) { # \dontrun{
# Remove inferior views
atlas <- atlas |> atlas_view_remove("inferior")

# Remove multiple views
atlas <- atlas |> atlas_view_remove(c("axial_1", "axial_2"))
} # }
```
