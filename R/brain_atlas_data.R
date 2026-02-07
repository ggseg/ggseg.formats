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
#' Creates a data object for white matter tract atlases. Stores centerlines
#' compactly; tube meshes are generated at render time for efficiency.
#'
#' @param sf sf data.frame with columns label, view, geometry for 2D rendering.
#'   Optional.
#' @param centerlines data.frame with columns:
#'   \itemize{
#'     \item label: tract identifier (character)
#'     \item points: list-column of n x 3 matrices (centerline coordinates)
#'     \item tangents: list-column of n x 3 matrices (for orientation coloring)
#'   }
#' @param tube_radius Radius for tube mesh generation. Default 5.
#' @param tube_segments Number of segments around tube circumference. Default 8.
#' @param meshes Deprecated. Use centerlines instead. If provided, will be
#'   converted to centerlines format.
#'
#' @return An object of class c("tract_data", "brain_atlas_data")
#' @export
#'
#' @examples
#' \dontrun{
#' centerlines_df <- data.frame(
#'   label = "cst_left",
#'   points = I(list(matrix(rnorm(150), ncol = 3))),
#'   tangents = I(list(matrix(rnorm(150), ncol = 3)))
#' )
#' data <- tract_data(centerlines = centerlines_df)
#' }
tract_data <- function(
    sf = NULL,
    centerlines = NULL,
    tube_radius = 5,
    tube_segments = 8,
    meshes = NULL
) {
  if (!is.null(meshes) && is.null(centerlines)) {
    centerlines <- meshes_to_centerlines(meshes)
  }

  if (is.null(sf) && is.null(centerlines)) {
    cli::cli_abort(
      "At least one of {.arg sf} or {.arg centerlines} is required."
    )
  }

  if (!is.null(centerlines)) {
    centerlines <- validate_centerlines(centerlines)
  }

  if (!is.null(sf)) {
    sf <- validate_sf(sf)
  }

  structure(
    list(
      sf = sf,
      centerlines = centerlines,
      tube_radius = tube_radius,
      tube_segments = as.integer(tube_segments)
    ),
    class = c("tract_data", "brain_atlas_data")
  )
}


#' Convert legacy meshes to centerlines format
#' @noRd
meshes_to_centerlines <- function(meshes) {
  if (is.null(meshes)) return(NULL)

  centerlines_list <- lapply(seq_len(nrow(meshes)), function(i) {

    mesh <- meshes$mesh[[i]]
    metadata <- mesh$metadata

    if (is.null(metadata) || is.null(metadata$centerline)) {
      cli::cli_warn(
        "Mesh for {meshes$label[i]} missing centerline metadata, skipping"
      )
      return(NULL)
    }

    data.frame(
      label = meshes$label[i],
      points = I(list(metadata$centerline)),
      tangents = I(list(metadata$tangents)),
      stringsAsFactors = FALSE
    )
  })

  centerlines_list <- centerlines_list[!sapply(centerlines_list, is.null)]
  if (length(centerlines_list) == 0) {
    cli::cli_abort("No valid centerlines could be extracted from meshes")
  }

 do.call(rbind, centerlines_list)
}


#' Validate centerlines data frame
#' @noRd
validate_centerlines <- function(centerlines) {
  required_cols <- c("label", "points")
  missing <- setdiff(required_cols, names(centerlines))
  if (length(missing) > 0) {
    cli::cli_abort(
      "Centerlines missing required columns: {.val {missing}}"
    )
  }

  if (!is.list(centerlines$points)) {
    cli::cli_abort("{.arg points} must be a list-column of matrices")
  }

  for (i in seq_len(nrow(centerlines))) {
    pts <- centerlines$points[[i]]
    if (!is.matrix(pts) || ncol(pts) != 3) {
      cli::cli_abort(
        "points[[{i}]] must be an n x 3 matrix, got {class(pts)[1]}"
      )
    }
  }

  if (!"tangents" %in% names(centerlines)) {
    centerlines$tangents <- lapply(centerlines$points, compute_tangents)
  }

  centerlines
}


#' Compute tangent vectors from centerline points
#' @noRd
compute_tangents <- function(points) {
 n <- nrow(points)
  tangents <- matrix(0, nrow = n, ncol = 3)

  for (i in seq_len(n)) {
    if (i == 1) {
      tangent <- points[2, ] - points[1, ]
    } else if (i == n) {
      tangent <- points[n, ] - points[n - 1, ]
    } else {
      tangent <- points[i + 1, ] - points[i - 1, ]
    }
    norm <- sqrt(sum(tangent^2))
    tangents[i, ] <- if (norm > 0) tangent / norm else c(1, 0, 0)
  }

  tangents
}


#' @export
print.cortical_data <- function(x, ...) {
  cli::cli_h2("cortical_data")

  if (!is.null(x$sf)) {
    n_labels <- length(unique(x$sf$label))
    views <- paste0(unique(x$sf$view), collapse = ", ")
    cli::cli_text("{.strong 2D (ggseg):} {n_labels} labels, views: {views}")
  }

  if (!is.null(x$vertices)) {
    cli::cli_text("{.strong 3D (ggseg3d):} vertex indices")
    print(x$vertices, ...)
  }

  invisible(x)
}


#' @export
print.subcortical_data <- function(x, ...) {
  cli::cli_h2("subcortical_data")

  if (!is.null(x$sf)) {
    n_labels <- length(unique(x$sf$label))
    views <- paste0(unique(x$sf$view), collapse = ", ")
    cli::cli_text("{.strong 2D (ggseg):} {n_labels} labels, views: {views}")
  }

  if (!is.null(x$meshes)) {
    cli::cli_text("{.strong 3D (ggseg3d):} meshes")
    print_mesh_summary(x$meshes)
  }

  invisible(x)
}


#' @export
print.tract_data <- function(x, ...) {
 cli::cli_h2("tract_data")

  if (!is.null(x$sf)) {
    n_labels <- length(unique(x$sf$label))
    views <- paste0(unique(x$sf$view), collapse = ", ")
    cli::cli_text("{.strong 2D (ggseg):} {n_labels} labels, views: {views}")
  }

  if (!is.null(x$centerlines)) {
    n_tracts <- nrow(x$centerlines)
    total_points <- sum(sapply(x$centerlines$points, nrow))
    cli::cli_text(
      "{.strong 3D (ggseg3d):} {n_tracts} centerlines ({total_points} points)"
    )
    cli::cli_text(
      "Tube params: radius = {x$tube_radius}, segments = {x$tube_segments}"
    )
  }

  invisible(x)
}


print_mesh_summary <- function(meshes) {
  summary_df <- dplyr::tibble(
    label = meshes$label,
    vertices = vapply(meshes$mesh, function(m) {
      if (is.null(m)) 0L else nrow(m$vertices)
    }, integer(1)),
    faces = vapply(meshes$mesh, function(m) {
      if (is.null(m)) 0L else nrow(m$faces)
    }, integer(1))
  )
  print(summary_df)
}
