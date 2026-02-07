# Create TRACULA (TRActs Constrained by UnderLying Anatomy) Atlas
#
# Generates a tract atlas from FreeSurfer's TRACULA training data in MNI space.
# This provides major white matter bundles for 2D and 3D visualization.
#
# Requirements:
#   - FreeSurfer installed with trctrain data
#   - ggsegExtra package
#
# Run with: source("data-raw/make_tracula_atlas.R")

library(dplyr)
library(ggsegExtra)
library(ggseg)
devtools::load_all()

source("data-raw/tracula_metadata.R")

options(freesurfer.verbose = FALSE)
future::plan(future::multisession(workers = 4))
progressr::handlers("cli")
progressr::handlers(global = TRUE)

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

cli::cli_h1("Creating TRACULA tract atlas")

tracula_raw <- create_tract_atlas(
  input_tracts = tract_files,
  input_aseg = aseg_file,
  atlas_name = "tracula",
  output_dir = "data-raw",
  tube_radius = 3,
  tube_segments = 6,
  n_points = 100,
  cleanup = FALSE,
  steps = 7,
  skip_existing = TRUE,
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


cli::cli_alert_info("Cleaning up geometries")

tracula <- tracula |>
  atlas_view_keep(c("axial_2", "axial_4", "coronal_3", "coronal_4", "sagittal"))

ggplot2::ggplot() +
  ggseg::geom_brain(
    atlas = tracula,
    ggplot2::aes(fill = label),
    position = ggseg::position_brain(ncol = 4),
    show.legend = FALSE,
    alpha = .7
  ) +
  ggplot2::scale_fill_manual(values = tracula$palette)


cli::cli_alert_success("TRACULA atlas created with {nrow(tracula$core)} tracts")
print(tracula)

cat("\nCore sample:\n")
print(head(tracula$core, 10))

cat("\nGroup distribution:\n")
print(table(tracula$core$group, useNA = "ifany"))

cat("\nViews:\n")
if (!is.null(tracula$data$sf)) {
  print(table(tracula$data$sf$view))
}

usethis::use_data(tracula, overwrite = TRUE, compress = "xz")
cli::cli_alert_success("Saved to data/tracula.rda")
