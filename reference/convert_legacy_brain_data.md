# Convert legacy brain_atlas data to unified format

Converts an old-style brain_atlas (where `$data` contains sf directly)
to the unified format with `$core` and `$data` (ggseg_atlas_data).

## Usage

``` r
convert_legacy_brain_data(x)
```

## Arguments

- x:

  A legacy brain_atlas

## Value

A ggseg_atlas in unified format
