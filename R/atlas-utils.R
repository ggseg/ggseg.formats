#' Extract unique region names from an atlas
#'
#' @param x brain atlas
#' @return Character vector of region names
#' @examples
#' atlas_regions(dk)
#' atlas_regions(aseg)
#'
#' @export
atlas_regions <- function(x) {
  UseMethod("atlas_regions")
}

#' @export
atlas_regions.ggseg_atlas <- function(x) {
  get_uniq(x$core, "region")
}

#' @export
atlas_regions.brain_atlas <- function(x) {
  get_uniq(x$core, "region")
}

#' @export
atlas_regions.data.frame <- function(x) {
  get_uniq(x, "region")
}


#' @keywords internal
#' @noRd
get_uniq <- function(x, type) {
  type <- match.arg(type, c("label", "region"))
  x <- unique(x[[type]])
  x <- x[!is.na(x)]
  x[order(x)]
}

#' Extract unique labels from an atlas
#'
#' @param x brain atlas
#' @return Character vector of atlas region labels
#' @examples
#' atlas_labels(dk)
#' atlas_labels(aseg)
#'
#' @export
atlas_labels <- function(x) {
  UseMethod("atlas_labels")
}

#' @export
atlas_labels.ggseg_atlas <- function(x) {
  get_uniq(x$core, "label")
}

#' @export
atlas_labels.brain_atlas <- function(x) {
  get_uniq(x$core, "label")
}


#' @rdname atlas_regions
#' @export
brain_regions <- function(x) {
  lifecycle::deprecate_warn(
    "0.1.0",
    "brain_regions()",
    "atlas_regions()"
  )
  atlas_regions(x)
}

#' @rdname atlas_labels
#' @export
brain_labels <- function(x) {
  lifecycle::deprecate_warn(
    "0.1.0",
    "brain_labels()",
    "atlas_labels()"
  )
  atlas_labels(x)
}


#' Detect atlas type
#' @param x brain atlas object
#' @return Character string: "cortical", "subcortical", or "tract"
#' @examples
#' atlas_type(dk)
#' atlas_type(aseg)
#' atlas_type(tracula)
#'
#' @export
atlas_type <- function(x) {
  UseMethod("atlas_type")
}

#' @export
atlas_type.ggseg_atlas <- function(x) {
  guess_type(x)
}

#' @export
atlas_type.brain_atlas <- function(x) {
  guess_type(x)
}

