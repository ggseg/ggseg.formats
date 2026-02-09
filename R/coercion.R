#' Coerce to brain atlas
#'
#' @param x object to make into a brain_atlas
#' @return an object of class 'brain_atlas'
#' @export
as_brain_atlas <- function(x) {
  UseMethod("as_brain_atlas")
}


#' @export
as_brain_atlas.default <- function(x) {
  cli::cli_abort(
    "Cannot convert {.cls {class(x)[1]}} to {.cls brain_atlas}."
  )
}


#' @export
as_brain_atlas.brain_atlas <- function(x) {
  if (!is.null(x$data) && inherits(x$data, "brain_atlas_data")) {
    return(x)
  }

  if (
    !is.null(x$core) &&
      (!is.null(x$sf) || !is.null(x$vertices) || !is.null(x$meshes))
  ) {
    return(convert_legacy_structure(x))
  }

  cli::cli_abort("Cannot convert brain_atlas: unrecognized structure.")
}


#' @export
as_brain_atlas.list <- function(x) {
  if ("data" %in% names(x) && inherits(x$data, "brain_atlas_data")) {
    return(brain_atlas(
      atlas = x$atlas,
      type = x$type,
      palette = x$palette,
      core = x$core,
      data = x$data
    ))
  }

  if (
    "core" %in%
      names(x) &&
      ("sf" %in% names(x) || "vertices" %in% names(x) || "meshes" %in% names(x))
  ) {
    legacy <- structure(x, class = "brain_atlas")
    return(convert_legacy_structure(legacy))
  }

  cli::cli_abort(
    "Cannot convert list to {.cls brain_atlas}."
  )
}

#' Convert legacy brain_atlas data to unified format
#'
#' Converts an old-style brain_atlas (where `$data` contains sf directly)
#' to the unified format with `$core` and `$data` (brain_atlas_data).
#'
#' @param x A legacy brain_atlas
#' @return A brain_atlas in unified format
#' @keywords internal
convert_legacy_brain_data <- function(x) {
  if (!inherits(x, "brain_atlas")) {
    cli::cli_abort("{.arg x} must be a {.cls brain_atlas}.")
  }

  if (!is.null(x$core)) {
    return(x)
  }

  sf_data <- x$data
  type <- x$type %||% "cortical"

  if ("side" %in% names(sf_data) && !"view" %in% names(sf_data)) {
    names(sf_data)[names(sf_data) == "side"] <- "view"
  }

  core <- dplyr::distinct(
    sf_data[, c("hemi", "region", "label"), drop = FALSE]
  )
  core <- sf::st_drop_geometry(core)

  palette <- if ("colour" %in% names(sf_data)) {
    stats::setNames(sf_data$colour, sf_data$label)
  } else {
    NULL
  }

  data <- switch(
    type,
    "cortical" = brain_data_cortical(sf = sf_data, vertices = NULL),
    "subcortical" = brain_data_subcortical(sf = sf_data, meshes = NULL),
    "tract" = brain_data_tract(sf = sf_data, meshes = NULL),
    brain_data_cortical(sf = sf_data, vertices = NULL)
  )

  brain_atlas(
    atlas = x$atlas,
    type = type,
    palette = palette,
    core = core,
    data = data
  )
}


#' Convert legacy brain_atlas structure
#'
#' Converts a brain_atlas with separate sf/vertices/meshes fields to the
#' new structure with a single data field.
#'
#' @param x A legacy brain_atlas
#' @return A brain_atlas with the new structure
#' @keywords internal
convert_legacy_structure <- function(x) {
  type <- x$type

  data <- switch(
    type,
    "cortical" = brain_data_cortical(sf = x$sf, vertices = x$vertices),
    "subcortical" = brain_data_subcortical(sf = x$sf, meshes = x$meshes),
    "tract" = brain_data_tract(sf = x$sf, meshes = x$meshes),
    cli::cli_abort("Unknown atlas type: {.val {type}}")
  )

  brain_atlas(
    atlas = x$atlas,
    type = type,
    palette = x$palette,
    core = x$core,
    data = data
  )
}
