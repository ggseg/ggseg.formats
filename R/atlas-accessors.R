#' Get brain atlas palette
#'
#' Retrieves the colour palette from a brain atlas.
#'
#' @param name Character name of atlas (e.g., "dk", "aseg") or a
#'   brain_atlas object
#' @param ... Additional arguments (unused)
#'
#' @return Named character vector of colours
#' @export
#' @examples
#' brain_pal("dk")
#' brain_pal("aseg")
#' brain_pal(dk)
brain_pal <- function(name = "dk", ...) {
  atlas <- if (is.character(name)) {
    get(name, envir = parent.frame())
  } else {
    name
  }
  if (!inherits(atlas, "brain_atlas")) {
    cli::cli_abort("Could not find atlas {.val {name}}.")
  }
  atlas$palette
}


#' Get atlas data for 2D rendering
#'
#' Returns sf data joined with core region info and palette colours.
#'
#' @param atlas a brain_atlas object
#' @return sf data.frame ready for plotting
#' @export
atlas_sf <- function(atlas) {
  if (!is_brain_atlas(atlas)) {
    cli::cli_abort("{.arg atlas} must be a {.cls brain_atlas}.")
  }

  if (is.null(atlas$data$sf)) {
    cli::cli_abort("Atlas does not contain sf geometry for 2D rendering.")
  }

  sf_data <- sf::st_as_sf(atlas$data$sf)
  core_cols <- intersect(names(sf_data), c("hemi", "region"))
  if (length(core_cols) > 0) {
    sf_data[core_cols] <- NULL
  }

  result <- merge(sf_data, atlas$core, by = "label", all.x = TRUE)

  if (!is.null(atlas$palette)) {
    result$colour <- unname(atlas$palette[result$label])
  }

  result
}


#' Get atlas vertices for 3D rendering
#'
#' Returns vertices data joined with core region info and palette colours.
#' Used for cortical atlases with vertex-based rendering.
#'
#' @param atlas a brain_atlas object
#' @return data.frame with vertices ready for 3D rendering
#' @export
atlas_vertices <- function(atlas) {
  if (!is_brain_atlas(atlas)) {
    cli::cli_abort("{.arg atlas} must be a {.cls brain_atlas}.")
  }

  if (is.null(atlas$data$vertices)) {
    cli::cli_abort("Atlas does not contain vertices for 3D rendering.")
  }

  result <- dplyr::left_join(atlas$data$vertices, atlas$core, by = "label")

  if (!is.null(atlas$palette)) {
    result$colour <- unname(atlas$palette[result$label])
  }

  result
}


#' Get atlas meshes for 3D rendering
#'
#' Returns meshes data joined with core region info and palette colours.
#' Used for subcortical and tract atlases.
#'
#' @param atlas a brain_atlas object
#' @return data.frame with meshes ready for 3D rendering
#' @export
atlas_meshes <- function(atlas) {
  if (!is_brain_atlas(atlas)) {
    cli::cli_abort("{.arg atlas} must be a {.cls brain_atlas}.")
  }

  if (is.null(atlas$data$meshes)) {
    cli::cli_abort("Atlas does not contain meshes for 3D rendering.")
  }

  result <- dplyr::left_join(atlas$data$meshes, atlas$core, by = "label")

  if (!is.null(atlas$palette)) {
    result$colour <- unname(atlas$palette[result$label])
  }

  result
}
