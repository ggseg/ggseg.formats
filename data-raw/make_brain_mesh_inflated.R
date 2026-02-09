# Generate brain_mesh_inflated for ggseg.formats sysdata.rda
#
# Extracts the inflated surface from ggseg3d's brain_meshes and saves it
# alongside existing sysdata objects (brain_pals).
#
# Run with: source("data-raw/make_brain_mesh_inflated.R")

ggseg3d_sysdata <- new.env()
load(
  file.path("..", "ggseg3d", "R", "sysdata.rda"),
  envir = ggseg3d_sysdata
)

brain_mesh_inflated <- list(
  lh = ggseg3d_sysdata$brain_meshes[["lh_inflated"]],
  rh = ggseg3d_sysdata$brain_meshes[["rh_inflated"]]
)

lh_v <- nrow(brain_mesh_inflated$lh$vertices)
lh_f <- nrow(brain_mesh_inflated$lh$faces)
rh_v <- nrow(brain_mesh_inflated$rh$vertices)
rh_f <- nrow(brain_mesh_inflated$rh$faces)
cli::cli_alert_info("lh: {lh_v}v, {lh_f}f")
cli::cli_alert_info("rh: {rh_v}v, {rh_f}f")

load("R/sysdata.rda")

usethis::use_data(
  brain_pals,
  brain_mesh_inflated,
  internal = TRUE,
  overwrite = TRUE,
  compress = "xz"
)

cli::cli_alert_success("Saved brain_mesh_inflated to R/sysdata.rda")
