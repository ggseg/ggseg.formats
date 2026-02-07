# Create DK (Desikan-Killiany) Atlas
#
# Generates the dk cortical atlas using ggsegExtra from FreeSurfer's
# aparc annotation on fsaverage5.
#
# This is the default cortical parcellation in FreeSurfer with 68 regions
# (34 per hemisphere).
#
# Requirements:
#   - FreeSurfer installed with fsaverage5 subject
#   - ggsegExtra package
#   - Chrome/Chromium for snapshots
#
# Run with: source("data-raw/make_dk_atlas.R")

library(dplyr)
library(ggsegExtra)
devtools::load_all()

options(freesurfer.verbose = FALSE)
future::plan(future::multisession(workers = 4))
progressr::handlers("cli")
progressr::handlers(global = TRUE)

fs_dir <- freesurfer::fs_dir()
subjects_dir <- file.path(fs_dir, "subjects")
fsaverage5_dir <- file.path(subjects_dir, "fsaverage5")

if (!dir.exists(fsaverage5_dir)) {
  cli::cli_abort(c(
    "fsaverage5 not found",
    "i" = "Expected: {.path {fsaverage5_dir}}",
    "i" = "Ensure FreeSurfer is properly installed"
  ))
}

cli::cli_h1("Creating DK cortical atlas")

dk_raw <- create_cortical_atlas(
  annot = "aparc",
  subject = "fsaverage5",
  subjects_dir = subjects_dir,
  atlas_name = "dk",
  output_dir = "data-raw",
  tolerance = 1,
  smoothness = 2,
  skip_existing = TRUE,
  cleanup = FALSE,
  verbose = TRUE
)

cli::cli_h2("Post-processing atlas")

cli::cli_alert_info("Removing medial wall")
dk_raw <- dk_raw |>
  atlas_region_remove("unknown", match_on = "region") |>
  atlas_region_remove("corpuscallosum", match_on = "region")

cli::cli_alert_info("Setting cortex as context")
dk_raw <- dk_raw |>
  atlas_region_contextual("cortex", match_on = "label")

cli::cli_alert_info("Gathering views")
dk_raw <- dk_raw |>
  atlas_view_gather()

cli::cli_h2("Validating atlas")

dk <- dk_raw

cli::cli_alert_success("DK atlas created with {nrow(dk$core)} regions")
print(dk)

cat("\nRegions:\n")
print(sort(unique(dk$core$region)))

cat("\nViews:\n")
if (!is.null(dk$data$sf)) {
  print(table(dk$data$sf$view))
}

usethis::use_data(dk, overwrite = TRUE, compress = "xz")
cli::cli_alert_success("Saved to data/dk.rda")
