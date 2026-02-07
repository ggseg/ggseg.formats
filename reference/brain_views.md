# Get available views in atlas

Returns the unique view names from the atlas sf data.

## Usage

``` r
brain_views(atlas)
```

## Arguments

- atlas:

  A `brain_atlas` object

## Value

Character vector of view names, or NULL if no sf data

## Examples

``` r
if (FALSE) { # \dontrun{
brain_views(aseg)
# [1] "axial_inferior" "axial_superior" "coronal_anterior" ...
} # }
```
