#' Get atlas palette
#'
#' Retrieves the colour palette from a brain atlas.
#'
#' @param name Character name of atlas (e.g., "dk", "aseg") or a
#'   ggseg_atlas object
#' @param ... Additional arguments (unused)
#'
#' @return Named character vector of colours
#' @export
#' @examples
#' atlas_palette("dk")
#' atlas_palette("aseg")
#' atlas_palette(dk)
atlas_palette <- function(name = "dk", ...) {
  atlas <- if (is.character(name)) {
    get(name, envir = parent.frame())
  } else {
    name
  }
  if (!inherits(atlas, "ggseg_atlas") && !inherits(atlas, "brain_atlas")) {
    cli::cli_abort("Could not find atlas {.val {name}}.")
  }
  atlas$palette
}

#' @rdname atlas_palette
#' @export
brain_pal <- function(name = "dk", ...) {
  lifecycle::deprecate_warn(
    "0.1.0",
    "brain_pal()",
    "atlas_palette()"
  )
  atlas_palette(name, ...)
}


#' Get atlas data for 2D rendering
#'
#' Returns sf data joined with core region info and palette colours.
#'
#' @param atlas a ggseg_atlas object
#' @return sf data.frame ready for plotting
#' @export
#' @examples
#' sf_data <- atlas_sf(dk)
#' head(sf_data)
atlas_sf <- function(atlas) {
  if (!is_ggseg_atlas(atlas)) {
    cli::cli_abort("{.arg atlas} must be a {.cls ggseg_atlas}.")
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

  class(result) <- c("ggseg_sf", class(result))
  result
}


#' Get atlas vertices for 3D rendering
#'
#' Returns vertices data joined with core region info and palette colours.
#' Used for cortical atlases with vertex-based rendering.
#'
#' @param atlas a ggseg_atlas object
#' @return data.frame with vertices ready for 3D rendering
#' @export
#' @examples
#' verts <- atlas_vertices(dk)
#' head(verts)
atlas_vertices <- function(atlas) {
  if (!is_ggseg_atlas(atlas)) {
    cli::cli_abort("{.arg atlas} must be a {.cls ggseg_atlas}.")
  }

  if (is.null(atlas$data$vertices)) {
    cli::cli_abort("Atlas does not contain vertices for 3D rendering.")
  }

  result <- dplyr::left_join(atlas$data$vertices, atlas$core, by = "label")

  if (!is.null(atlas$palette)) {
    result$colour <- unname(atlas$palette[result$label])
  }

  class(result) <- c("ggseg_vertices", class(result))
  result
}


#' Get atlas meshes for 3D rendering
#'
#' Returns meshes data joined with core region info and palette colours.
#' Used for subcortical and tract atlases.
#'
#' @param atlas a ggseg_atlas object
#' @return data.frame with meshes ready for 3D rendering
#' @export
#' @examples
#' meshes <- atlas_meshes(aseg)
#' head(meshes)
atlas_meshes <- function(atlas) {
  if (!is_ggseg_atlas(atlas)) {
    cli::cli_abort("{.arg atlas} must be a {.cls ggseg_atlas}.")
  }

  if (is.null(atlas$data$meshes)) {
    cli::cli_abort("Atlas does not contain meshes for 3D rendering.")
  }

  result <- dplyr::left_join(atlas$data$meshes, atlas$core, by = "label")

  if (!is.null(atlas$palette)) {
    result$colour <- unname(atlas$palette[result$label])
  }

  class(result) <- c("ggseg_meshes", class(result))
  result
}


#' @export
print.ggseg_sf <- function(x, ...) {
  dims <- paste(nrow(x), "\u00d7", ncol(x)) # nolint [object_usage_linter]
  views <- if ("view" %in% names(x)) {
    paste(unique(x$view), collapse = ", ")
  }
  cli::cli_rule("{.cls ggseg_sf} data: {dims}")
  if (!is.null(views)) {
    cli::cli_text("Views: {views}")
  }
  NextMethod()
}

#' @export
print.ggseg_vertices <- function(x, ...) {
  dims <- paste(nrow(x), "\u00d7", ncol(x)) # nolint [object_usage_linter]
  vert_lengths <- if ("vertices" %in% names(x)) {
    vapply(x$vertices, length, integer(1))
  }
  cli::cli_rule("{.cls ggseg_vertices} data: {dims}")
  if (!is.null(vert_lengths) && length(vert_lengths) > 0) {
    cli::cli_text(
      "Vertices per region: {format(min(vert_lengths), big.mark = ',')}
\u2013{format(max(vert_lengths), big.mark = ',')}"
    )
  }
  NextMethod()
}

#' @export
print.ggseg_meshes <- function(x, ...) {
  dims <- paste(nrow(x), "\u00d7", ncol(x)) # nolint [object_usage_linter]
  cli::cli_rule("{.cls ggseg_meshes} data: {dims}")
  if ("mesh" %in% names(x)) {
    print_mesh_summary(x)
  }
  invisible(x)
}
