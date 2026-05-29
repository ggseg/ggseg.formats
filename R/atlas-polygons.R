# sf-optional atlas polygon format ----

#' Convert an sf atlas geometry to the sf-optional polygon format
#'
#' Extracts coordinates from an sf-backed atlas geometry table and returns a
#' nested tibble keyed by `label`. Each row carries a `geometry` list-column
#' containing the per-view, per-ring point coordinates needed to render with
#' [ggplot2::geom_polygon()] (using the `subgroup` aesthetic for holes).
#'
#' @param sf_data An sf-class data.frame with columns `label`, `view`,
#'   `geometry` (sfc of MULTIPOLYGON).
#'
#' @return A tibble with one row per `label` and a `geometry` list-column.
#'   Each nested element is a tibble with columns `view`, `x`, `y`,
#'   `group` (disjoint polygon piece within a label/view), `subgroup`
#'   (ring within a piece; first = exterior, rest = holes).
#' @export
#' @examples
#' \dontrun{
#' polys <- sf_to_polygons(dk()$data$sf)
#' }
sf_to_polygons <- function(sf_data) {
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
    dplyr::tibble(
      label = sf_data$label[i],
      view = sf_data$view[i],
      x = co[, "X"],
      y = co[, "Y"],
      group = as.integer(co[, "L2"]),
      subgroup = as.integer(co[, "L1"])
    )
  })

  combined <- dplyr::bind_rows(per_row)
  out <- tidyr::nest(combined, geometry = -"label")
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
#' @param polygons A `brain_polygons` tibble produced by [sf_to_polygons()] or
#'   constructed directly: one row per `label`, with a `geometry` list-column
#'   of tibbles containing `view`, `x`, `y`, `group`, `subgroup`.
#'
#' @return An sf-class data frame with columns `label`, `view`, `geometry`
#'   (one row per label×view, geometry is MULTIPOLYGON).
#' @export
polygons_to_sf <- function(polygons) {
  validate_polygons(polygons)

  flat <- tidyr::unnest(polygons, cols = "geometry")

  feature_key <- paste(flat$label, flat$view, sep = "")
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
  if (".feature_id" %in% names(out)) {
    out$.feature_id <- NULL
  }

  cols <- c("label", "view", "geometry")
  out <- out[, cols, drop = FALSE]
  out
}


#' Validate a brain_polygons object
#'
#' @param polygons object to validate
#' @return validated polygons (as tibble)
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

  if (anyDuplicated(polygons$label)) {
    dup <- polygons$label[duplicated(polygons$label)]
    cli::cli_abort(c(
      "{.arg polygons} must have one row per {.field label}.",
      "i" = "Duplicated: {.val {unique(dup)}}."
    ))
  }

  nested_required <- c("view", "x", "y", "group", "subgroup")
  for (i in seq_len(nrow(polygons))) {
    g <- polygons$geometry[[i]]
    if (!is.data.frame(g)) {
      cli::cli_abort(c(
        "Each {.field geometry} entry must be a data.frame.",
        "x" = "Element {i} ({polygons$label[i]}) is {.cls {class(g)[1]}}."
      ))
    }
    miss_n <- setdiff(nested_required, names(g))
    if (length(miss_n)) {
      cli::cli_abort(c(
        "Geometry tibble for {.val {polygons$label[i]}} missing columns:
        {.field {miss_n}}."
      ))
    }
    if (nrow(g) == 0) {
      cli::cli_abort(
        "Geometry tibble for {.val {polygons$label[i]}} is empty."
      )
    }
  }

  out <- dplyr::as_tibble(polygons)
  if (!inherits(out, "brain_polygons")) {
    out <- structure(out, class = c("brain_polygons", class(out)))
  }
  out
}


#' @export
print.brain_polygons <- function(x, ...) {
  cli::cli_h2("brain_polygons")
  cli::cli_text("{.strong Labels:} {nrow(x)}")
  if (nrow(x) > 0) {
    views <- unique(unlist(lapply(x$geometry, function(g) unique(g$view))))
    cli::cli_text("{.strong Views:} {paste(views, collapse = ', ')}")
    n_pts <- sum(vapply(x$geometry, nrow, integer(1)))
    cli::cli_text("{.strong Total points:} {n_pts}")
  }
  NextMethod()
}
