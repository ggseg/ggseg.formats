# ggseg.formats

## ggseg.formats 0.0.3 (development)

### sf-optional atlas format

Foundation work for the `sf-optional` milestone — see
[ggsegverse/ggseg.formats#4](https://github.com/ggsegverse/ggseg.formats/issues/4).

- New `brain_polygons` representation: a nested tibble keyed by `label`, with a
  `geometry` list-column containing per-view, per-ring point coordinates
  (`view`, `x`, `y`, `group`, `subgroup`). Renderable directly by
  `ggplot2::geom_polygon()` via the `subgroup` aesthetic (which handles holes
  through `grid::pathGrob` even-odd fill).
- `sf_to_polygons()` and `polygons_to_sf()` round-trip atlas geometry losslessly.
  The sf-side conversion uses `sfheaders` (pure Rcpp, no GDAL/GEOS/PROJ system
  libraries), enabling wasm builds and air-gapped installation paths.
- `ggseg_data_cortical()`, `ggseg_data_subcortical()`, `ggseg_data_cerebellar()`,
  and `ggseg_data_tract()` now accept a `polygons =` argument alongside `sf =`.
  When only `sf` is supplied, the `polygons` slot is derived automatically; the
  two slots are kept in sync so existing callers see no change.
- `as_polygon_atlas()` and `as_sf_atlas()` convert between the sf-backed and
  polygon-only forms at the atlas level.
- `migrate_atlas_files()` walks a package's `data/` directory and rewrites every
  `ggseg_atlas` `.rda` to the polygon format. Intended for downstream
  atlas-package maintainers across the ggsegverse ecosystem.
- `validate_data_labels()` checks 2D label coverage against whichever 2D source
  is present (`sf` or `polygons`), preserving the same 80%/90% thresholds.

`sfheaders` joins Imports. **`sf` moves from Imports to Suggests.** The
package can now be installed without GDAL / GEOS / PROJ system libraries —
enabling wasm builds and air-gapped installs. Functions that genuinely need
sf (e.g. `validate_sf()`, `as.data.frame.ggseg_atlas()`, `plot.ggseg_atlas()`,
the `atlas_view_*` repositioning helpers) check `requireNamespace("sf")` at
entry and error with a clear pointer to `as_polygon_atlas()` if sf is
unavailable. The bundled `dk`, `aseg`, and `tracula` atlases still carry
their `sf` slots, so callers who have sf installed see no behavioural change.

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
