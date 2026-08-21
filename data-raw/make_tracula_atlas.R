# Create TRACULA (TRActs Constrained by UnderLying Anatomy) Atlas
#
# Generates a tract atlas from FreeSurfer's TRACULA training data in MNI space.
# This provides major white matter bundles for 2D and 3D visualization.
#
# Requirements:
#   - FreeSurfer installed with trctrain data
#   - ggseg.extra package
#
# Run with: source("data-raw/make_tracula_atlas.R")
#
# Set TRACULA_REBUILD to any non-empty value to discard the cached projection
# artefacts. Step 1 (streamline reading and tube meshes) is slab-independent
# and always reused; everything downstream of it depends on `tract_slabs`, so
# changing a slab position without clearing the cache silently reuses the old
# geometry.

library(dplyr)
library(ggseg.extra) # nolint
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
    "i" = "Expected {.path {tract_dir}}; needs FreeSurfer trctrain data"
  ))
}

tract_files <- list.files(tract_dir, pattern = "\\.trk$", full.names = TRUE)
aseg_file <- file.path(tract_dir, "aparc+aseg.nii.gz")

if (!file.exists(aseg_file)) {
  cli::cli_abort(c(
    "aparc+aseg.nii.gz not found",
    "i" = "Expected: {.path {aseg_file}}; needed for the 2D cortex outlines"
  ))
}

# ── Projection slabs at fixed anatomical positions ───────────────────────
# Slice positions are given in RAS millimetres so they are anatomically
# meaningful and independent of the template's voxel grid, and each slab spans
# +/- slab_halfwidth slices around its midpoint. Positions were chosen from
# where the 42 tracts actually are: the superior axial cut crosses the SLF
# branches and the callosal body, the middle one the thalamic radiations and
# the forceps, the inferior one the uncinate, ILF and extreme capsule; the
# coronal cut catches the corticospinal tract and fornix at the internal
# capsule; the midline sagittal cut carries all eight callosal segments plus
# the anterior commissure and MCP, and the two lateral sagittal cuts slice the
# association bundles along their length rather than across it.
slab_halfwidth <- 8L
slice_mm <- data.frame(
  name = c(
    "superior_axial",
    "mid_axial",
    "inferior_axial",
    "coronal",
    "sagittal_left",
    "sagittal_mid",
    "sagittal_right"
  ),
  type = c("axial", "axial", "axial", "coronal", rep("sagittal", 3)),
  mm = c(34, 10, -16, -20, -36, 0, 36),
  stringsAsFactors = FALSE
)

# RAS millimetres -> index along the corresponding axis of the RAS+ reoriented
# volume. Derived from the template's own affine rather than hard-coded, so it
# stays correct if the reference volume changes.
ras_mm_to_index <- function(vox2ras, dims, ras_axis, mm) {
  native_axis <- which.max(abs(vox2ras[ras_axis, 1:3]))
  scale <- vox2ras[ras_axis, native_axis]
  native <- (mm - vox2ras[ras_axis, 4]) / scale
  index <- if (scale > 0) native else dims[native_axis] - 1 - native
  as.integer(round(index)) + 1L
}

aseg_img <- RNifti::readNifti(aseg_file, internal = TRUE)
aseg_vox2ras <- RNifti::xform(aseg_img)
aseg_dims <- dim(aseg_img)
ras_axis <- c(axial = 3L, coronal = 2L, sagittal = 1L)

slice_mm$mid <- mapply(
  function(type, mm) {
    ras_mm_to_index(aseg_vox2ras, aseg_dims, ras_axis[[type]], mm)
  },
  slice_mm$type,
  slice_mm$mm
)

tract_slabs <- data.frame(
  name = slice_mm$name,
  type = slice_mm$type,
  start = slice_mm$mid - slab_halfwidth,
  end = slice_mm$mid + slab_halfwidth,
  stringsAsFactors = FALSE
)
print(tract_slabs)

cli::cli_h1("Creating TRACULA tract atlas")

# Everything from the projection step onward is slab-dependent. Step 1 is not,
# and is by far the slowest part, so it survives a rebuild.
rebuild <- !identical(Sys.getenv("TRACULA_REBUILD", ""), "")
if (rebuild) {
  cache <- file.path("data-raw", "tracula")
  keep <- file.path(cache, "step1_data.rds")
  stale <- setdiff(
    list.files(cache, full.names = TRUE, include.dirs = TRUE),
    keep
  )
  unlink(stale, recursive = TRUE)
}

