# Detect atlas type

Detect atlas type

## Usage

``` r
atlas_type(x)
```

## Arguments

- x:

  brain atlas object

## Value

Character string: "cortical", "subcortical", or "tract"

## Examples

``` r
atlas_type(dk())
#> [1] "cortical"
atlas_type(aseg())
#> [1] "subcortical"
atlas_type(tracula())
#> [1] "tract"
```
