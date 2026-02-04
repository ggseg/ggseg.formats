#' Create cortical atlas data
#'
#' Creates a data object for cortical brain atlases. Cortical atlases use
#' vertex indices that map regions to vertices on a shared brain surface mesh
#' (e.g., fsaverage5).
#'
#' @param sf sf data.frame with columns label, view, geometry for 2D rendering.
#'   Optional but required for ggseg plotting.
#' @param vertices data.frame with columns label and vertices (list-column of
#'   integer vectors). Each vector contains vertex indices for that region.
#'
#' @return An object of class c("cortical_data", "brain_atlas_data")
#' @export
#'
#' @examples
#' \dontrun{
#' data <- cortical_data(
#'   sf = sf_geometry,
#'   vertices = data.frame(
#'     label = c("bankssts", "caudalanteriorcingulate"),
#'     vertices = I(list(c(1, 2, 3), c(4, 5, 6)))
#'   )
#' )
#' }
cortical_data <- function(sf = NULL, vertices = NULL) {
  if (is.null(sf) && is.null(vertices)) {
    cli::cli_abort("At least one of {.arg sf} or {.arg vertices} is required.")
  }

  if (!is.null(vertices)) {
    vertices <- validate_vertices(vertices)
  }

  if (!is.null(sf)) {
    sf <- validate_sf(sf)
  }

  structure(
    list(
      sf = sf,
      vertices = vertices
    ),
    class = c("cortical_data", "brain_atlas_data")
  )
}


#' Create subcortical atlas data
#'
#' Creates a data object for subcortical brain atlases. Subcortical atlases
#' use individual 3D meshes for each structure (e.g., hippocampus, amygdala).
#'
#' @param sf sf data.frame with columns label, view, geometry for 2D rendering.
#'   Optional.
#' @param meshes data.frame with columns label and mesh (list-column).
#'   Each mesh is a list with:
#'   \itemize{
#'     \item vertices: data.frame with x, y, z columns
#'     \item faces: data.frame with i, j, k columns (1-based triangle indices)
#'   }
#'
#' @return An object of class c("subcortical_data", "brain_atlas_data")
#' @export
#'
#' @examples
#' \dontrun{
#' data <- subcortical_data(
#'   meshes = data.frame(
#'     label = "hippocampus_left",
#'     mesh = I(list(list(
#'       vertices = data.frame(x = 1:10, y = 1:10, z = 1:10),
#'       faces = data.frame(i = 1:3, j = 2:4, k = 3:5)
#'     )))
#'   )
#' )
#' }
subcortical_data <- function(sf = NULL, meshes = NULL) {
  if (is.null(sf) && is.null(meshes)) {
    cli::cli_abort("At least one of {.arg sf} or {.arg meshes} is required.")
  }

  if (!is.null(meshes)) {
    meshes <- validate_meshes(meshes)
  }

  if (!is.null(sf)) {
    sf <- validate_sf(sf)
  }

  structure(
    list(
      sf = sf,
      meshes = meshes
    ),
    class = c("subcortical_data", "brain_atlas_data")
  )
}


#' Create tract atlas data
#'
#' Creates a data object for white matter tract atlases. Tract atlases use
#' tube meshes generated from streamline centerlines.
#'
#' @param sf sf data.frame with columns label, view, geometry for 2D rendering.
#'   Optional.
#' @param meshes data.frame with columns label and mesh (list-column).
#'   Each mesh is a list with:
#'   \itemize{
#'     \item vertices: data.frame with x, y, z columns
#'     \item faces: data.frame with i, j, k columns
#'     \item metadata: list with n_centerline_points, centerline, tangents
#'       (required for orientation coloring and data projection)
#'   }
#'
#' @return An object of class c("tract_data", "brain_atlas_data")
#' @export
#'
#' @examples
#' \dontrun{
#' data <- tract_data(meshes = tube_meshes_df)
#' }
tract_data <- function(sf = NULL, meshes = NULL) {
  if (is.null(sf) && is.null(meshes)) {
    cli::cli_abort("At least one of {.arg sf} or {.arg meshes} is required.")
  }

  if (!is.null(meshes)) {
    meshes <- validate_meshes(meshes, tract = TRUE)
  }

  if (!is.null(sf)) {
    sf <- validate_sf(sf)
  }

  structure(
    list(
      sf = sf,
      meshes = meshes
    ),
    class = c("tract_data", "brain_atlas_data")
  )
}
