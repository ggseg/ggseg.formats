# ggseg.formats

## ggseg.formats 0.0.2.9004 (development)

### Bug fixes

- `atlas_sf()` no longer re-sorts geometry rows alphabetically by `label`. The
  underlying `merge()` defaulted to `sort = TRUE`, which discarded the
  context-behind-core draw order established by the manipulation helpers, so
  contextual regions could draw on top of focus regions. The ordering is now
  preserved and re-applied after the join, matching `as.data.frame()`.
- `atlas_type()` can again guess the type of an atlas whose `type` is unset:
  `guess_type()` now reads views from the unified `$data` geometry slot instead
  of the legacy bare `$sf` slot, which a modern `ggseg_atlas` never populates
  (it previously always guessed `"subcortical"`).
- `read_atlas_files()` extracts the subject id by stripping the `subjects_dir`
  prefix by length rather than as a regular expression, so directories
  containing regex metacharacters (or a trailing slash) no longer yield the
  wrong subject.
- `read_freesurfer_table(measure = )` strips the `_<measure>` suffix literally
  from the end of each label instead of with an unanchored regex, so a label
  that contains the measure mid-string is no longer over-stripped.
- `atlas_palette()` given a non-atlas object now errors with a class-specific
  message instead of interpolating the whole object into "Could not find
  atlas".

### Breaking changes

- `atlas_palette()` now takes a `ggseg_atlas` object only (its first argument
  is `atlas`). Looking an atlas up by name string (e.g. `atlas_palette("dk")`)
  is no longer supported — pass the atlas, e.g. `atlas_palette(dk())`.

### Documentation & internals