#' @noRd
#' @keywords internal
guess_type <- function(x) {
  if ("type" %in% names(x) && !is.na(x$type[1])) {
    return(unique(x$type))
  }

  cli::cli_warn("Atlas type not set, attempting to guess type.")

  views <- if (is_ggseg_atlas(x) && !is.null(x$sf)) {
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


# Atlas manipulation functions ----

#' Manipulate brain atlas regions and views
#'
#' Functions for modifying brain atlas objects. These cover three areas:
#'
#' **Region manipulation** modifies which regions are active in the atlas:
#' - `atlas_region_remove()`: completely remove regions
#' - `atlas_region_contextual()`: keep geometry but remove from core/palette
#' - `atlas_region_rename()`: rename regions in core
#' - `atlas_region_keep()`: keep only matching regions
#'
#' **View manipulation** modifies the 2D sf geometry data:
#' - `atlas_view_remove()`: remove entire views
#' - `atlas_view_keep()`: keep only matching views
#' - `atlas_view_remove_region()`: remove specific region geometry from sf
#' - `atlas_view_remove_small()`: remove small polygon fragments
#' - `atlas_view_gather()`: reposition views to close gaps
#' - `atlas_view_reorder()`: change view order
#'
#' **Core manipulation** modifies atlas metadata:
#' - `atlas_core_add()`: join additional metadata columns
#'
#' @param atlas A `ggseg_atlas` object
#' @param pattern Character pattern to match. Uses
#'   `grepl(..., ignore.case = TRUE)`.
#' @param match_on Column to match against: `"region"` or `"label"`.
#' @param replacement For `atlas_region_rename()`: replacement string or
#'   function.
#' @param views For view functions: character vector of view names or
#'   patterns. Multiple values collapsed with `"|"` for matching.
#' @param order For `atlas_view_reorder()`: character vector of desired
#'   view order. Unspecified views appended at end.
#' @param min_area For `atlas_view_remove_small()`: minimum polygon
#'   area to keep. Context geometries are never removed.
#' @param gap Proportional gap between views (default 0.15 = 15% of max width).
#' @param data For `atlas_core_add()`: data.frame with metadata to join.
#' @param by For `atlas_core_add()`: column(s) to join by. Default `"region"`.
#'
#' @return Modified `ggseg_atlas` object
#'
#' @examples
#' dk |>
#'   atlas_region_remove("bankssts") |>
#'   atlas_region_keep("frontal", match_on = "region")
#'
#' @name atlas_manipulation
#' @export
atlas_region_remove <- function(
  atlas,
  pattern,
  match_on = c("region", "label")
) {
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
    new_data <- ggseg_data_cortical(
      sf = new_sf,
      vertices = new_vertices
    )
  } else if (!is.null(atlas$data$meshes)) {
    new_meshes <- atlas$data$meshes[
      !atlas$data$meshes$label %in% labels_to_remove,
      ,
      drop = FALSE
    ]
    new_data <- ggseg_data_subcortical(
      sf = new_sf,
      meshes = new_meshes
    )
  } else {
    new_data <- atlas$data
    if (!is.null(new_sf)) {
      new_data$sf <- new_sf
    }
  }

  ggseg_atlas(
    atlas = atlas$atlas,
    type = atlas$type,
    palette = new_palette,
    core = new_core,
    data = new_data
  )
}


#' @describeIn atlas_manipulation Keep geometry for visual context but remove
#'   from core, palette, and 3D data. Context geometries render grey and don't
#'   appear in legends.
#' @export
atlas_region_contextual <- function(
  atlas,
  pattern,
  match_on = c("region", "label")
) {
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
    new_data <- ggseg_data_cortical(
      sf = atlas$data$sf,
      vertices = new_vertices
    )
  } else if (!is.null(atlas$data$meshes)) {
    new_meshes <- atlas$data$meshes[
      !atlas$data$meshes$label %in% labels_to_remove,
      ,
      drop = FALSE
    ]
    new_data <- ggseg_data_subcortical(
      sf = atlas$data$sf,
      meshes = new_meshes
    )
  } else {
    new_data <- atlas$data
  }

  ggseg_atlas(
    atlas = atlas$atlas,
    type = atlas$type,
    palette = new_palette,
    core = new_core,
    data = new_data
  )
}


#' @describeIn atlas_manipulation Rename regions matching a pattern. Only
#'   affects the `region` column, not `label`. If `replacement` is a function,
#'   it receives matched names and returns new names.
#' @export
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

  ggseg_atlas(
    atlas = atlas$atlas,
    type = atlas$type,
    palette = atlas$palette,
    core = new_core,
    data = atlas$data
  )
}


#' @describeIn atlas_manipulation Keep only matching regions. Non-matching
#'   regions are removed from core, palette, and 3D data but sf geometry
#'   is preserved for surface continuity.
#' @export
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
    new_data <- ggseg_data_cortical(
      sf = atlas$data$sf,
      vertices = new_vertices
    )
  } else if (!is.null(atlas$data$meshes)) {
    new_meshes <- atlas$data$meshes[
      atlas$data$meshes$label %in% labels_to_keep,
      ,
      drop = FALSE
    ]
    new_data <- ggseg_data_subcortical(
      sf = atlas$data$sf,
      meshes = new_meshes
    )
  } else {
    new_data <- atlas$data
  }

  ggseg_atlas(
    atlas = atlas$atlas,
    type = atlas$type,
    palette = new_palette,
    core = new_core,
    data = new_data
  )
}


#' @describeIn atlas_manipulation Join additional metadata columns to
#'   atlas core.
#' @export
atlas_core_add <- function(atlas, data, by = "region") {
  new_core <- dplyr::left_join(atlas$core, data, by = by)

  ggseg_atlas(
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
#' @param atlas A `ggseg_atlas` object
#' @return Character vector of view names, or NULL if no sf data
#' @examples
#' atlas_views(aseg)
#' atlas_views(tracula)
#'
#' @export
atlas_views <- function(atlas) {
  if (is.null(atlas$data$sf)) {
    return(NULL)
  }
  unique(atlas$data$sf$view)
}

#' @rdname atlas_views
#' @export
brain_views <- function(atlas) {
  lifecycle::deprecate_warn(
    "0.1.0",
    "brain_views()",
    "atlas_views()"
  )
  atlas_views(atlas)
}


#' @describeIn atlas_manipulation Remove views matching pattern from sf data.
#' @export
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
  rebuild_atlas(atlas, new_data)
}


#' @describeIn atlas_manipulation Keep only views matching pattern.
#' @export
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
  rebuild_atlas(atlas, new_data)
}


