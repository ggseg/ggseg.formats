# Consolidate all internal data into R/sysdata.rda
#
# Combines brain meshes and atlas objects into a single internal data file.
#
# Prerequisites:
#   - data/dk.rda, data/aseg.rda, data/tracula.rda must exist
#     (built by their respective make_*_atlas.R scripts)
#   - data-raw/make_brain_mesh_inflated.R must have been run
#   - data-raw/make_cerebellar_mesh.R must have been run
#
# Run with: source("data-raw/make_sysdata.R")

devtools::load_all()

load("R/sysdata.rda")

dk_env <- new.env()
aseg_env <- new.env()
tracula_env <- new.env()
load("data/dk.rda", envir = dk_env)
load("data/aseg.rda", envir = aseg_env)
load("data/tracula.rda", envir = tracula_env)

.dk_atlas <- dk_env$dk
.aseg_atlas <- aseg_env$aseg
.tracula_atlas <- tracula_env$tracula

# Ship the bundled atlases in the polygon format so they install and plot
# without sf. The conversion is lossless; see refresh_sysdata_polygons.R.
.dk_atlas <- as_polygon_atlas(.dk_atlas)
.aseg_atlas <- as_polygon_atlas(.aseg_atlas)
.tracula_atlas <- as_polygon_atlas(.tracula_atlas)

usethis::use_data(
  brain_mesh_inflated,
  cerebellar_mesh_suit,
  .dk_atlas,
  .aseg_atlas,
  .tracula_atlas,
  internal = TRUE,
  overwrite = TRUE,
  compress = "xz"
)

unlink("data", recursive = TRUE)

cli::cli_alert_success(
  "Saved brain_mesh_inflated, cerebellar_mesh_suit,
  .dk_atlas, .aseg_atlas, .tracula_atlas to
  R/sysdata.rda"
)
