# ggseg.formats 

## ggseg.formats 0.0.2

### Deep cerebellar nuclei support

- `ggseg_data_cerebellar()` gains an optional `meshes` parameter for deep
  cerebellar structures (e.g. dentate, interposed, fastigial nuclei) that
  are not on the SUIT cortical surface. Surface regions use `vertices`
  (shared SUIT mesh), deep structures use individual `meshes` (like
  subcortical atlases).
- Validation now checks the union of `vertices` + `meshes` labels against
  core when both are present, rather than requiring each to cover all labels
  independently.
- `rebuild_atlas_data()` preserves cerebellar data type and handles mixed
  vertices + meshes correctly.

### Bug fixes

- `reposition_views()` now handles `sfc_GEOMETRY` (mixed geometry types) by
  casting to `MULTIPOLYGON` before coordinate operations.
- `atlas_view_gather()` is more robust against non-sf or empty sf data,
  preventing errors in subcortical and tract pipelines.

## ggseg.formats 0.0.1

Initial CRAN release. Extracts and formalises the atlas data structures that
were previously embedded in `ggseg` and `ggseg3d`.

### Unified `ggseg_atlas` S3 class

- `ggseg_atlas()` constructor with typed data containers for cortical,
  subcortical, tract, and cerebellar atlases.
- Type-checking predicates: `is_ggseg_atlas()`, `is_cortical_atlas()`,
  `is_subcortical_atlas()`, `is_tract_atlas()`, `is_cerebellar_atlas()`.
- Coercion with `as_ggseg_atlas()`, `as.data.frame()`, and `as.list()`
  methods.
- `plot()` method for quick atlas visualisation via ggplot2.

### Accessors

- `atlas_type()`, `atlas_regions()`, `atlas_labels()`, `atlas_palette()`,
  `atlas_sf()`, `atlas_vertices()`, `atlas_meshes()`, and `atlas_views()`
  for querying atlas contents without reaching into slots.

### Atlas manipulation

- Pipe-friendly region operations: `atlas_region_keep()`,
  `atlas_region_remove()`, `atlas_region_rename()`,
  `atlas_region_contextual()`.
- Metadata enrichment with `atlas_core_add()`.
- View management: `atlas_view_keep()`, `atlas_view_remove()`,
  `atlas_view_remove_region()`, `atlas_view_remove_small()`,
  `atlas_view_gather()`, `atlas_view_reorder()`.

### Bundled atlases

- Ships three ready-to-use atlases: `dk()` (Desikan-Killiany cortical),
  `aseg()` (FreeSurfer subcortical), and `tracula()` (white matter tracts).
- `get_brain_mesh()` and `get_cerebellar_mesh()` provide 3D surface meshes
  for rendering.

### Legacy conversion

- `convert_legacy_brain_atlas()` and `unify_legacy_atlases()` bridge old
  `ggseg`/`ggseg3d` atlas objects to the unified format.
- Deprecated wrappers (`brain_atlas()`, `brain_regions()`, etc.) ease
  migration from the old API.

### FreeSurfer I/O

- `read_freesurfer_stats()`, `read_atlas_files()`, and
  `read_freesurfer_table()` for reading FreeSurfer statistics into R.
