#' Validate sf component
#' @param sf sf data.frame to validate
#' @return validated sf object
#' @keywords internal
validate_sf <- function(sf) {
  if (!is.data.frame(sf)) {
    cli::cli_abort("{.arg sf} must be a data.frame.")
  }

  required <- c("label", "view", "geometry")
  missing <- setdiff(required, names(sf))
  if (length(missing) > 0) {
    cli::cli_abort("{.arg sf} must contain columns: {.field {missing}}.")
  }

  if (!inherits(sf$geometry, "sfc")) {
    cli::cli_abort(
      "{.field geometry} column must be an sf geometry column (sfc)."
    )
  }

  if (!inherits(sf, "sf")) {
    sf <- sf::st_as_sf(sf)
  }

  empty_geom <- sf::st_is_empty(sf$geometry)
  if (any(empty_geom)) {
    empty_labels <- sf$label[empty_geom]
    cli::cli_abort(c(
      "All sf entries must contain geometry.",
      "i" = "Empty geometry for: {.val {empty_labels}}."
    ))
  }

  sf
}


#' Validate vertices component
#' @param vertices vertices data.frame to validate
#' @return validated vertices object
#' @keywords internal
validate_vertices <- function(vertices) {
  if (!is.data.frame(vertices)) {
    cli::cli_abort("{.arg vertices} must be a data.frame.")
  }

  required <- c("label", "vertices")
  missing <- setdiff(required, names(vertices))
  if (length(missing) > 0) {
    cli::cli_abort("{.arg vertices} must contain columns: {.field {missing}}.")
  }

  if (!is.list(vertices$vertices)) {
    cli::cli_abort("{.field vertices} column must be a list-column.")
  }

  vertex_lengths <- vapply(vertices$vertices, length, integer(1))
  empty_labels <- vertices$label[vertex_lengths == 0]
  if (length(empty_labels) > 0) {
    cli::cli_abort(c(
      "All vertex entries must contain data.",
      "i" = "Empty vertices for: {.val {empty_labels}}."
    ))
  }

  dplyr::as_tibble(vertices)
}


#' Validate meshes component
#' @param meshes meshes data.frame to validate
#' @param tract If TRUE, validates additional tract-specific mesh components
#' @return validated meshes object
#' @keywords internal
validate_meshes <- function(meshes, tract = FALSE) {
  if (!is.data.frame(meshes)) {
    cli::cli_abort("{.arg meshes} must be a data.frame.")
  }

  required <- c("label", "mesh")
  missing <- setdiff(required, names(meshes))
  if (length(missing) > 0) {
    cli::cli_abort("{.arg meshes} must contain columns: {.field {missing}}.")
  }

  if (!is.list(meshes$mesh)) {
    cli::cli_abort("{.field mesh} column must be a list-column.")
  }

  empty_labels <- character(0)

  for (i in seq_len(nrow(meshes))) {
    mesh <- meshes$mesh[[i]]
    label <- meshes$label[i]

    if (is.null(mesh)) {
      empty_labels <- c(empty_labels, label)
      next
    }

    if (!is.list(mesh) || !all(c("vertices", "faces") %in% names(mesh))) {
      cli::cli_abort(
        "Mesh for {.val {label}} needs {.field vertices} and {.field faces}."
      )
    }

    if (
      !is.data.frame(mesh$vertices) ||
        !all(c("x", "y", "z") %in% names(mesh$vertices))
    ) {
      cli::cli_abort(c(
        "Mesh vertices for {.val {label}} must be a data.frame.",
        "i" = "Required columns: {.field x}, {.field y}, {.field z}."
      ))
    }

    if (nrow(mesh$vertices) == 0) {
      empty_labels <- c(empty_labels, label)
      next
    }

    if (
      !is.data.frame(mesh$faces) ||
        !all(c("i", "j", "k") %in% names(mesh$faces))
    ) {
      cli::cli_abort(c(
        "Mesh faces for {.val {label}} must be a data.frame.",
        "i" = "Required columns: {.field i}, {.field j}, {.field k}."
      ))
    }

    if (nrow(mesh$faces) == 0) {
      empty_labels <- c(empty_labels, label)
      next
    }

    if (tract && !is.null(mesh$metadata)) {
      validate_tract_metadata(mesh$metadata, label)
    }
  }

  if (length(empty_labels) > 0) {
    cli::cli_abort(c(
      "All mesh entries must contain data.",
      "i" = "Empty mesh for: {.val {empty_labels}}."
    ))
  }

  meshes
}


#' Validate tract mesh metadata
#' @param metadata metadata list to validate
#' @param label label for error messages
#' @keywords internal
validate_tract_metadata <- function(metadata, label) {
  if (!is.list(metadata)) {
    cli::cli_warn("Mesh metadata for {.val {label}} should be a list.")
    return(invisible())
  }

  recommended <- c("n_centerline_points", "centerline", "tangents")
  missing <- setdiff(recommended, names(metadata))

  if (length(missing) > 0 && length(missing) < length(recommended)) {
    cli::cli_warn(
      "Mesh metadata for {.val {label}} missing: {.field {missing}}. ",
      "Orientation coloring may not work."
    )
  }
}


#' Validate data labels against core
#'
#' Ensures all core labels have corresponding data. Labels in data that are
#' not in core are allowed - these represent context-only geometry (like
#' medial wall) that will display grey without appearing in legends.
#'
#' @param data brain_atlas_data object
#' @param core core data.frame
#' @return data (unchanged)
#' @keywords internal
validate_data_labels <- function(data, core) {
  core_labels <- core$label[!is.na(core$label)]

  data_labels <- character(0)
  if (!is.null(data$sf)) {
    data_labels <- union(data_labels, data$sf$label[!is.na(data$sf$label)])
  }

  if (!is.null(data$vertices)) {
    data_labels <- union(
      data_labels,
      data$vertices$label[!is.na(data$vertices$label)]
    )
  }

  if (!is.null(data$meshes)) {
    data_labels <- union(
      data_labels,
      data$meshes$label[!is.na(data$meshes$label)]
    )
  }

  if (!is.null(data$centerlines)) {
    data_labels <- union(
      data_labels,
      data$centerlines$label[!is.na(data$centerlines$label)]
    )
  }

  missing_from_data <- setdiff(core_labels, data_labels)
  if (length(missing_from_data) > 0) {
    cli::cli_abort(c(
      "All core labels must have corresponding data.",
      "i" = "Missing from data: {.val {missing_from_data}}."
    ))
  }

  data
}


#' Validate palette
#' @param palette named character vector of colours
#' @param core core data.frame
#' @return palette (unchanged)
#' @keywords internal
validate_palette <- function(palette, core) {
  if (!is.character(palette) || is.null(names(palette))) {
    cli::cli_abort("{.arg palette} must be a named character vector.")
  }

  unknown_labels <- setdiff(names(palette), core$label)
  if (length(unknown_labels) > 0) {
    cli::cli_warn(c(
      "Some labels in {.arg palette} not found in {.arg core}.",
      "i" = "Unknown: {.val {unknown_labels}}."
    ))
  }

  palette
}
