# Rename regions in atlas

Renames regions matching a pattern to a new name, or applies a
transformation function. Only affects the `region` column
(human-readable names), not the `label` column (technical identifiers).

## Usage

``` r
atlas_region_rename(atlas, pattern, replacement)
```

## Arguments

- atlas:

  A `brain_atlas` object

- pattern:

  Character pattern to match against region names

- replacement:

  Replacement string or function. If a function, it receives the matched
  region names and should return new names.

## Value

Modified `brain_atlas` with renamed regions

## Examples

``` r
if (FALSE) { # \dontrun{
# Simple replacement
atlas <- atlas |> atlas_region_rename("bankssts", "banks of STS")

# Using a function
atlas <- atlas |> atlas_region_rename(".*", toupper)
} # }
```
