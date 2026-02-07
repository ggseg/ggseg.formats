#' Extract unique names of brain regions
#'
#' Convenience function to extract names of
#' brain regions from a \code{\link{brain_atlas}}
#'
#' @param x brain atlas
#' @return Character vector of brain region names
#' @export
brain_regions <- function(x) {
  UseMethod("brain_regions")
}

#' @export
#' @rdname brain_regions
brain_regions.ggseg_atlas <- function(x) {
  get_uniq(x, "region")
}

#' @export
#' @rdname brain_regions
brain_regions.brain_atlas <- function(x) {
  get_uniq(x$core, "region")
}

#' @export
#' @rdname brain_regions
brain_regions.data.frame <- function(x) {
  get_uniq(x, "region")
}


#' Get unique label or region values
#' @keywords internal
#' @noRd
get_uniq <- function(x, type) {
  type <- match.arg(type, c("label", "region"))
  x <- unique(x[[type]])
  x <- x[!is.na(x)]
  x[order(x)]
}

#' Extract unique labels of brain regions
#'
#' Convenience function to extract names of
#' brain labels from a \code{\link{brain_atlas}}.
#' Brain labels are usually default naming obtained
#' from the original atlas data.
#'
#' @param x brain atlas
#' @return Character vector of atlas region labels
#' @export
brain_labels <- function(x) {
  UseMethod("brain_labels")
}

#' @export
#' @rdname brain_labels
brain_labels.ggseg_atlas <- function(x) {
  get_uniq(x, "label")
}

#' @export
#' @rdname brain_labels
brain_labels.brain_atlas <- function(x) {
  get_uniq(x$core, "label")
}


#' Detect atlas type
#' @keywords internal
#' @export
atlas_type <- function(x) {
  UseMethod("atlas_type")
}

#' @keywords internal
#' @export
atlas_type.ggseg_atlas <- function(x) {
  guess_type(x)
}

#' @keywords internal
#' @export
atlas_type.brain_atlas <- function(x) {
  guess_type(x)
}

#' guess the atlas type
#' @keywords internal
#' @noRd
guess_type <- function(x) {
  if ("type" %in% names(x) && !is.na(x$type[1])) {
    return(unique(x$type))
  }

  cli::cli_warn("Atlas type not set, attempting to guess type.")

  views <- if (is_brain_atlas(x) && !is.null(x$sf)) {
    x$sf$view
  } else if ("view" %in% names(x)) {
    x$view
  } else {
    character(0)
  }

  if (any(grepl("medial|lateral", views))) {
    "cortical"
  } else {
    "subcortical"
  }
}


# Atlas region manipulation ----

#' Remove regions from atlas
#'
#' Completely removes regions matching a pattern from the atlas. Affected
#' regions are removed from core, palette, sf geometry, and 3D rendering
#' data (vertices/meshes). Use [atlas_region_contextual()] instead if you
#' want to keep the geometry for visual context.
#'
#' @param atlas A `brain_atlas` object
#' @param pattern Character pattern to match against region names or labels.
#'   Uses `grepl(..., ignore.case = TRUE)`.
#' @param match_on Column to match against: "region" (default) or "label"
#'
#' @return Modified `brain_atlas` with matching regions completely removed
#' @export
#' @examples
#' \dontrun{
#' # Remove white matter from subcortical atlas
#' atlas <- atlas |> atlas_region_remove("White-Matter")
#'
#' # Remove by label pattern
#' atlas <- atlas |> atlas_region_remove("^lh_", match_on = "label")
#' }
atlas_region_remove <- function(atlas, pattern, match_on = c("region", "label")) {
  match_on <- match.arg(match_on)

  match_col <- atlas$core[[match_on]]
  keep_mask <- !grepl(pattern, match_col, ignore.case = TRUE)
  keep_mask[is.na(match_col)] <- TRUE

  labels_to_remove <- atlas$core$label[!keep_mask]

  new_core <- atlas$core[keep_mask, , drop = FALSE]
  new_palette <- atlas$palette[!names(atlas$palette) %in% labels_to_remove]

  new_sf <- if (!is.null(atlas$data$sf)) {
    atlas$data$sf[!grepl(pattern, atlas$data$sf$label, ignore.case = TRUE), ]
  } else {
    NULL
  }

  if (!is.null(atlas$data$vertices)) {
    new_vertices <- atlas$data$vertices[
      !atlas$data$vertices$label %in% labels_to_remove,
      ,
      drop = FALSE
    ]
    new_data <- cortical_data(
      sf = new_sf,
      vertices = new_vertices
    )
  } else if (!is.null(atlas$data$meshes)) {
    new_meshes <- atlas$data$meshes[
      !atlas$data$meshes$label %in% labels_to_remove,
      ,
      drop = FALSE
    ]
    new_data <- subcortical_data(
      sf = new_sf,
      meshes = new_meshes
    )
  } else {
    new_data <- atlas$data
    if (!is.null(new_sf)) {
      new_data$sf <- new_sf
    }
  }

  brain_atlas(
    atlas = atlas$atlas,
    type = atlas$type,
    palette = new_palette,
    core = new_core,
    data = new_data
  )
}


