# Migrate the bundled atlases inside sysdata.rda to the sf-optional polygon
# format.
#
# `dk()`, `aseg()`, and `tracula()` historically shipped sf-backed geometry,
# so plotting them still pulled in `sf` (and GDAL/GEOS/PROJ) even though the
# rest of the stack had gone sf-optional. Converting their single `geom` slot
# to `brain_polygons` lets them install and plot without `sf`. The conversion
# is lossless, so figures are unchanged for everyone — it only pre-computes the
# polygon table that ggseg already derives from sf at plot time.
#
# This refreshes R/sysdata.rda in place without re-running the heavy
# atlas-build pipelines (make_dk_atlas.R, etc.). Requires `sf` to do the
# one-time conversion. Safe to re-run.
#
# Run with: source("data-raw/refresh_sysdata_polygons.R")

devtools::load_all()

stopifnot(rlang::is_installed("sf"))

env <- new.env(parent = emptyenv())
load("R/sysdata.rda", envir = env)

env$.dk_atlas <- as_polygon_atlas(env$.dk_atlas)
env$.aseg_atlas <- as_polygon_atlas(env$.aseg_atlas)
env$.tracula_atlas <- as_polygon_atlas(env$.tracula_atlas)

save(
  list = ls(env, all.names = TRUE),
  file = "R/sysdata.rda",
  envir = env,
  compress = "xz"
)

cli::cli_alert_success(
  "Migrated .dk_atlas, .aseg_atlas, .tracula_atlas to the polygon format."
)
