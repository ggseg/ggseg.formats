# Gather views to remove gaps

After removing views with [`atlas_view_remove()`](atlas_view_remove.md),
gaps remain in the x-axis layout. This function repositions the
remaining views to close those gaps while preserving view order.

## Usage

``` r
atlas_view_gather(atlas, gap = 0.15)
```

## Arguments

- atlas:

  A `brain_atlas` object

- gap:

  Proportional gap between views (default 0.15 = 15% of max width)

## Value

Modified `brain_atlas` with views repositioned

## Examples

``` r
if (FALSE) { # \dontrun{
atlas <- atlas |>
  atlas_view_remove("axial_1|axial_2") |>
  atlas_view_gather()
} # }
```