#' Mark regions as context-only
#'
#' Removes matching regions from core, palette, and 3D rendering data
#' (vertices/meshes). The 2D geometry (sf) is preserved so these regions
#' display grey and provide visual context, but won't appear in legends.
#'
#' For cortical atlases, the shared brain mesh provides 3D context naturally.
#' For subcortical/tract atlases, use glass brains for 3D context instead.
#'
#' @param atlas A `brain_atlas` object
#' @param pattern Character pattern to match against region names or labels.
#'   Uses `grepl(..., ignore.case = TRUE)`.
#' @param match_on Column to match against: "region" (default) or "label"
#'
#' @return Modified `brain_atlas` with matching regions as context-only
#' @export
#' @examples
#' \dontrun{
#' # Keep medial wall geometry for visual context but don't label it
#' atlas <- atlas |> atlas_region_contextual("unknown")
#'
#' # Make cortex context-only in subcortical atlas
#' atlas <- atlas |> atlas_region_contextual("Cortex", match_on = "label")
#' }
atlas_region_contextual <- function(atlas, pattern, match_on = c("region", "label")) {
  match_on <- match.arg(match_on)

  match_col <- atlas$core[[match_on]]
  keep_mask <- !grepl(pattern, match_col, ignore.case = TRUE)
  keep_mask[is.na(match_col)] <- TRUE

  labels_to_remove <- atlas$core$label[!keep_mask]

  new_core <- atlas$core[keep_mask, , drop = FALSE]
  new_palette <- atlas$palette[!names(atlas$palette) %in% labels_to_remove]

  if (!is.null(atlas$data$vertices)) {
    new_vertices <- atlas$data$vertices[
      !atlas$data$vertices$label %in% labels_to_remove,
      ,
      drop = FALSE
    ]
    new_data <- cortical_data(
      sf = atlas$data$sf,
      vertices = new_vertices
    )
  } else if (!is.null(atlas$data$meshes)) {
    new_meshes <- atlas$data$meshes[
      !atlas$data$meshes$label %in% labels_to_remove,
      ,
      drop = FALSE
    ]
    new_data <- subcortical_data(
      sf = atlas$data$sf,
      meshes = new_meshes
    )
  } else {
    new_data <- atlas$data
  }

  brain_atlas(
    atlas = atlas$atlas,
    type = atlas$type,
    palette = new_palette,
    core = new_core,
    data = new_data
  )
}


#' Rename regions in atlas
#'
#' Renames regions matching a pattern to a new name, or applies a
#' transformation function. Only affects the `region` column (human-readable
#' names), not the `label` column (technical identifiers).
#'
#' @param atlas A `brain_atlas` object
#' @param pattern Character pattern to match against region names
#' @param replacement Replacement string or function. If a function, it receives
#'   the matched region names and should return new names.
#'
#' @return Modified `brain_atlas` with renamed regions
#' @export
#' @examples
#' \dontrun{
#' # Simple replacement
#' atlas <- atlas |> atlas_region_rename("bankssts", "banks of STS")
#'
#' # Using a function
#' atlas <- atlas |> atlas_region_rename(".*", toupper)
#' }
atlas_region_rename <- function(atlas, pattern, replacement) {
  new_core <- atlas$core
  match_mask <- grepl(pattern, new_core$region, ignore.case = TRUE)
  match_mask[is.na(new_core$region)] <- FALSE

  if (is.function(replacement)) {
    new_core$region[match_mask] <- replacement(new_core$region[match_mask])
  } else {
    new_core$region[match_mask] <- gsub(
      pattern,
      replacement,
      new_core$region[match_mask],
      ignore.case = TRUE
    )
  }

  brain_atlas(
    atlas = atlas$atlas,
    type = atlas$type,
    palette = atlas$palette,
    core = new_core,
    data = atlas$data
  )
}


