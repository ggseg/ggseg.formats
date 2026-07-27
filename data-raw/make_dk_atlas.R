# Create DK (Desikan-Killiany) Atlas
#
# Generates the dk cortical atlas using ggseg.extra from FreeSurfer's
# aparc annotation on fsaverage5.
#
# This is the default cortical parcellation in FreeSurfer with 68 regions
# (34 per hemisphere).
#
# Requirements:
#   - FreeSurfer installed with fsaverage5 subject
#   - ggseg.extra package
#   - Chrome/Chromium for snapshots
#
# Run with: source("data-raw/make_dk_atlas.R")

library(dplyr)
library(ggseg.extra) # nolint
devtools::load_all()

source("data-raw/dk_metadata.R")

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
    "i" = "Expected {.path {fsaverage5_dir}}; ensure FreeSurfer is installed"
  ))
}

annot_files <- file.path(
  fsaverage5_dir,
  "label",
  c("lh.aparc.annot", "rh.aparc.annot")
)

cli::cli_h1("Creating DK cortical atlas")

dk_raw <- create_cortical_from_annotation(
  input_annot = annot_files,
  atlas_name = "dk",
  output_dir = "data-raw",
  skip_existing = FALSE,
  cleanup = FALSE
)

cli::cli_h2("Post-processing atlas data")
dk_raw <- dk_raw |>
  atlas_region_contextual("unknown", "label")

# `create_cortical_from_annotation()` no longer simplifies sf geometry, so trim
# the vertex count here. The `cortex_` outline is excluded to keep the brain
# silhouette crisp (matching the pattern in make_aseg_atlas.R).
cli::cli_alert_info("Smoothing contours")
dk_raw <- dk_raw |>
  atlas_smooth(keep = 0.2, exclude = "cortex_")

cli::cli_h2("Merging metadata")

core_with_meta <- dk_raw$core |>
  left_join(
    select(dk_metadata, region, names, lobe),
    by = "region"
  ) |>
  select(hemi, region, label, names, lobe)

n_with_lobe <- sum(!is.na(core_with_meta$lobe))
n_total <- nrow(core_with_meta)
cli::cli_alert_info(
  "Regions with lobe info: {n_with_lobe}/{n_total}"
)

dk <- ggseg_atlas(
  atlas = dk_raw$atlas,
  type = dk_raw$type,
  palette = dk_raw$palette,
  core = core_with_meta,
  data = dk_raw$data
)

cli::cli_alert_success("DK atlas created with {nrow(dk$core)} regions")
print(dk)

plot(dk)

cat("\nRegions:\n")
print(sort(unique(dk$core$region)))

cat("\nLobes:\n")
print(table(dk$core$lobe))

cat("\nViews:\n")
if (!is.null(dk$data$sf)) {
  print(table(dk$data$sf$view))
}

usethis::use_data(dk, overwrite = TRUE, compress = "xz")
cli::cli_alert_success("Saved to data/dk.rda")
