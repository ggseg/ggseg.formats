# Convert legacy brain_atlas structure

Converts a brain_atlas with separate sf/vertices/meshes fields to the
new structure with a single data field.

## Usage

``` r
convert_legacy_structure(x)
```

## Arguments

- x:

  A legacy brain_atlas

## Value

A ggseg_atlas with the new structure
