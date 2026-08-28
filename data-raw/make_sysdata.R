# Consolidate all internal data into R/sysdata.rda
#
# Combines brain meshes and atlas objects into a single internal data file.
#
# Every object already in R/sysdata.rda is carried over, and only the atlases
# with a freshly built data/<name>.rda are replaced. That means one atlas can
# be rebuilt without redoing the others, and objects this script does not know
# about -- .suit_atlas, which data-raw/make_suit_atlas.R imports from
# ggsegSUIT rather than building here -- survive the round trip instead of
# being silently dropped.
#
# Prerequisites:
#   - at least one of data/dk.rda, data/aseg.rda, data/tracula.rda, built by
#     the matching make_*_atlas.R script
#   - data-raw/make_brain_mesh_inflated.R must have been run
#   - data-raw/make_cerebellar_mesh.R must have been run
#
# Run with: source("data-raw/make_sysdata.R")

devtools::load_all()

sysdata <- new.env()
load("R/sysdata.rda", envir = sysdata)

atlases <- c(dk = ".dk_atlas", aseg = ".aseg_atlas", tracula = ".tracula_atlas")

rebuilt <- character()
for (nm in names(atlases)) {
  rda <- file.path("data", paste0(nm, ".rda"))
  if (!file.exists(rda)) {
    cli::cli_alert_info("No {.file {rda}}; keeping {.val {atlases[[nm]]}}.")
    next
  }
  env <- new.env()
  load(rda, envir = env)
  # Ship the bundled atlases in the polygon format so they install and plot
  # without sf. The conversion is lossless; see refresh_sysdata_polygons.R.
  assign(atlases[[nm]], as_polygon_atlas(env[[nm]]), envir = sysdata)
  rebuilt <- c(rebuilt, atlases[[nm]])
  cli::cli_alert_success("Rebuilt {.val {atlases[[nm]]}} from {.file {rda}}.")
}

if (length(rebuilt) == 0) {
  cli::cli_abort(
    "Nothing to rebuild: no atlas {.file .rda} found in {.path data}."
  )
}

objects <- ls(sysdata, all.names = TRUE)
save(
  list = objects,
  file = "R/sysdata.rda",
  envir = sysdata,
  compress = "xz",
  version = 2
)

unlink("data", recursive = TRUE)

cli::cli_alert_success("Saved {.val {objects}} to {.file R/sysdata.rda}.")