- Corrected the package-level help page: the title and `?ggseg.formats` alias
  are now derived from `DESCRIPTION` (previously titled "Plot brain
  segmentations with ggplot" and aliased as `ggseg`).
- Dropped the vestigial `utils::globalVariables()` registration, which no
  longer referenced any global used by the package.

### sf-optional migration

- New vignette `vignette("migrating-atlases")` — a three-line recipe for
  downstream atlas-package maintainers to migrate their `data/*.rda` to the
  sf-optional polygon format with `migrate_atlas_files()`.
- `as_polygon_atlas()` now aborts with an actionable message naming
  `migrate_atlas_files()` when it meets a still-sf-backed atlas on an install
  where `sf` is not available, instead of a generic "sf is required" error.

### Internal & tooling

- Added a package hex logo: the brain as atlas data — dk lobes traced as a
  sparse "connect-the-dots" network of vertices and edges, in a plum take on
  the ggsegverse house style. Reproducible via `data-raw/make_hex.R`.
- The package now passes the full `goodpractice` + tidyverse check suite as a
  CI hard gate, at 100% line coverage. Formatting is enforced with `air` and
  linting with `lintr`.

## ggseg.formats 0.0.2.9001 (development)

### Base-R `plot()` (breaking)

`plot.ggseg_atlas()` is reimplemented with base graphics
(`graphics::polygon()` / `graphics::polypath()`), and **`ggplot2` is dropped
from Imports** — the package no longer depends on ggplot2 for its own plotting.

- `plot()` now returns the atlas invisibly rather than a `ggplot` object; it is
  called for its side effect. Each spatially separate piece (e.g. a hemisphere
  surface or a slice) is drawn in its own panel, arranged in a near-square grid
  for a legible overview of the atlas. Code that captured the return value to
  add ggplot2 layers (`plot(atlas) + ...`) must be updated.
- The `show.legend` argument is removed; the base-R plot draws no legend. Extra
  arguments in `...` are forwarded to the underlying `polygon()` / `polypath()`
  primitives (e.g. `lwd`, `border`).
- `vdiffr` is dropped from Suggests; the plot tests no longer snapshot SVG.

### Lighter dependency tree

- Dropped the `dplyr` and `tidyr` Imports in favour of base-R equivalents,
  shrinking the recursive dependency tree from 32 to 20 packages (also removes
  `tibble`, `pillar`, `purrr`, `stringi`, `stringr`, `tidyselect`, `generics`,
  `magrittr` and more). Returned data objects keep the `tbl_df`/`tbl` classes
  so they continue to integrate with `tibble`/`dplyr` workflows, but `tibble`
  is no longer required at install time.
- `print()` for a `ggseg_atlas` now shows the first 10 core rows by default
  (atlases can have hundreds of regions); pass `n` to control how many rows
  print, e.g. `print(dk(), n = 50)`.

### Bundled SUIT cerebellar atlas

- New `suit()` bundled atlas — the SUIT cerebellar parcellation (lobules + deep
  nuclei) from ggsegSUIT, stored in the sf-optional polygon (`geom`) format with
  3D vertices (lobules) and meshes (nuclei). ggseg.formats now ships one atlas of
  each kind: `dk()` (cortical), `aseg()` (subcortical), `tracula()` (tract),
  `suit()` (cerebellar).

### Unified `geom` slot (breaking)

Atlas 2D geometry now lives in a single `atlas$data$geom` slot whose class
(`sf` or `brain_polygons`) determines the rendering path. The parallel `sf` and
`polygons` slots are gone — conversion between the two is lossless, so only one
representation is ever stored.

- New accessors: `atlas_geom()`, `atlas_polygons()`, `atlas_geometry_type()`,
  `is_atlas_sf()`, `is_atlas_polygon()`. `atlas_sf()` now converts from the
  polygon representation when needed and is the single interception point for
  ggseg plotting. `atlas_geom()` falls back to a legacy `sf` slot, so atlases
  built before this change keep working. Reverse dependencies should call these
  accessors rather than reaching into `atlas$data`.
- `ggseg_data_cortical()` / `ggseg_data_subcortical()` /
  `ggseg_data_cerebellar()` / `ggseg_data_tract()` now take a single `geom`
  argument. A released `sf` argument is still accepted via `...` (converted to
  polygons via `sf_to_polygons()`) with a deprecation warning.
- `as_polygon_atlas()` / `as_sf_atlas()` set the single `geom` slot.
- `migrate_atlas_files()` rewrites atlases to the single `geom` slot
  (polygons by default; `keep_sf = TRUE` stores sf).

### sf-optional atlas format

Foundation work for the `sf-optional` milestone — see
[ggsegverse/ggseg.formats#4](https://github.com/ggsegverse/ggseg.formats/issues/4).

- New `brain_polygons` representation: a nested tibble keyed by `label`, with a
  `geometry` list-column containing per-view, per-ring point coordinates
  (`view`, `x`, `y`, `group`, `subgroup`). Renderable directly by
  `geom_polygon()` via the `subgroup` aesthetic (which handles holes
  through `grid::pathGrob` even-odd fill).
- Geometry round-trips between sf and `brain_polygons` losslessly. The sf-side
  conversion uses `sfheaders` (pure Rcpp, no GDAL/GEOS/PROJ system libraries),
  enabling wasm builds and air-gapped installation paths. The low-level
  converters are internal; the public API is the atlas-level `as_sf_atlas()` /
  `as_polygon_atlas()` and the `atlas_sf()` / `atlas_polygons()` accessors.
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

### Region geometry operations

- New `atlas_region_op()` combines two sets of region geometry with a boolean
  operation per view (`difference`, `intersection`, `union`, `symdifference`),
  writing the result to a new region. Boolean ops need a geometry engine, so
  this helper always requires `sf`; a polygon-only atlas is rehydrated for the
  operation and the result returned in polygon form.
- `atlas_region_contextual()` now operates on whichever 2D representation an
  atlas carries (`sf` and/or `polygons`) and keeps both in sync — it needs no
  `sf` for a polygon-only atlas. It also gains an `ignore.case` argument.
- The atlas manipulation helpers no longer leave a stale `polygons` slot behind
  a freshly rewritten `sf` slot; the two 2D representations stay consistent
  after every operation.

### sf-free view manipulation

- `atlas_context_remove()`, `atlas_view_remove()`, `atlas_view_keep()`,
  `atlas_view_remove_region()`, `atlas_view_remove_small()`,
  `atlas_view_gather()`, and `atlas_view_reorder()` now run on polygon-only
  atlases with no `sf` installed. Filtering, polygon area (shoelace), and view
  repositioning are implemented in pure R against the `brain_polygons`
  coordinate table; the polygon results match the sf path to floating-point
  precision. sf-backed atlases continue to use the existing sf code path
  unchanged.
- `atlas_views()` reads view names from `polygons` when `sf` is absent.
- `atlas_region_keep()` and `atlas_region_remove()` no longer drop 2D geometry
  on polygon-only atlases (they previously rebuilt from the `sf` slot only).
- View helpers now warn about "no 2D geometry" (rather than "no sf data") only
  when an atlas carries neither `sf` nor `polygons`.

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
