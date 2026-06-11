# Atlas migration helper for downstream maintainers ----

#' Migrate atlas `.rda` files to the sf-optional polygon format
#'
#' Walks a directory of `.rda` files, finds every `ggseg_atlas` object inside
#' them, and rewrites their 2D geometry into the single `geom` slot. By default
#' the geometry is stored as `brain_polygons` (sf-optional); any legacy `sf` /
#' `polygons` slots are dropped. Pass `keep_sf = TRUE` to store the geometry as
#' sf instead.
#'
#' Intended for downstream atlas-package maintainers across the ggsegverse
#' ecosystem: run once against your `data/` directory, then drop `sf` from
#' DESCRIPTION Imports.
#'
#' @param path Directory containing `.rda` files to migrate. Defaults to
#'   `"data"`, the conventional location in R packages.
#' @param keep_sf If `TRUE`, the geometry is stored in `geom` as sf. Default
#'   `FALSE` — the geometry is stored as `brain_polygons` (sf-optional).
#' @param quiet If `TRUE`, suppress per-file status messages.
#'
#' @return Invisibly, a character vector of paths to the files that were
#'   rewritten.
#' @export
#' @examples
#' \dontrun{
#' # In an atlas package, from the package root:
#' ggseg.formats::migrate_atlas_files("data")
#' }
migrate_atlas_files <- function(path = "data", keep_sf = FALSE, quiet = FALSE) {
  if (!dir.exists(path)) {
    cli::cli_abort("Directory {.path {path}} does not exist.")
  }

  rda_files <- list.files(path, pattern = "\\.rda$", full.names = TRUE)
  if (length(rda_files) == 0) {
    if (!quiet) {
      cli::cli_warn("No {.code .rda} files found in {.path {path}}.")
    }
    return(invisible(character()))
  }

  migrated <- character()
  for (f in rda_files) {
    if (migrate_rda_file(f, keep_sf)) {
      migrated <- c(migrated, f)
      if (!quiet) {
        cli::cli_alert_success("Migrated {.file {basename(f)}}.")
      }
    } else if (!quiet) {
      cli::cli_alert_info(
        "Skipped {.file {basename(f)}} (nothing to migrate)."
      )
    }
  }

  invisible(migrated)
}


#' Geometry representation a migration should write
#'
#' `keep_sf` stores sf; otherwise `brain_polygons`. Geometry already in the
#' target representation is returned unchanged.
#' @noRd
#' @keywords internal
migration_target_geom <- function(geom, keep_sf) {
  if (keep_sf) {
    if (inherits(geom, "brain_polygons")) polygons_to_sf(geom) else geom
  } else {
    if (inherits(geom, "sf")) sf_to_polygons(geom) else geom
  }
}


#' Migrate one loaded object to the single `geom` slot
#'
#' Returns the rewritten object, or `NULL` when the object is not a migratable
#' atlas, has no 2D geometry, or is already in the target form.
#' @noRd
#' @keywords internal
migrate_atlas_object <- function(obj, keep_sf) {
  if (!is_atlas_for_migration(obj)) {
    return(NULL)
  }
  geom <- geom_from_data(obj$data)
  if (is.null(geom)) {
    return(NULL)
  }
  target <- migration_target_geom(geom, keep_sf)
  already_migrated <- identical(obj$data$geom, target) &&
    is.null(obj$data$sf) &&
    is.null(obj$data$polygons)
  if (already_migrated) {
    return(NULL)
  }
  obj$data$geom <- target
  obj$data$sf <- NULL
  obj$data$polygons <- NULL
  obj
}


#' Migrate every atlas object in one `.rda` file in place
#'
#' Returns `TRUE` if the file was rewritten, `FALSE` if nothing changed.
#' @noRd
#' @keywords internal
migrate_rda_file <- function(f, keep_sf) {
  env <- new.env(parent = emptyenv())
  nms <- load(f, envir = env)
  changed <- FALSE
  for (nm in nms) {
    migrated <- migrate_atlas_object(env[[nm]], keep_sf)
    if (!is.null(migrated)) {
      env[[nm]] <- migrated
      changed <- TRUE
    }
  }
  if (changed) {
    save(list = nms, file = f, envir = env, compress = "xz")
  }
  changed
}


#' Lightweight class check used by migrate_atlas_files()
#'
#' Avoids the structural revalidation in [is_ggseg_atlas()] so that legacy
#' cached objects can be migrated even if their layout has drifted.
#' @noRd
#' @keywords internal
is_atlas_for_migration <- function(x) {
  is_atlas_class(x) &&
    is.list(x) &&
    !is.null(x$data) &&
    is.list(x$data)
}
