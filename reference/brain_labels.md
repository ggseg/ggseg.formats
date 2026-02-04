# Extract unique labels of brain regions

Convenience function to extract names of brain labels from a
[`brain_atlas`](brain_atlas.md). Brain labels are usually default naming
obtained from the original atlas data.

## Usage

``` r
brain_labels(x)

# S3 method for class 'ggseg_atlas'
brain_labels(x)

# S3 method for class 'brain_atlas'
brain_labels(x)
```

## Arguments

- x:

  brain atlas

## Value

Character vector of atlas region labels
