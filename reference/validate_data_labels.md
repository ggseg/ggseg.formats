# Validate data labels against core

3D sources (vertices, meshes, centerlines) are validated strictly: every
core label must have a corresponding entry. This check always runs.

## Usage

``` r
validate_data_labels(data, core, check_sf = FALSE)
```

## Arguments

- data:

  ggseg_atlas_data object

- core:

  core data.frame

- check_sf:

  if TRUE, validate sf label coverage against core

## Value

data (unchanged)

## Details

When `check_sf = TRUE` (the default at construction time), sf coverage
is also checked: an error is raised when fewer than 80 percent of core
labels appear in sf, and a warning when fewer than 90 percent. This
threshold is relaxed because 2D projections cannot always capture every
region (too small, occluded, etc.).

During manipulation (view removal, region cleanup) sf coverage naturally
drops, so `rebuild_atlas` calls with `check_sf = FALSE`.

Labels in data that are not in core are always allowed — these represent
context-only geometry (like medial wall) that renders grey without
appearing in legends.
