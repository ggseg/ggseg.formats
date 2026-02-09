# Create ASEG (Automatic Subcortical Segmentation) Atlas
#
# Generates the aseg subcortical atlas using ggsegExtra from FreeSurfer's
# aseg.mgz volume on fsaverage5.
#
# Uses projection-based 2D views (6 views) to show subcortical structures
# in their spatial relationships with reduced overlap.
#
# Requirements:
#   - FreeSurfer installed with fsaverage5 subject
#   - ggsegExtra package
#   - Chrome/Chromium for snapshots
#
# Run with: source("data-raw/make_aseg_atlas.R")

library(dplyr)
library(ggsegExtra)
library(ggseg)
devtools::load_all()
options(freesurfer.verbose = FALSE)
future::plan(future::multisession(workers = 4))
progressr::handlers("cli")
progressr::handlers(global = TRUE)

# Load metadata
source("data-raw/aseg_metadata.R")

# Setup paths
fs_dir <- freesurfer::fs_dir()
subjects_dir <- file.path(fs_dir, "subjects")

aseg_volume <- file.path(subjects_dir, "fsaverage5", "mri", "aseg.mgz")
color_lut <- file.path(fs_dir, "ASegStatsLUT.txt")

# Verify files exist
if (!file.exists(aseg_volume)) {
  cli::cli_abort("aseg.mgz not found at {.path {aseg_volume}}")
}
if (!file.exists(color_lut)) {
  color_lut <- file.path(fs_dir, "FreeSurferColorLUT.txt")
}

# Create atlas using ggsegExtra with projection-based views
# Default uses 6 views focused on subcortical range:
#   - axial_inferior, axial_superior
#   - coronal_posterior, coronal_anterior
#   - sagittal_left, sagittal_right
aseg_raw <- create_subcortical_atlas(
  input_volume = aseg_volume,
  input_lut = color_lut,
  atlas_name = "aseg",
  output_dir = "data-raw/",
  tolerance = 1,
  smoothness = 2,
  steps = 1:9,
  skip_existing = TRUE,
  cleanup = FALSE,
  verbose = TRUE
)

cli::cli_h2("Post-processing atlas")

cli::cli_alert_info("Remove white matter")
aseg_raw <- aseg_raw |>
  atlas_region_remove("White-Matter", match_on = "label") |>
  atlas_region_remove("WM-hypointensities", match_on = "label") |>
  atlas_region_remove("-Ventricle", match_on = "label") |>
  atlas_region_remove("-Vent$", match_on = "label") |>
  atlas_region_remove("CSF", match_on = "label") |>
  atlas_region_remove("Cerebral-Cortex", match_on = "label")

cli::cli_alert_info("Set cortex as context")
aseg_raw <- aseg_raw |>
  atlas_region_contextual("Cortex", match_on = "label")

cli::cli_alert_info("Selecting views")
aseg_raw <- aseg_raw |>
  atlas_view_keep("axial_3|axial_5|coronal_2|coronal_3|coronal_4|sagittal")


cli::cli_alert_info("Cleaning up view positions")
aseg_raw <- aseg_raw |>
  atlas_view_gather()

cli::cli_h2("Merging metadata")

# Create lookup for region name from label
# Need to normalize region names for matching
normalize_region <- function(x) {
  ifelse(
    is.na(x),
    NA_character_,
    x |>
      tolower() |>
      gsub("-", " ", x = _) |>
      gsub("_", " ", x = _) |>
      gsub("left |right ", "", x = _) |>
      trimws()
  )
}

core_with_meta <- aseg_raw$core |>
  mutate(
    region_key = normalize_region(region)
  ) |>
  left_join(
    aseg_metadata |>
      mutate(region_key = normalize_region(region)) |>
      select(region_key, label_pretty, structure),
    by = "region_key"
  ) |>
  mutate(
    region = coalesce(label_pretty, region)
  ) |>
  select(hemi, region, label, structure)

n_with_structure <- sum(!is.na(core_with_meta$structure))
n_total <- nrow(core_with_meta)
cli::cli_alert_info(
  "Regions with structure info: {n_with_structure}/{n_total}"
)

# Rebuild atlas with enriched core
aseg <- ggseg_atlas(
  atlas = aseg_raw$atlas,
  type = aseg_raw$type,
  palette = aseg_raw$palette,
  core = core_with_meta,
  data = aseg_raw$data
)


cli::cli_alert_success("ASEG atlas created with {nrow(aseg$core)} regions")
print(aseg)

# Preview
atlas_labels(aseg)

ggplot2::ggplot() +
  geom_brain(
    atlas = aseg,
    ggplot2::aes(fill = label),
    position = position_brain(ncol = 3),
    show.legend = FALSE,
    alpha = .7
  ) +
  ggplot2::scale_fill_manual(values = aseg$palette)

# Save
usethis::use_data(aseg, overwrite = TRUE, compress = "xz")
cli::cli_alert_success("Saved to data/aseg.rda")
