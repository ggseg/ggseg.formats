# Atlas migration helper for downstream maintainers ----

#' Migrate atlas `.rda` files to the lite (sf-optional) format
#'
#' Walks a directory of `.rda` files, finds every `ggseg_atlas` object inside
#' them, derives the `polygons` slot from `sf` via [sf_to_polygons()], and
#' rewrites the `.rda`. By default this is a true "go lite" migration that
#' drops the `sf` slot; pass `keep_sf = TRUE` to retain it alongside polygons.
#'
#' Intended for downstream atlas-package maintainers across the ggsegverse
#' ecosystem: run once against your `data/` directory, then drop `sf` from
#' DESCRIPTION Imports.
#'
#' @param path Directory containing `.rda` files to migrate. Defaults to
#'   `"data"`, the conventional location in R packages.
#' @param keep_sf If `TRUE`, the `sf` slot is preserved alongside the new
#'   `polygons` slot (additive). Default `FALSE` — the migration is "go lite".
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
    env <- new.env(parent = emptyenv())
    nms <- load(f, envir = env)
    changed <- FALSE

    for (nm in nms) {
      obj <- env[[nm]]
      if (!is_ggseg_atlas_lite(obj)) {
        next
      }
      if (is.null(obj$data$sf)) {
        next
      }
      if (is.null(obj$data$polygons)) {
        obj$data$polygons <- sf_to_polygons(obj$data$sf)
      }
      if (!keep_sf) {
        obj$data$sf <- NULL
      }
      env[[nm]] <- obj
      changed <- TRUE
    }

    if (changed) {
      save(list = nms, file = f, envir = env, compress = "xz")
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


#' Lightweight class check used by migrate_atlas_files()
#'
#' Avoids the structural revalidation in [is_ggseg_atlas()] so that legacy
#' cached objects can be migrated even if their layout has drifted.
#' @noRd
#' @keywords internal
is_ggseg_atlas_lite <- function(x) {
  (inherits(x, "ggseg_atlas") || inherits(x, "brain_atlas")) &&
    is.list(x) &&
    !is.null(x$data) &&
    is.list(x$data)
}
