# geom-slot refactor — status

Branch: `sf-optional-suggests` (PR #7, based on `sf-optional-lite-format` = PR #6).

## Goal

Single `atlas$data$geom` slot whose class (`sf` or `brain_polygons`) drives
dispatch. Lossless conversion, so only one representation stored. Reverse deps
call accessors (`atlas_sf()` / `atlas_geom()`), never `$data` directly.
Constructors take `geom` only; a released `sf=` is captured via `...` (→ polygons

- deprecation). Backward compatible: `atlas_geom()` falls back to a legacy `sf`
  slot so released atlases keep working.

## DONE — ggseg.formats fully green, committed, pushed

- **Source unified to `geom`**: accessors (`atlas_geom`, `atlas_polygons`,
  `atlas_geometry_type`, `is_atlas_sf`, `is_atlas_polygon`; `atlas_sf()` converts
  polygon→sf and is ggseg's interception point); constructors (`geom` + legacy
  `sf=` via `...` with `deprecate_warn`); converters; all region/view ops
  (rebuilt on `geom` via `rebuild_data_with_geom()` + `geom_drop_pattern()`);
  validation, print/plot, coercion, atlas-convert, `migrate_atlas_files`.
- **Tests migrated**: whole suite on the geom model — **687 pass, 0 fail, 0 warn**.
- **Lint 0**, **pkgdown clean**, version `0.0.3.9001`, NEWS entry.
- **Critical-code-reviewer run + findings fixed**:
  - Cerebellar atlases (vertices + meshes) were rebuilt as cortical by the
    region ops (vertices-first branch), dropping deep-nuclei meshes and flipping
    `atlas_type()`. Fixed by routing all three region ops through
    `rebuild_data_with_geom(keep_row=)`; added regression tests.
  - `is_atlas_sf()`/`is_atlas_polygon()` return `FALSE` for non-atlas input.
  - `resolve_geom()` warns when both `geom` and `sf` supplied.
- Commits `a084aba`..`1829e71` on `sf-optional-suggests`, all pushed.

## DONE — reverse deps (already geom-native, verified)

- **ggseg.extra** (`feature/anatomical-coregister`) already uses
  `ggseg.formats::atlas_geom()` / `atlas_sf()` / `as_*_atlas()` and sets
  `$data$geom`. Verified against the locally-installed new ggseg.formats:
  `test-subcortical-builders` (32) and `test-atlas-geometry` (64) pass.
- **ggseg**: no raw `$data$sf` / `$data$polygons` access — unaffected.

## LEFT FOR YOU

1. **Merge the stack to main** — deliberately not done. The change lives on #7,
   which has **no CI** (it targets #6's branch; the R-CMD-check / code-quality /
   pkgdown workflows only run on PRs to `main`/`master`). Options:
   - Retarget PR #7's base to `main` (triggers full CI on the whole change,
     supersedes #6), review CI, then merge; or
   - Land #6 then #7. (#6 on its own is not green — its lint/pkgdown failures are
     fixed only by the #7 commits, so retarget-#7 is cleaner.)
     I held off because it's an irreversible breaking change to a published
     package's default branch with only local (not CI) green, and the topology is
     your call.
2. **r-universe rebuild / version pin** — once this lands on `main`, r-universe
   rebuilds and ggseg.extra **#86 CI goes green** (the skew that broke it —
   `atlas_region_op` / `atlas_region_contextual(ignore.case=)` — is now on the
   new ggseg.formats, plus the geom API). Or pin `Remotes:` to unblock sooner.
3. **freesurfer `get_fs` fix** — committed on the fork branch
   `fix/get-fs-empty-semicolons` (NOT pushed). Fixes issue #82 / PR #84 root
   cause (leading / `; ;` in `get_fs()`). Awaiting your go-ahead to push + PR.

## Stashes (preserved, none popped)

- `stash@{0}` (sf-optional-lite-format): #6 green-fixes — superseded by the work
  on #7 (pkgdown index + lint now handled here). Can likely drop.
- `stash@{1}`: DESCRIPTION GitHub-comment + `update-codemeta.yaml` (unrelated WIP).
- `stash@{2}`: "wip atlas_context_remove (not mine, isolating)" — pre-existing.
