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
    "i" = "Expected: {.path {fsaverage5_dir}}",
    "i" = "Ensure FreeSurfer is properly installed"
  ))
}

annot_files <- file.path(
  fsaverage5_dir, "label",
  c("lh.aparc.annot", "rh.aparc.annot")
)

cli::cli_h1("Creating DK cortical atlas")

dk_raw <- create_cortical_atlas(
  input_annot = annot_files,
  atlas_name = "dk",
  output_dir = "data-raw",
  tolerance = 1,
  smoothness = 2,
  skip_existing = TRUE,
  cleanup = FALSE,
  verbose = TRUE
)

cli::cli_h2("Post-processing atlas")

cli::cli_alert_info("Setting cortex as context")
dk_raw <- dk_raw |>
  atlas_region_contextual("cortex", match_on = "label") |>
  atlas_region_contextual("unknown", match_on = "label") |>
  atlas_region_contextual("corpuscallosum", match_on = "label")

cli::cli_alert_info("Gathering views")
dk_raw <- dk_raw |>
  atlas_view_gather()

cli::cli_h2("Merging metadata")

core_with_meta <- dk_raw$core |>
  left_join(
    dk_metadata |> select(region, region_pretty, lobe),
    by = "region"
  ) |>
  mutate(region = coalesce(region_pretty, region)) |>
  select(hemi, region, label, lobe)

cli::cli_alert_info(
  "Regions with lobe info: {sum(!is.na(core_with_meta$lobe))}/{nrow(core_with_meta)}"
)

dk <- brain_atlas(
  atlas = dk_raw$atlas,
  type = dk_raw$type,
  palette = dk_raw$palette,
  core = core_with_meta,
  data = dk_raw$data
)

cli::cli_alert_success("DK atlas created with {nrow(dk$core)} regions")
print(dk)

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
