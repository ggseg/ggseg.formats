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

  vertices
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

  for (i in seq_len(nrow(meshes))) {
    mesh <- meshes$mesh[[i]]
    label <- meshes$label[i]

    if (is.null(mesh)) {
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

    if (
      !is.data.frame(mesh$faces) ||
        !all(c("i", "j", "k") %in% names(mesh$faces))
    ) {
      cli::cli_abort(c(
        "Mesh faces for {.val {label}} must be a data.frame.",
        "i" = "Required columns: {.field i}, {.field j}, {.field k}."
      ))
    }

    if (tract && !is.null(mesh$metadata)) {
      validate_tract_metadata(mesh$metadata, label)
    }
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
#' @param data brain_atlas_data object
#' @param core core data.frame
#' @return data (unchanged)
#' @keywords internal
validate_data_labels <- function(data, core) {
  core_labels <- core$label

  if (!is.null(data$sf)) {
    unknown <- setdiff(data$sf$label[!is.na(data$sf$label)], core_labels)
    if (length(unknown) > 0) {
      cli::cli_warn("Unknown labels in sf: {.val {unknown}}")
    }
  }

  if (!is.null(data$vertices)) {
    unknown <- setdiff(
      data$vertices$label[!is.na(data$vertices$label)],
      core_labels
    )
    if (length(unknown) > 0) {
      cli::cli_warn("Unknown labels in vertices: {.val {unknown}}")
    }
  }

  if (!is.null(data$meshes)) {
    unknown <- setdiff(
      data$meshes$label[!is.na(data$meshes$label)],
      core_labels
    )
    if (length(unknown) > 0) {
      cli::cli_warn("Unknown labels in meshes: {.val {unknown}}")
    }
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
