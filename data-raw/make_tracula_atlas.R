# Create TRACULA (TRActs Constrained by UnderLying Anatomy) Atlas
#
# Generates a tract atlas from FreeSurfer's TRACULA training data in MNI space.
# This provides major white matter bundles for 3D visualization.
#
# Requirements:
#   - FreeSurfer installed with trctrain data
#   - ggsegExtra package
#
# Run with: source("data-raw/make_tracula_atlas.R")

library(dplyr)
library(ggsegExtra)
library(ggseg.formats)

future::plan(future::multisession(workers = 4))
progressr::handlers("cli")
progressr::handlers(global = TRUE)

source("data-raw/tracula_metadata.R")

fs_dir <- freesurfer::fs_dir()
tract_dir <- file.path(fs_dir, "trctrain", "hcp", "mgh_1017", "mni")

if (!dir.exists(tract_dir)) {
  cli::cli_abort(c(
    "TRACULA training data not found",
    "i" = "Expected: {.path {tract_dir}}",
    "i" = "Ensure FreeSurfer is installed with trctrain data"
  ))
}

tract_files <- list.files(tract_dir, pattern = "\\.trk$", full.names = TRUE)
aseg_file <- file.path(tract_dir, "aparc+aseg.nii.gz")

if (!file.exists(aseg_file)) {
  cli::cli_warn(c(
    "aparc+aseg.nii.gz not found, creating 3D-only atlas",
    "i" = "Expected: {.path {aseg_file}}"
  ))
  aseg_file <- NULL
}

cli::cli_h1("Creating TRACULA atlas from {length(tract_files)} tracts")
cli::cli_alert_info("Source: {.path {tract_dir}}")

tracula_raw <- create_tract_atlas(
  input_tracts = tract_files,
  input_aseg = aseg_file,
  atlas_name = "tracula",
  output_dir = "data-raw",
  tube_radius = 4,
  tube_segments = 6,
  n_points = 100,
  cleanup = FALSE,
  verbose = TRUE
)

cli::cli_h2("Post-processing atlas")

normalize_label <- function(x) {
  x |>
    basename() |>
    tools::file_path_sans_ext()
}

core_with_meta <- tracula_raw$core |>
  mutate(label_key = normalize_label(label)) |>
  left_join(
    tracula_metadata |>
      mutate(label_key = normalize_label(label)) |>
      select(label_key, region_pretty = region, group),
    by = "label_key"
  ) |>
  mutate(region = coalesce(region_pretty, region)) |>
  select(hemi, region, label, group)

cli::cli_alert_info(
  "Tracts with group info: {sum(!is.na(core_with_meta$group))}/{nrow(core_with_meta)}"
)

tracula <- brain_atlas(
  atlas = "tracula",
  type = "tract",
  palette = tracula_raw$palette,
  core = core_with_meta,
  data = tracula_raw$data
)

cli::cli_alert_success("TRACULA atlas created with {nrow(tracula$core)} tracts")
print(tracula)

cat("\nCore sample:\n")
print(head(tracula$core, 10))

cat("\nGroup distribution:\n")
print(table(tracula$core$group, useNA = "ifany"))

usethis::use_data(tracula, overwrite = TRUE, compress = "xz")
cli::cli_alert_success("Saved to data/tracula.rda")
