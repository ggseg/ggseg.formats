# Constructor for ggseg atlas

Creates an object of class 'ggseg_atlas' for plotting brain
parcellations using ggseg (2D) and ggseg3d (3D).

## Usage

``` r
ggseg_atlas(atlas, type, core, data, palette = NULL)

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

  a ggseg_atlas_data object created by
  [`ggseg_data_cortical()`](https://ggseg.github.io/ggseg.formats/reference/ggseg_data_cortical.md),
  [`ggseg_data_subcortical()`](https://ggseg.github.io/ggseg.formats/reference/ggseg_data_subcortical.md),
  or
  [`ggseg_data_tract()`](https://ggseg.github.io/ggseg.formats/reference/ggseg_data_tract.md).
  Must match the specified type.

- palette:

  named character vector of colours keyed by label

## Value

an object of class 'ggseg_atlas'

## Examples

``` r
if (FALSE) { # \dontrun{
# Cortical atlas
atlas <- ggseg_atlas(
  atlas = "dk",
  type = "cortical",
  core = core_df,
  data = ggseg_data_cortical(sf = geometry, vertices = vertex_indices)
)

# Tract atlas
atlas <- ggseg_atlas(
  atlas = "hcp_tracts",
  type = "tract",
  core = core_df,
  data = ggseg_data_tract(
    meshes = tube_meshes,
    scalars = list(FA = fa_values)
  )
)
} # }
```
