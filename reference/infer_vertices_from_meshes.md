# Infer vertex indices by matching mesh coordinates to brain surface

Hash-based O(n+m) matching that rounds coordinates to 4 decimal places
and uses named vector lookup. Interpolated triangulation vertices that
don't match exactly are silently skipped.

## Usage

``` r
infer_vertices_from_meshes(atlas_3d, surface = "inflated", brain_meshes = NULL)
```

## Arguments

- atlas_3d:

  A `ggseg3d_atlas` with mesh data.

- surface:

  Which surface to match against (default `"inflated"`).

- brain_meshes:

  Brain mesh data to match against. If NULL, uses the internal inflated
  mesh. Supports both `list(lh = ..., rh = ...)` and
  `list(lh_inflated = ..., ...)` formats.

## Value

Named list of integer vertex indices (0-based) keyed by label, or NULL
if brain_meshes unavailable.
