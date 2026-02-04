# Create unified brain atlases from legacy formats
#
# Converts legacy ggseg (2D) and ggseg3d (3D) atlases to the new
# unified brain_atlas format.
#
# Run with: source("data-raw/make_unified_atlases.R")

library(dplyr)

# Load legacy atlases from installed packages
dk_2d <- ggseg.formats::dk
dk_3d <- ggseg3d::dk_3d
aseg_2d <- ggseg.formats::aseg
aseg_3d <- ggseg3d::aseg_3d

# Convert dk atlas (cortical) ----
cli::cli_h1("Converting dk atlas")

dk <- ggsegExtra::unify_legacy_atlases(
  atlas_2d = dk_2d,
  atlas_3d = dk_3d,
  atlas_name = "dk",
  type = "cortical"
)

cli::cli_alert_success("dk atlas created: {nrow(dk$core)} regions")

# Convert aseg atlas (subcortical) ----
cli::cli_h1("Converting aseg atlas")

aseg <- ggsegExtra::unify_legacy_atlases(
  atlas_2d = aseg_2d,
  atlas_3d = aseg_3d,
  atlas_name = "aseg",
  type = "subcortical"
)

cli::cli_alert_success("aseg atlas created: {nrow(aseg$core)} regions")

# Save atlases ----
usethis::use_data(
  dk,
  aseg,
  overwrite = TRUE,
  compress = "xz"
)

cli::cli_alert_success("Atlases saved to data/")
