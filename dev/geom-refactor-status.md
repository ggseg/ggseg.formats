# geom-slot refactor — status & handoff

Branch: `sf-optional-suggests` (PR #7, based on `sf-optional-lite-format` = PR #6).

## Goal (your design, this session)

Replace the parallel `atlas$data$sf` + `atlas$data$polygons` slots with a single
`atlas$data$geom` slot whose **class** (`sf` or `brain_polygons`) drives dispatch.
Conversion is lossless, so only one representation is ever stored. Reverse deps
call accessors (`atlas_sf()` / `atlas_geom()`), never `$data` directly. Constructors
take `geom` only; a released `sf=` is captured via `...`, converted to polygons,
with a deprecation warning. Backward compatible: `atlas_geom()` falls back to the
legacy `sf` slot so released atlases keep working.

## DONE (committed + pushed)

- `a084aba refactor(data)!: unify atlas 2D geometry into a single geom slot`
  - `R/atlas-accessors.R`: `atlas_geom()`, `atlas_polygons()`, `atlas_geometry_type()`,
    `is_atlas_sf()`, `is_atlas_polygon()`; `atlas_sf()` converts polygon→sf; internal
    `geom_from_data()` / `data_sf()` / `data_poly()` getters (legacy `sf` fallback).
  - `R/ggseg_atlas_data.R`: all four `ggseg_data_*()` take `geom` only + `resolve_geom()`
    captures legacy `sf=` via `...` (→ polygons + deprecate_warn). `man-roxygen/geom.R`,
    `man-roxygen/geom_dots.R` templates.
  - `R/atlas-polygon-converters.R`: `as_polygon_atlas()`/`as_sf_atlas()` set single geom.
  - `R/atlas-utils.R`: every region/view op routes through `geom_from_data()` +
    `rebuild_data_with_geom()`; `geom_drop_pattern()` dispatcher in `atlas-polygon-ops.R`.
  - `R/validation.R`, `R/ggseg_atlas.R` (print/plot/as.data.frame), `R/coercion.R`,
    `R/atlas-convert.R`, `R/migrate-atlas-files.R` all migrated.
  - Package LOADS; verified `dk()` → sf via fallback, `atlas_sf()`, `as_polygon_atlas()`.
- `2507c32 test(polygons): migrate to single geom slot model` — test-atlas-polygons.R (45 pass).

## REMAINING (in priority order)

### 1. Migrate remaining test files (currently failing)

Pattern for construction: `ggseg_data_*(sf = X, ...)` → `ggseg_data_*(geom = X, ...)`
(stores X as-is; no deprecation). Assertions: `x$data$sf` → `atlas_geom(x)` /
`x$data$geom`; drop `x$data$polygons` dual-checks.

- **Mostly mechanical**: test-atlas-accessors, test-ggseg_atlas_data, test-ggseg_atlas,
  test-coercion, test-ggseg-atlas-plots.
- **test-validation.R**: was testing _sf-specific_ error messages
  (`"must contain columns"`). With `geom=`, a non-sf/non-polygon input now errors with
  `"must be an sf or brain_polygons object"`. Decide: keep testing via the deprecated
  `sf=` path (wrap in `withr::local_options(lifecycle_verbosity="quiet")`), or rewrite
  to assert the new geom-validation messages.
- **test-atlas-convert.R**: the `list(sf = ...)` / top-level `$sf` cases are _legacy
  brain_atlas inputs_ to conversion — leave those as legacy sf; only change converter
  _outputs_ (`result$data$sf` → `result$data$geom`).
- **test-atlases.R**: likely already passes — bundled `dk()/aseg()` kept legacy `sf`
  layout, so `dk()$data$sf` still exists. Verify, don't pre-emptively edit.
- **test-atlas-utils.R (89 refs) — NEEDS YOUR DECISION**: many tests assert the
  _dual sf+polygons sync_ invariant that the redesign removes, e.g.
  `expect_setequal(r$data$sf$label, r$data$polygons$label)` and "auto-derives polygons
  from sf". These can't be mechanically substituted — their _purpose_ is gone. They
  should be **rewritten** to assert single-geom behavior (e.g. the op preserves
  `atlas_geom()` labels and class), not deleted. I did not touch them: per your standing
  rule I won't delete test sections without approval. Setup lines like
  `atlas$data$sf <- NULL` (to build a polygon-only fixture) should become
  `atlas$data$geom <- <polygons>` / construct with `geom = <polygons>`.

### 2. pkgdown index — `is_atlas_sf` / `is_atlas_polygon` start with `is_atlas`, not

matched by the `_pkgdown.yml` `starts_with("is_ggseg")`. Add them (or broaden) or
pkgdown CI fails. (`atlas_geom`/`atlas_polygons`/`atlas_geometry_type` are covered by
`starts_with("atlas_")`.) Also reapply the #6 `_pkgdown.yml` "Lite (sf-optional)"
section — it's in `git stash@{0}` ("wip #6 green-fixes").

### 3. Version bump + NEWS. DESCRIPTION 0.0.3.9000 → 0.0.3.9001 (matches the

`deprecate_warn(when = "0.0.3.9001")`). Add a NEWS entry describing the geom slot +
new accessors + breaking `ggseg_data_*` signature.

### 4. Reverse deps → accessors (don't read `$data$sf`/`$data$polygons`):

- ggseg: `R/annotate-brain-polygon.R`, `R/geom-brain-polygon.R`
- ggseg.extra: `R/utils.R`, `R/subcortical-builders.R`, `R/atlas-geometry.R`
  Use `atlas_geom()` / `atlas_sf()`. These need the new ggseg.formats installed to test.

### 5. `/critical-code-reviewer` on the full diff, fix findings. (Deferred until green —

reviewing a mid-migration tree is noisy.)

### 6. Merge: NOT done. Stack is `main ← #6 ← #7`. The geom work lives on #7.

Left for your review given it's a ~1500-line breaking cross-package change.

## Stashes (preserved, none popped)

- `stash@{0}` (on sf-optional-lite-format): #6 green-fixes — `_pkgdown.yml` Lite section
  - lint long-line/nolint fixes + as_sf doc. Reapply pieces during step 2.
- `stash@{1}`: DESCRIPTION GitHub-comment tweak + `update-codemeta.yaml` (unrelated WIP).
- `stash@{2}`: "wip atlas_context_remove (not mine, isolating)" — pre-existing, not mine.

## Related (separate, earlier this session)

- ggseg.formats `get_fs` fix is in the **freesurfer fork** (`drmowinckels/freesurfer`,
  branch `fix/get-fs-empty-semicolons`, committed, NOT pushed) — addresses issue #82 /
  PR #84 root cause (leading/`; ;` in `get_fs()`).
- ggseg.extra PR #86 CI was red purely due to this ggseg.formats version skew
  (`atlas_region_op` / `atlas_region_contextual(ignore.case=)` not on installed
  ggseg.formats). Resolves once this lands + r-universe rebuilds (or pin Remotes).
