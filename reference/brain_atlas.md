# Constructor for brain atlas

Creates an object of class 'brain_atlas' for plotting brain
parcellations using ggseg (2D) and ggseg3d (3D).

## Usage

``` r
brain_atlas(atlas, type, core, data, palette = NULL)
```

## Arguments

- atlas:

  atlas short name, length one

- type:

  atlas type: "cortical", "subcortical", or "tract"

- core:

  data.frame with required columns hemi, region, label (one row per
  unique region). May contain additional columns for grouping or
  metadata (e.g., lobe, network, Brodmann area).

- data:

  a brain_atlas_data object created by one of:
  [`cortical_data()`](cortical_data.md),
  [`subcortical_data()`](subcortical_data.md), or
  [`tract_data()`](tract_data.md). Must match the specified type.

- palette:

  named character vector of colours keyed by label

## Value

an object of class 'brain_atlas'

## Examples

``` r
if (FALSE) { # \dontrun{
# Cortical atlas
atlas <- brain_atlas(
  atlas = "dk",
  type = "cortical",
  core = core_df,
  data = cortical_data(sf = geometry, vertices = vertex_indices)
)

# Tract atlas
atlas <- brain_atlas(
  atlas = "hcp_tracts",
  type = "tract",
  core = core_df,
  data = tract_data(meshes = tube_meshes, scalars = list(FA = fa_values))
)
} # }
```
