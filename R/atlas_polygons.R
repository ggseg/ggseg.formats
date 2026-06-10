#' @export
print.brain_polygons <- function(x, ...) {
  cli::cli_h2("brain_polygons")
  cli::cli_text("{.strong Labels:} {nrow(x)}")
  if (nrow(x) > 0) {
    # nolint start: object_usage_linter
    views <- unique(unlist(lapply(x$geometry, function(g) unique(g$view))))
    n_pts <- sum(vapply(x$geometry, nrow, integer(1)))
    # nolint end
    cli::cli_text("{.strong Views:} {paste(views, collapse = ', ')}")
    cli::cli_text("{.strong Total points:} {n_pts}")
  }
  NextMethod()
  invisible(x)
}
# sf-optional atlas polygon format ----

#' Convert an sf atlas geometry to the sf-optional polygon format
#'
#' Extracts coordinates from an sf-backed atlas geometry table and returns a
#' nested data.frame keyed by `label`. Each row carries a `geometry` list-column
#' containing the per-view, per-ring point coordinates needed to render with
#' [graphics::polypath()] (using the `subgroup` ring index for holes).
#'
#' @param sf_data An sf-class data.frame with columns `label`, `view`,
#'   `geometry` (sfc of MULTIPOLYGON).
#'
#' @return A data.frame with one row per `label` and a `geometry` list-column.
#'   Each nested element is a data.frame with columns `view`, `x`, `y`,
#'   `group` (disjoint polygon piece within a label/view), `subgroup`
#'   (ring within a piece; first = exterior, rest = holes).
#'
#' Internal conversion primitive. For the atlas-level public API use
#' [as_polygon_atlas()] / [atlas_polygons()].
#' @keywords internal
#' @rdname sf_to_polygons
sf_to_polygons <- function(sf_data) {
  require_sf("sf_to_polygons()")
  if (!inherits(sf_data, "sf")) {
    cli::cli_abort("{.arg sf_data} must inherit from class {.cls sf}.")
  }
  required <- c("label", "view", "geometry")
  miss <- setdiff(required, names(sf_data))
  if (length(miss)) {
    cli::cli_abort("{.arg sf_data} missing columns: {.field {miss}}.")
  }

  per_row <- lapply(seq_len(nrow(sf_data)), function(i) {
    geom <- sf_data$geometry[[i]]
    co <- sf::st_coordinates(geom)
    as_tbl(data.frame(
      label = unname(sf_data$label[i]),
      view = unname(sf_data$view[i]),
      x = unname(co[, "X"]),
      y = unname(co[, "Y"]),
      group = as.integer(co[, "L2"]),
      subgroup = as.integer(co[, "L1"])
    ))
  })

  combined <- df_bind_rows(per_row)
  out <- df_nest(combined, "label", "geometry")
  structure(out, class = c("brain_polygons", class(out)))
}


#' Convert sf-optional polygons to an sf data frame
#'
#' Inverse of [sf_to_polygons()]. Uses [sfheaders::sf_multipolygon()] to build
#' MULTIPOLYGON geometries — sfheaders is pure Rcpp and has no GDAL/GEOS/PROJ
#' system dependencies, so the conversion itself does not require a full sf
#' installation. The returned object is an sf-class data frame, which downstream
#' users would manipulate using sf.
#'
#' @param polygons A `brain_polygons` data.frame produced by
#'   [sf_to_polygons()] or constructed directly: one row per `label`, with a
#'   `geometry` list-column
#'   of data.frames containing `view`, `x`, `y`, `group`, `subgroup`.
#'
#' @return An sf-class data frame with columns `label`, `view`, `geometry`
#'   (one row per label×view, geometry is MULTIPOLYGON).
#'
#' Internal conversion primitive. For the atlas-level public API use
#' [as_sf_atlas()] / [atlas_sf()].
#' @keywords internal
#' @rdname polygons_to_sf
polygons_to_sf <- function(polygons) {
  validate_polygons(polygons)

  flat <- df_unnest(polygons, "geometry")

  feature_key <- paste(flat$label, flat$view, sep = "\x1f")
  flat$.feature_id <- as.integer(factor(
    feature_key,
    levels = unique(feature_key)
  ))

  out <- sfheaders::sf_multipolygon(
    as.data.frame(flat),
    x = "x",
    y = "y",
    multipolygon_id = ".feature_id",
    polygon_id = "group",
    linestring_id = "subgroup",
    keep = TRUE
  )

  out$.feature_id <- NULL

  cols <- c("label", "view", "geometry")
  out <- out[, cols, drop = FALSE]
  out
}


