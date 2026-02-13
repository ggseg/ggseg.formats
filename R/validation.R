#' Validate sf component
#' @param sf sf data.frame to validate
#' @return validated sf object
#' @keywords internal
#' @noRd
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
    cli::cli_abort(c(
      "All sf entries must contain geometry.",
      "i" = "Empty geometry for: {.val {sf$label[empty_geom]}}."
    ))
  }

  sf
}


#' Validate vertices component
#' @param vertices vertices data.frame to validate
#' @return validated vertices object
#' @keywords internal
#' @noRd
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
#' @noRd
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
#' @return No return value, called for side effects
#' @keywords internal
#' @noRd
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
#' 3D sources (vertices, meshes, centerlines) are validated strictly: every
#' core label must have a corresponding entry. This check always runs.
#'
#' When `check_sf = TRUE` (the default at construction time), sf coverage
#' is also checked: an error is raised when fewer than 80 percent of core
#' labels appear in sf, and a warning when fewer than 90 percent. This
#' threshold is relaxed because 2D projections cannot always capture every
#' region (too small, occluded, etc.).
#'
#' During manipulation (view removal, region cleanup) sf coverage naturally
#' drops, so `rebuild_atlas` calls with `check_sf = FALSE`.
#'
#' Labels in data that are not in core are always allowed — these represent
#' context-only geometry (like medial wall) that renders grey without
#' appearing in legends.
#'
#' @param data ggseg_atlas_data object
#' @param core core data.frame
#' @param check_sf if TRUE, validate sf label coverage against core
#' @return data (unchanged)
#' @keywords internal
#' @noRd
validate_data_labels <- function(data, core, check_sf = FALSE) {
  core_labels <- core$label[!is.na(core$label)]
  n_core <- length(core_labels)

  if (!is.null(data$vertices)) {
    validate_3d_labels(data$vertices$label, core_labels, "vertices")
  }

  if (!is.null(data$meshes)) {
    validate_3d_labels(data$meshes$label, core_labels, "meshes")
  }

  if (!is.null(data$centerlines)) {
    validate_3d_labels(data$centerlines$label, core_labels, "centerlines")
  }

  if (isTRUE(check_sf) && !is.null(data$sf) && n_core > 0) {
    sf_labels <- unique(data$sf$label[!is.na(data$sf$label)])
    missing <- setdiff(core_labels, sf_labels)
    coverage <- 1 - length(missing) / n_core

    if (coverage < 0.8) {
      cli::cli_abort(c(
        "sf covers only {.strong {round(coverage * 100)}%} of core labels
        (minimum 80%).",
        "i" = "Missing from sf: {.val {missing}}."
      ))
    } else if (coverage < 0.9) {
      cli::cli_warn(c(
        "sf covers only {.strong {round(coverage * 100)}%} of core labels.",
        "i" = "Missing from sf: {.val {missing}}."
      ))
    }
  }

  data
}


#' @keywords internal
#' @noRd
validate_3d_labels <- function(labels, core_labels, source) {
  source_labels <- labels[!is.na(labels)]
  missing <- setdiff(core_labels, source_labels)
  if (length(missing) > 0) {
    cli::cli_abort(c(
      "All core labels must have corresponding {.field {source}} data.",
      "i" = "Missing from {source}: {.val {missing}}."
    ))
  }
}


#' Validate palette
#' @param palette named character vector of colours
#' @param core core data.frame
#' @return palette (unchanged)
#' @keywords internal
#' @noRd
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