#' Keep only specified regions
#'
#' Inverse of `atlas_region_remove()` - keeps only regions matching the pattern.
#' Non-matching regions are removed from core, palette, and 3D rendering data
#' (vertices/meshes). The 2D geometry (sf) is preserved to maintain brain
#' surface continuity.
#'
#' @param atlas A `brain_atlas` object
#' @param pattern Character pattern to match against region names or labels.
#'   Uses `grepl(..., ignore.case = TRUE)`.
#' @param match_on Column to match against: "region" (default) or "label"
#'
#' @return Modified `brain_atlas` with only matching regions kept
#' @export
#' @examples
#' \dontrun{
#' # Keep only basal ganglia structures
#' atlas <- atlas |> atlas_region_keep("caudate|putamen|pallidum")
#'
#' # Keep only left hemisphere
#' atlas <- atlas |> atlas_region_keep("^lh_", match_on = "label")
#' }
atlas_region_keep <- function(atlas, pattern, match_on = c("region", "label")) {
  match_on <- match.arg(match_on)

  match_col <- atlas$core[[match_on]]
  keep_mask <- grepl(pattern, match_col, ignore.case = TRUE)
  keep_mask[is.na(match_col)] <- FALSE

  labels_to_keep <- atlas$core$label[keep_mask]

  new_core <- atlas$core[keep_mask, , drop = FALSE]
  new_palette <- atlas$palette[names(atlas$palette) %in% labels_to_keep]

  if (!is.null(atlas$data$vertices)) {
    new_vertices <- atlas$data$vertices[
      atlas$data$vertices$label %in% labels_to_keep,
      ,
      drop = FALSE
    ]
    new_data <- cortical_data(
      sf = atlas$data$sf,
      vertices = new_vertices
    )
  } else if (!is.null(atlas$data$meshes)) {
    new_meshes <- atlas$data$meshes[
      atlas$data$meshes$label %in% labels_to_keep,
      ,
      drop = FALSE
    ]
    new_data <- subcortical_data(
      sf = atlas$data$sf,
      meshes = new_meshes
    )
  } else {
    new_data <- atlas$data
  }

  brain_atlas(
    atlas = atlas$atlas,
    type = atlas$type,
    palette = new_palette,
    core = new_core,
    data = new_data
  )
}


# Atlas core manipulation ----

#' Add metadata to atlas core
#'
#' Joins additional metadata columns to the atlas core data frame.
#'
#' @param atlas A `brain_atlas` object
#' @param data Data frame with metadata to join
#' @param by Column(s) to join by. Default is "region".
#'
#' @return Modified `brain_atlas` with additional core columns
#' @export
#' @examples
#' \dontrun{
#' lobe_data <- data.frame(
#'   region = c("bankssts", "fusiform"),
#'   lobe = c("temporal", "temporal")
#' )
#' atlas <- atlas |> atlas_core_add(lobe_data)
#' }
atlas_core_add <- function(atlas, data, by = "region") {
  new_core <- dplyr::left_join(atlas$core, data, by = by)

  brain_atlas(
    atlas = atlas$atlas,
    type = atlas$type,
    palette = atlas$palette,
    core = new_core,
    data = atlas$data
  )
}


# Atlas view manipulation ----

#' Get available views in atlas
#'
#' Returns the unique view names from the atlas sf data.
#'
#' @param atlas A `brain_atlas` object
#' @return Character vector of view names, or NULL if no sf data
#' @export
#' @examples
#' \dontrun{
#' brain_views(aseg)
#' # [1] "axial_inferior" "axial_superior" "coronal_anterior" ...
#' }
brain_views <- function(atlas) {

  if (is.null(atlas$data$sf)) {
    return(NULL)
  }
  unique(atlas$data$sf$view)
}