tracula_raw <- create_tract_from_tractography(
  input_tracts = tract_files,
  input_aseg = aseg_file,
  atlas_name = "tracula",
  output_dir = "data-raw",
  slabs = tract_slabs,
  tube_radius = 3,
  tube_segments = 6,
  n_points = 100,
  cleanup = FALSE,
  skip_existing = !rebuild,
  verbose = TRUE
)

cli::cli_h2("Post-processing atlas")

core_with_meta <- tracula_raw$core |>
  rename(region_raw = region) |>
  left_join(
    select(tracula_metadata, label, region, names, group),
    by = "label"
  ) |>
  mutate(region = coalesce(region, region_raw)) |>
  select(hemi, region, label, names, group)

n_with_group <- sum(!is.na(core_with_meta$group))
n_total <- nrow(core_with_meta)
cli::cli_alert_info(
  "Tracts with group info: {n_with_group}/{n_total}"
)

tracula <- ggseg_atlas(
  atlas = "tracula",
  type = "tract",
  palette = tracula_raw$palette,
  core = core_with_meta,
  data = tracula_raw$data
)

# Cache the unsmoothed atlas so smoothing can be retuned without rebuilding.
saveRDS(tracula, file.path("data-raw", "tracula_unsmoothed.rds"))

# ── Smooth and simplify ──────────────────────────────────────────────────
# Post-hoc, so retuning never means rerunning the pipeline. Smooth first, then
# simplify: smoothing interpolates vertices, so simplifying first would just
# have its saving undone.
#
# The two structures want different smoothing. Tracts are solid centerline
# tubes with no holes to lose, so morphological closing rounds them freely.
# The cortex is a thin ribbon whose sulci are enclosed holes, and closing
# fills any hole narrower than the smoothing distance -- so it gets
# "ksmooth", which low-pass filters the outline without dilating it.
# Volumetric projection leaves stray specks detached from their tract; those
# are dropped first. The cortex is spared: a thin ribbon's gyral
# cross-sections are legitimately small pieces, not specks.
cli::cli_alert_info("Cleaning up geometries")

tracula <- tracula |>
  atlas_view_remove_small(
    min_area = 20,
    scope = "piece",
    exclude = "^cortex"
  ) |>
  atlas_smooth(
    keep = 1,
    smoothness = 0.8,
    method = "close",
    exclude = "^cortex"
  ) |>
  atlas_smooth(
    keep = 1,
    smoothness = 0.6,
    method = "ksmooth",
    labels = "^cortex"
  ) |>
  atlas_smooth(keep = 0.2, labels = "^cortex") |>
  atlas_smooth(keep = 0.2, exclude = "^cortex")

# The cortex silhouette carries ~90% of the atlas's vertices -- it is a
# convoluted ribbon drawn across seven views, against 42 smooth tubes -- so its
# `keep` sets the shipped size almost single-handedly. 0.2 is where the gyral
# detail stops changing visibly: it is indistinguishable from 0.4 at any
# plotting size while halving the atlas, and unlike 0.1 it still holds up
# zoomed in.

# ── Choose which tracts each view draws ──────────────────────────────────
# A slab catches a passing tract in cross-section as readily as along its
# length, so most tracts leave a sliver in most views -- which leaves every
# panel cluttered and every tract drawn several times over. This replaces the
# hand-curated per-view removals earlier releases carried.
tracula <- atlas_view_select(tracula, threshold = 0.3)

# Ordering repositions the panels, so it runs last: atlas_view_select() drops
# regions from views and changes each panel's extent, and packing against the
# final extents is what keeps the gaps even. Panels then read superior ->
# inferior, then the other planes.
tracula <- atlas_view_reorder(tracula, slice_mm$name)

plot(tracula)

cli::cli_alert_success("TRACULA atlas created with {nrow(tracula$core)} tracts")
print(tracula)

cat("\nCore sample:\n")
print(head(tracula$core, 10))

cat("\nGroup distribution:\n")
print(table(tracula$core$group, useNA = "ifany"))

cat("\nViews:\n")
print(atlas_views(tracula))

usethis::use_data(tracula, overwrite = TRUE, compress = "xz")
cli::cli_alert_success("Saved to data/tracula.rda")
