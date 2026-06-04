# Top-level atlas-format converters ----

#' Convert a ggseg atlas to the sf-optional polygon representation
#'
#' Sets the single `geom` slot to the `brain_polygons` representation,
#' converting from sf if needed. The result renders identically via the
#' `geom_polygon`-based path in ggseg, but no longer depends on the sf class
#' machinery in `$data` — useful for wasm builds and air-gapped installs.
#'
#' Conversion is lossless, so a single representation is kept (no redundant
#' sf alongside polygons). To rehydrate sf for geometric operations later,
#' use [as_sf_atlas()].
#'
#' @param atlas A `ggseg_atlas` (or legacy `brain_atlas`) object.
#'
#' @return A `ggseg_atlas` whose `$data$geom` is a `brain_polygons` object.
#' @export
#' @examples
#' \dontrun{
#' poly <- as_polygon_atlas(dk())
#' is_atlas_polygon(poly) # TRUE
#' }
as_polygon_atlas <- function(atlas) {
  if (!inherits(atlas, "ggseg_atlas") && !inherits(atlas, "brain_atlas")) {
    cli::cli_abort("{.arg atlas} must be a {.cls ggseg_atlas} object.")
  }

  geom <- geom_from_data(atlas$data)
  if (is.null(geom)) {
    cli::cli_abort(c(
      "Atlas has no 2D geometry to convert.",
      "i" = "Need {.field geom} in {.code atlas$data}."
    ))
  }
  if (!inherits(geom, "brain_polygons")) {
    geom <- sf_to_polygons(geom)
  }

  atlas$data$geom <- geom
  atlas$data$sf <- NULL
  atlas$data$polygons <- NULL
  atlas
}


#' Rehydrate a ggseg atlas into sf-backed form
#'
#' Inverse of [as_polygon_atlas()]. Sets the single `geom` slot to an sf-class
#' geometry table, converting from polygons via [sfheaders::sf_multipolygon()]
#' if needed — sfheaders is pure Rcpp with no GDAL/GEOS/PROJ dependencies, so
#' the conversion itself does not require a full sf installation. Use this when
#' you want to run sf operations (buffers, intersections, CRS transforms) on
#' atlas geometry; those sf operations themselves still require sf.
#'
#' Conversion is lossless, so a single representation is kept (no redundant
#' polygons alongside sf).
#'
#' @param atlas A `ggseg_atlas` (or legacy `brain_atlas`) object.
#'
#' @return A `ggseg_atlas` whose `$data$geom` is an sf object.
#' @export
#' @examples
#' \dontrun{
#' library(sf)
#' atlas <- as_sf_atlas(as_polygon_atlas(dk()))
#' st_buffer(atlas_geom(atlas)$geometry[[1]], dist = 2)
#' }
as_sf_atlas <- function(atlas) {
  if (!inherits(atlas, "ggseg_atlas") && !inherits(atlas, "brain_atlas")) {
    cli::cli_abort("{.arg atlas} must be a {.cls ggseg_atlas} object.")
  }

  geom <- geom_from_data(atlas$data)
  if (is.null(geom)) {
    cli::cli_abort(c(
      "Atlas has no 2D geometry to convert.",
      "i" = "Need {.field geom} in {.code atlas$data}."
    ))
  }
  if (inherits(geom, "brain_polygons")) {
    geom <- polygons_to_sf(geom)
  }

  atlas$data$geom <- geom
  atlas$data$sf <- NULL
  atlas$data$polygons <- NULL
  atlas
}
