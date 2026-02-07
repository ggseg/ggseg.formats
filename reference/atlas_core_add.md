# Add metadata to atlas core

Joins additional metadata columns to the atlas core data frame.

## Usage

``` r
atlas_core_add(atlas, data, by = "region")
```

## Arguments

- atlas:

  A `brain_atlas` object

- data:

  Data frame with metadata to join

- by:

  Column(s) to join by. Default is "region".

## Value

Modified `brain_atlas` with additional core columns

## Examples

``` r
if (FALSE) { # \dontrun{
lobe_data <- data.frame(
  region = c("bankssts", "fusiform"),
  lobe = c("temporal", "temporal")
)
atlas <- atlas |> atlas_core_add(lobe_data)
} # }
```
