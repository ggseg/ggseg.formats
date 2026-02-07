# Keep only specified views

Inverse of [`atlas_view_remove()`](atlas_view_remove.md) - keeps only
views matching the pattern.

## Usage

``` r
atlas_view_keep(atlas, views)
```

## Arguments

- atlas:

  A `brain_atlas` object

- views:

  Character vector of view names or patterns to keep. Multiple values
  are collapsed with "\|" for matching. Uses
  `grepl(..., ignore.case = TRUE)`.

## Value

Modified `brain_atlas` with only matching views kept

## Examples

``` r
if (FALSE) { # \dontrun{
# Keep only axial views
atlas <- atlas |> atlas_view_keep("axial")

# Keep specific views using vector
atlas <- atlas |> atlas_view_keep(c("axial_3", "coronal_2", "sagittal"))
} # }
```
