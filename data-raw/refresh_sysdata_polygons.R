# Add the `polygons` slot to the bundled atlases inside sysdata.rda.
#
# This refreshes R/sysdata.rda in place without re-running the heavy
# atlas-build pipelines (make_dk_atlas.R, etc.). It is safe to re-run.
#
# Run with: source("data-raw/refresh_sysdata_polygons.R")

devtools::load_all()

env <- new.env(parent = emptyenv())
load("R/sysdata.rda", envir = env)

augment <- function(atlas) {
  if (is.null(atlas$data$polygons) && !is.null(atlas$data$sf)) {
    atlas$data$polygons <- sf_to_polygons(atlas$data$sf)
  }
  atlas
}

env$.dk_atlas <- augment(env$.dk_atlas)
env$.aseg_atlas <- augment(env$.aseg_atlas)
env$.tracula_atlas <- augment(env$.tracula_atlas)

save(
  list = ls(env, all.names = TRUE),
  file = "R/sysdata.rda",
  envir = env,
  compress = "xz"
)

cli::cli_alert_success(
  "Augmented .dk_atlas, .aseg_atlas, .tracula_atlas with polygons slot."
)