#' Remove views from atlas
#'
#' Removes 2D views matching the pattern from the atlas sf data.
#' Use this to curate which views are included in the final atlas
#' after generating many projection views.
#'
#' @param atlas A `brain_atlas` object
#' @param pattern Character pattern to match against view names.
#'   Uses `grepl(..., ignore.case = TRUE)`.
#'
#' @return Modified `brain_atlas` with matching views removed
#' @export
#' @examples
#' \dontrun{
#' # Remove inferior views
#' atlas <- atlas |> atlas_view_remove("inferior")
#'
#' # Remove multiple views
#' atlas <- atlas |> atlas_view_remove(c("axial_1", "axial_2"))
#' }
atlas_view_remove <- function(atlas, views) {
  if (is.null(atlas$data$sf)) {
    cli::cli_warn("Atlas has no sf data, nothing to remove")
    return(atlas)
  }

  pattern <- paste(views, collapse = "|")
  keep_mask <- !grepl(pattern, atlas$data$sf$view, ignore.case = TRUE)
  new_sf <- atlas$data$sf[keep_mask, , drop = FALSE]

  if (nrow(new_sf) == 0) {
    cli::cli_warn("All views removed, sf data will be NULL")
    new_sf <- NULL
  }

  new_data <- rebuild_atlas_data(atlas, new_sf)

 brain_atlas(
    atlas = atlas$atlas,
    type = atlas$type,
    palette = atlas$palette,
    core = atlas$core,
    data = new_data
  )
}


#' Keep only specified views
#'
#' Inverse of `atlas_view_remove()` - keeps only views matching the pattern.
#'
#' @param atlas A `brain_atlas` object
#' @param views Character vector of view names or patterns to keep.
#'   Multiple values are collapsed with "|" for matching.
#'   Uses `grepl(..., ignore.case = TRUE)`.
#'
#' @return Modified `brain_atlas` with only matching views kept
#' @export
#' @examples
#' \dontrun{
#' # Keep only axial views
#' atlas <- atlas |> atlas_view_keep("axial")
#'
#' # Keep specific views using vector
#' atlas <- atlas |> atlas_view_keep(c("axial_3", "coronal_2", "sagittal"))
#' }
atlas_view_keep <- function(atlas, views) {
  if (is.null(atlas$data$sf)) {
    cli::cli_warn("Atlas has no sf data, nothing to keep")
    return(atlas)
  }

  pattern <- paste(views, collapse = "|")
  keep_mask <- grepl(pattern, atlas$data$sf$view, ignore.case = TRUE)
  new_sf <- atlas$data$sf[keep_mask, , drop = FALSE]

  if (nrow(new_sf) == 0) {
    cli::cli_warn("No views matched pattern, sf data will be NULL")
    new_sf <- NULL
  }

  new_data <- rebuild_atlas_data(atlas, new_sf)

  brain_atlas(
    atlas = atlas$atlas,
    type = atlas$type,
    palette = atlas$palette,
    core = atlas$core,
    data = new_data
  )
}


#' Gather views to remove gaps
#'
#' After removing views with `atlas_view_remove()`, gaps remain in the
#' x-axis layout. This function repositions the remaining views to close
#' those gaps while preserving view order.
#'
#' @param atlas A `brain_atlas` object
#' @param gap Proportional gap between views (default 0.15 = 15% of max width)
#'
#' @return Modified `brain_atlas` with views repositioned
#' @export
#' @examples
#' \dontrun{
#' atlas <- atlas |>
#'   atlas_view_remove("axial_1|axial_2") |>
#'   atlas_view_gather()
#' }
atlas_view_gather <- function(atlas, gap = 0.15) {
  if (is.null(atlas$data$sf)) {
    cli::cli_warn("Atlas has no sf data")
    return(atlas)
  }

  new_sf <- reposition_views(atlas$data$sf, gap = gap)
  new_data <- rebuild_atlas_data(atlas, new_sf)

  brain_atlas(
    atlas = atlas$atlas,
    type = atlas$type,
    palette = atlas$palette,
    core = atlas$core,
    data = new_data
  )
}


