# Validate data labels against core

Ensures all core labels have corresponding data. Labels in data that are
not in core are allowed - these represent context-only geometry (like
medial wall) that will display grey without appearing in legends.

## Usage

``` r
validate_data_labels(data, core)
```

## Arguments

- data:

  brain_atlas_data object

- core:

  core data.frame

## Value

data (unchanged)