#' Validate a brain_polygons object
#'
#' @param polygons object to validate
#' @return validated polygons (as data.frame)
#' @keywords internal
#' @noRd
validate_polygons <- function(polygons) {
  if (!is.data.frame(polygons)) {
    cli::cli_abort("{.arg polygons} must be a data.frame.")
  }

  required <- c("label", "geometry")
  miss <- setdiff(required, names(polygons))
  if (length(miss)) {
    cli::cli_abort("{.arg polygons} missing columns: {.field {miss}}.")
  }

  if (!is.list(polygons$geometry)) {
    cli::cli_abort("{.field geometry} column must be a list-column.")
  }

  dup_mask <- duplicated(polygons$label)
  if (any(dup_mask)) {
    cli::cli_abort(c(
      "{.arg polygons} must have one row per {.field label}.",
      "i" = "Duplicated: {.val {unique(polygons$label[dup_mask])}}."
    ))
  }

  validate_polygon_geoms(polygons)

  out <- as_tbl(polygons)
  if (!inherits(out, "brain_polygons")) {
    out <- structure(out, class = c("brain_polygons", class(out)))
  }
  out
}


#' Validate a 2D geometry object (sf or brain_polygons)
#'
#' @param geom an sf or `brain_polygons` object
#' @return the validated geometry
#' @keywords internal
#' @noRd
validate_geom <- function(geom) {
  if (inherits(geom, "sf")) {
    return(validate_sf(geom))
  }
  if (inherits(geom, "brain_polygons")) {
    return(validate_polygons(geom))
  }
  cli::cli_abort(
    "{.arg geom} must be an {.cls sf} or {.cls brain_polygons} object,
     not {.cls {class(geom)[1]}}."
  )
}


#' Resolve the geom slot from `geom` plus a deprecated `sf` dot
#'
#' Constructors now take a single `geom`. The released `sf` argument, passed
#' through `...`, is captured here: it is converted to the polygon
#' representation via [sf_to_polygons()] and a deprecation warning is issued.
#'
#' @keywords internal
#' @noRd
resolve_geom <- function(geom = NULL, ..., .fn) {
  dots <- list(...)
  if (!is.null(geom) && !is.null(dots$sf)) {
    cli::cli_warn(
      "Both {.arg geom} and {.arg sf} supplied; ignoring {.arg sf}."
    )
  }
  if (is.null(geom) && !is.null(dots$sf)) {
    lifecycle::deprecate_warn(
      "0.0.2.9001",
      sprintf("%s(sf)", .fn),
      sprintf("%s(geom)", .fn),
      details = "sf input is converted to polygons via `sf_to_polygons()`."
    )
    geom <- sf_to_polygons(validate_sf(dots$sf))
  }
  if (is.null(geom)) {
    return(NULL)
  }
  validate_geom(geom)
}


#' Validate the nested geometry list-column of a brain_polygons object
#'
#' Each entry must be a non-empty data.frame carrying the per-ring columns.
#' Aborts via [cli::cli_abort()] on the first failing condition.
#' @keywords internal
#' @noRd
validate_polygon_geoms <- function(polygons) {
  nested_required <- c("view", "x", "y", "group", "subgroup")
  geoms <- polygons$geometry

  not_df <- !vapply(geoms, is.data.frame, logical(1))
  if (any(not_df)) {
    cli::cli_abort(c(
      "Each {.field geometry} entry must be a data.frame.",
      "x" = "Not a data.frame for: {.val {polygons$label[not_df]}}."
    ))
  }

  miss_cols <- vapply(
    geoms,
    function(g) length(setdiff(nested_required, names(g))) > 0L,
    logical(1)
  )
  if (any(miss_cols)) {
    cli::cli_abort(c(
      "Each {.field geometry} needs columns {.field {nested_required}}.",
      "x" = "Missing columns for: {.val {polygons$label[miss_cols]}}."
    ))
  }

  empty <- vapply(geoms, nrow, integer(1)) == 0L
  if (any(empty)) {
    cli::cli_abort(
      "Geometry data.frame is empty for: {.val {polygons$label[empty]}}."
    )
  }

  invisible(polygons)
}