#' Reorder views
#'
#' Changes the order of views in the atlas sf data and repositions them
#' accordingly. Views not specified in the order are appended at the end
#' in their original order.
#'
#' @param atlas A `brain_atlas` object
#' @param order Character vector specifying desired view order. Can be
#'   partial - unspecified views are appended at the end.
#' @param gap Proportional gap between views (default 0.15 = 15% of max width)
#'
#' @return Modified `brain_atlas` with views reordered and repositioned
#' @export
#' @examples
#' \dontrun{
#' # Put sagittal first, then specific axial views
#' atlas <- atlas |>
#'   atlas_view_reorder(c("sagittal", "axial_3", "axial_5"))
#'
#' # Reverse order
#' atlas <- atlas |>
#'   atlas_view_reorder(rev(brain_views(atlas)))
#' }
atlas_view_reorder <- function(atlas, order, gap = 0.15) {
  if (is.null(atlas$data$sf)) {
    cli::cli_warn("Atlas has no sf data")
    return(atlas)
  }

  current_views <- unique(atlas$data$sf$view)

  missing_from_order <- setdiff(current_views, order)
  if (length(missing_from_order) > 0) {
    order <- c(order, missing_from_order)
  }

  order <- order[order %in% current_views]

  if (length(order) == 0) {
    cli::cli_warn("No matching views found in order specification")
    return(atlas)
  }

  atlas$data$sf$view <- factor(atlas$data$sf$view, levels = order)
  new_sf <- atlas$data$sf[order(atlas$data$sf$view), ]
  new_sf$view <- as.character(new_sf$view)

  new_sf <- reposition_views(new_sf, gap = gap)
  new_data <- rebuild_atlas_data(atlas, new_sf)

  brain_atlas(
    atlas = atlas$atlas,
    type = atlas$type,
    palette = atlas$palette,
    core = atlas$core,
    data = new_data
  )
}


#' Reposition views horizontally
#' @keywords internal
#' @noRd
#' @importFrom sf st_geometry st_bbox st_coordinates
reposition_views <- function(sf_obj, gap = 0.15) {
  views <- unique(sf_obj$view)

  view_data <- lapply(views, function(v) {
    idx <- sf_obj$view == v
    sf_obj[idx, ]
  })

  view_data <- lapply(view_data, function(df) {
    bbox <- sf::st_bbox(df$geometry)
    center_x <- (bbox["xmin"] + bbox["xmax"]) / 2
    center_y <- (bbox["ymin"] + bbox["ymax"]) / 2
    df$geometry <- df$geometry - c(center_x, center_y)
    df
  })

  ranges <- lapply(view_data, function(df) {
    coords <- sf::st_coordinates(df$geometry)
    list(
      x_range = range(coords[, 1]),
      y_range = range(coords[, 2])
    )
  })

  widths <- vapply(ranges, function(r) diff(r$x_range), numeric(1))
  half_widths <- vapply(ranges, function(r) max(abs(r$x_range)), numeric(1))
  max_height <- max(vapply(ranges, function(r) max(abs(r$y_range)), numeric(1)))
  gap_size <- max(widths) * gap

  x_pos <- 0
  for (i in seq_along(view_data)) {
    x_offset <- x_pos + half_widths[i]
    view_data[[i]]$geometry <- view_data[[i]]$geometry + c(x_offset, max_height)
    x_pos <- x_pos + widths[i] + gap_size
  }

  result <- do.call(rbind, view_data)
  sf::st_as_sf(result)
}


#' Rebuild atlas data with new sf
#' @keywords internal
#' @noRd
rebuild_atlas_data <- function(atlas, new_sf) {
  if (!is.null(atlas$data$vertices)) {
    cortical_data(sf = new_sf, vertices = atlas$data$vertices)
  } else if (!is.null(atlas$data$meshes)) {
    subcortical_data(sf = new_sf, meshes = atlas$data$meshes)
  } else if (!is.null(atlas$data$tangents)) {
    tract_data(sf = new_sf, meshes = atlas$data$meshes, tangents = atlas$data$tangents)
  } else {
    atlas$data$sf <- new_sf
    atlas$data
  }
}
