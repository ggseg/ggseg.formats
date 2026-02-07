# Reorder views

Changes the order of views in the atlas sf data and repositions them
accordingly. Views not specified in the order are appended at the end in
their original order.

## Usage

``` r
atlas_view_reorder(atlas, order, gap = 0.15)
```

## Arguments

- atlas:

  A `brain_atlas` object

- order:

  Character vector specifying desired view order. Can be partial -
  unspecified views are appended at the end.

- gap:

  Proportional gap between views (default 0.15 = 15% of max width)

## Value

Modified `brain_atlas` with views reordered and repositioned

## Examples

``` r
if (FALSE) { # \dontrun{
# Put sagittal first, then specific axial views
atlas <- atlas |>
  atlas_view_reorder(c("sagittal", "axial_3", "axial_5"))

# Reverse order
atlas <- atlas |>
  atlas_view_reorder(rev(brain_views(atlas)))
} # }
```
