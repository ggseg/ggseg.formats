# ggseg.formats 0.0.1.9001

## Deep cerebellar nuclei support

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

## Bug fixes

- `reposition_views()` now handles `sfc_GEOMETRY` (mixed geometry types) by
  casting to `MULTIPOLYGON` before coordinate operations.
- `atlas_view_gather()` is more robust against non-sf or empty sf data,
  preventing errors in subcortical and tract pipelines.
