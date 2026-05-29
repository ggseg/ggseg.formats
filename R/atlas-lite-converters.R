# Top-level atlas-format converters ----

#' Convert a ggseg atlas to the lite (sf-optional) format
#'
#' Ensures the atlas carries a `polygons` slot (derived from `sf` if needed)
#' and drops the `sf` slot. The result renders identically via the
#' `geom_polygon`-based path in ggseg, but no longer depends on the sf class
#' machinery in `$data` — useful for wasm builds and air-gapped installs.
#'
#' To rehydrate sf for geometric operations later, use [as_sf_atlas()].
#'
#' @param atlas A `ggseg_atlas` (or legacy `brain_atlas`) object.
#'
#' @return A `ggseg_atlas` with `$data$polygons` populated and `$data$sf` set
#'   to `NULL`.
#' @export
#' @examples
#' \dontrun{
#' lite <- as_lite_atlas(dk())
#' is.null(lite$data$sf)         # TRUE
#' inherits(lite$data$polygons, "brain_polygons")  # TRUE
#' }
as_lite_atlas <- function(atlas) {
  if (!inherits(atlas, "ggseg_atlas") && !inherits(atlas, "brain_atlas")) {
    cli::cli_abort("{.arg atlas} must be a {.cls ggseg_atlas} object.")
  }

  if (is.null(atlas$data$polygons)) {
    if (is.null(atlas$data$sf)) {
      cli::cli_abort(c(
        "Atlas has no 2D geometry to convert.",
        "i" = "Need either {.field sf} or {.field polygons} in {.code atlas$data}."
      ))
    }
    atlas$data$polygons <- sf_to_polygons(atlas$data$sf)
  }

  atlas$data$sf <- NULL
  atlas
}


#' Rehydrate a ggseg atlas into sf-backed form
#'
#' Inverse of [as_lite_atlas()]. Materialises an sf-class geometry table from
#' the `polygons` slot (using [sfheaders::sf_multipolygon()] under the hood —
#' no system library dependencies for the conversion itself). Use this when
#' you want to run sf operations (buffers, intersections, CRS transforms) on
#' atlas geometry; the underlying sf operations themselves still require a
#' full sf installation.
#'
#' The returned atlas keeps `$data$polygons` populated alongside `$data$sf`.
#'
#' @param atlas A `ggseg_atlas` (or legacy `brain_atlas`) object.
#'
#' @return A `ggseg_atlas` with both `$data$sf` and `$data$polygons` populated.
#' @export
#' @examples
#' \dontrun{
#' library(sf)
#' atlas <- as_sf_atlas(as_lite_atlas(dk()))
#' st_buffer(atlas$data$sf$geometry[[1]], dist = 2)
#' }
as_sf_atlas <- function(atlas) {
  if (!inherits(atlas, "ggseg_atlas") && !inherits(atlas, "brain_atlas")) {
    cli::cli_abort("{.arg atlas} must be a {.cls ggseg_atlas} object.")
  }

  if (is.null(atlas$data$sf)) {
    if (is.null(atlas$data$polygons)) {
      cli::cli_abort(c(
        "Atlas has no 2D geometry to convert.",
        "i" = "Need either {.field sf} or {.field polygons} in {.code atlas$data}."
      ))
    }
    atlas$data$sf <- polygons_to_sf(atlas$data$polygons)
  }

  atlas
}