#' @describeIn atlas_manipulation Remove specific region geometry from sf
#'   data only. Core, palette, and 3D data are unchanged.
#' @export
atlas_view_remove_region <- function(
  atlas,
  pattern,
  match_on = c("label", "region"),
  views = NULL
) {
  match_on <- match.arg(match_on)

  if (is.null(atlas$data$sf)) {
    cli::cli_warn("Atlas has no sf data, nothing to remove")
    return(atlas)
  }

  if (match_on == "region") {
    match_col <- atlas$core$region
    hit <- grepl(pattern, match_col, ignore.case = TRUE) & !is.na(match_col)
    labels_to_remove <- atlas$core$label[hit]
    is_match <- atlas$data$sf$label %in% labels_to_remove
  } else {
    is_match <- grepl(pattern, atlas$data$sf$label, ignore.case = TRUE)
  }

  if (!is.null(views)) {
    view_pattern <- paste(views, collapse = "|")
    in_view <- grepl(view_pattern, atlas$data$sf$view, ignore.case = TRUE)
    is_match <- is_match & in_view
  }

  is_match[is.na(atlas$data$sf$label)] <- FALSE
  new_sf <- atlas$data$sf[!is_match, , drop = FALSE]

  if (nrow(new_sf) == 0) {
    cli::cli_warn("All region geometries removed, sf data will be NULL")
    new_sf <- NULL
  }

  new_data <- rebuild_atlas_data(atlas, new_sf)
  rebuild_atlas(atlas, new_data)
}


#' @describeIn atlas_manipulation Remove region geometries below a minimum
#'   area threshold. Context geometries (labels not in core) are never
#'   removed. Optionally scope to specific views.
#' @export
atlas_view_remove_small <- function(atlas, min_area, views = NULL) {
  if (is.null(atlas$data$sf)) {
    cli::cli_warn("Atlas has no sf data, nothing to remove")
    return(atlas)
  }

  areas <- as.numeric(sf::st_area(atlas$data$sf$geometry))
  is_context <- is.na(atlas$data$sf$label) |
    !atlas$data$sf$label %in% atlas$core$label
  is_small <- areas < min_area & !is_context

  if (!is.null(views)) {
    pattern <- paste(views, collapse = "|")
    in_view <- grepl(pattern, atlas$data$sf$view, ignore.case = TRUE)
    is_small <- is_small & in_view
  }

  n_removed <- sum(is_small)
  if (n_removed > 0) {
    cli::cli_alert_info(
      "Removed {n_removed} geometr{?y/ies} below area {min_area}"
    )
  }

  new_sf <- atlas$data$sf[!is_small, , drop = FALSE]
  new_data <- rebuild_atlas_data(atlas, new_sf)
  rebuild_atlas(atlas, new_data)
}


#' @describeIn atlas_manipulation Reposition remaining views to close gaps
#'   after view removal.
#' @export
atlas_view_gather <- function(atlas, gap = 0.15) {
  if (is.null(atlas$data$sf)) {
    cli::cli_warn("Atlas has no sf data")
    return(atlas)
  }

  new_sf <- reposition_views(atlas$data$sf, gap = gap)
  new_data <- rebuild_atlas_data(atlas, new_sf)
  rebuild_atlas(atlas, new_data)
}


#' @describeIn atlas_manipulation Reorder views and reposition. Views not
#'   in `order` are appended at end.
#' @export
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
  rebuild_atlas(atlas, new_data)
}


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


#' @keywords internal
#' @noRd
rebuild_atlas_data <- function(atlas, new_sf) {
  if (!is.null(atlas$data$vertices)) {
    ggseg_data_cortical(sf = new_sf, vertices = atlas$data$vertices)
  } else if (!is.null(atlas$data$meshes)) {
    ggseg_data_subcortical(sf = new_sf, meshes = atlas$data$meshes)
  } else if (!is.null(atlas$data$centerlines)) {
    ggseg_data_tract(sf = new_sf, centerlines = atlas$data$centerlines)
  } else {
    atlas$data$sf <- new_sf
    atlas$data
  }
}

#' @noRd
#' @keywords internal
rebuild_atlas <- function(atlas, new_data) {
  validate_data_labels(new_data, atlas$core, check_sf = FALSE)

  structure(
    list(
      atlas = atlas$atlas,
      type = atlas$type,
      palette = atlas$palette,
      core = atlas$core,
      data = new_data
    ),
    class = c(
      paste0(atlas$type, "_atlas"),
      "ggseg_atlas",
      "list"
    )
  )
}
