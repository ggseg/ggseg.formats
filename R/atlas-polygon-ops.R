# Pure-R polygon view operations ----
#
# Filtering, area, and repositioning on the `brain_polygons` representation,
# implemented without sf so the atlas-view helpers work on polygon-only
# atlases (no GDAL/GEOS/PROJ). All operate on the flat coordinate table
# (`label`, `view`, `x`, `y`, `group`, `subgroup`) obtained by unnesting.

#' Unnest a brain_polygons to its flat coordinate table
#' @noRd
#' @keywords internal
polygons_unnest <- function(polygons) {
  tidyr::unnest(dplyr::as_tibble(polygons), cols = "geometry")
}


#' Re-nest a flat coordinate table back into brain_polygons
#'
#' Keeps only the canonical columns and nests by `label`. Returns NULL for an
#' empty table so callers can treat "all geometry removed" as no 2D data.
#' @noRd
#' @keywords internal
polygons_renest <- function(flat) {
  if (is.null(flat) || nrow(flat) == 0) {
    return(NULL)
  }
  flat <- flat[, c("label", "view", "x", "y", "group", "subgroup")]
  out <- tidyr::nest(dplyr::as_tibble(flat), geometry = -"label")
  structure(out, class = unique(c("brain_polygons", class(out))))
}


#' Keep only the given labels
#' @noRd
#' @keywords internal
polygons_keep_labels <- function(polygons, keep) {
  flat <- polygons_unnest(polygons)
  polygons_renest(flat[flat$label %in% keep, , drop = FALSE])
}


#' Drop labels matching a regex pattern
#' @noRd
#' @keywords internal
polygons_drop_pattern <- function(polygons, pattern) {
  flat <- polygons_unnest(polygons)
  drop <- grepl(pattern, flat$label, ignore.case = TRUE)
  polygons_renest(flat[!drop, , drop = FALSE])
}


#' Filter geometry by view pattern (keep or remove the matches)
#' @noRd
#' @keywords internal
polygons_filter_view <- function(polygons, views, keep) {
  flat <- polygons_unnest(polygons)
  pattern <- paste(views, collapse = "|")
  match <- grepl(pattern, flat$view, ignore.case = TRUE)
  polygons_renest(flat[if (keep) match else !match, , drop = FALSE])
}


#' Remove geometry for a set of labels, optionally scoped to views
#' @noRd
#' @keywords internal
polygons_remove_region <- function(polygons, drop_labels, views = NULL) {
  flat <- polygons_unnest(polygons)
  is_match <- flat$label %in% drop_labels
  if (!is.null(views)) {
    view_pattern <- paste(views, collapse = "|")
    is_match <- is_match & grepl(view_pattern, flat$view, ignore.case = TRUE)
  }
  polygons_renest(flat[!is_match, , drop = FALSE])
}


#' Drop labels matching a pattern from either geometry representation
#'
#' Class-dispatching wrapper: `brain_polygons` go through
#' `polygons_drop_pattern()` (sf-free), sf geometry is row-filtered on `label`.
#' @noRd
#' @keywords internal
geom_drop_pattern <- function(geom, pattern) {
  if (is.null(geom)) {
    return(NULL)
  }
  if (inherits(geom, "brain_polygons")) {
    return(polygons_drop_pattern(geom, pattern))
  }
  geom[!grepl(pattern, geom$label, ignore.case = TRUE), , drop = FALSE]
}


#' Shoelace area of a single ring
#' @noRd
#' @keywords internal
polygon_ring_area <- function(x, y) {
  n <- length(x)
  if (n < 3) {
    return(0)
  }
  abs(sum(x * c(y[-1], y[1]) - c(x[-1], x[1]) * y)) / 2
}


#' Area per label x view (exterior minus holes, summed over disjoint pieces)
#'
#' Mirrors `sf::st_area()` on each MULTIPOLYGON row: within a `group` the
#' lowest `subgroup` is the exterior ring and the rest are holes.
#' @noRd
#' @keywords internal
polygon_geometry_areas <- function(flat) {
  lv <- unique(flat[, c("label", "view")])
  ring_area_of <- function(piece, ring) {
    idx <- piece$subgroup == ring
    polygon_ring_area(piece$x[idx], piece$y[idx])
  }
  lv$area <- vapply(
    seq_len(nrow(lv)),
    function(k) {
      sub <- flat[flat$label == lv$label[k] & flat$view == lv$view[k], ]
      total <- 0
      for (g in unique(sub$group)) {
        piece <- sub[sub$group == g, ]
        rings <- unique(piece$subgroup)
        ext <- min(rings)
        holes <- setdiff(rings, ext)
        a_holes <- sum(vapply(
          holes,
          function(r) ring_area_of(piece, r),
          numeric(1)
        ))
        total <- total + ring_area_of(piece, ext) - a_holes
      }
      total
    },
    numeric(1)
  )
  lv
}


#' Drop region geometries below an area threshold
#'
#' Context geometries (labels not in `core_labels`) are never removed.
#' Returns a list of the new polygons and the count of geometries removed.
#' @noRd
#' @keywords internal
polygons_remove_small <- function(
  polygons,
  min_area,
  core_labels,
  views = NULL
) {
  flat <- polygons_unnest(polygons)
  areas <- polygon_geometry_areas(flat)

  is_small <- areas$area < min_area & areas$label %in% core_labels
  if (!is.null(views)) {
    view_pattern <- paste(views, collapse = "|")
    is_small <- is_small &
      grepl(view_pattern, areas$view, ignore.case = TRUE)
  }
  small <- areas[is_small, c("label", "view"), drop = FALSE]

  flat_key <- paste(flat$label, flat$view, sep = "\r")
  small_key <- paste(small$label, small$view, sep = "\r")
  kept <- flat[!flat_key %in% small_key, , drop = FALSE]

  list(polygons = polygons_renest(kept), n_removed = nrow(small))
}


#' Reposition view groups left-to-right on a flat coordinate table
#'
#' Pure-R equivalent of `reposition_views()`: centre each view group on the
#' origin, then lay groups out horizontally with a proportional gap.
#' `group_order` lets callers (e.g. reorder) pin the left-to-right sequence.
#' @noRd
#' @keywords internal
reposition_flat <- function(flat, type = NULL, gap = 0.15, group_order = NULL) {
  group_key <- flat$view
  if (identical(type, "cortical")) {
    hemi <- ifelse(
      grepl("^lh[_.]", flat$label),
      "left",
      ifelse(grepl("^rh[_.]", flat$label), "right", "")
    )
    group_key <- paste(hemi, flat$view)
  }

  groups <- if (is.null(group_order)) {
    unique(group_key)
  } else {
    group_order[group_order %in% group_key]
  }

  for (g in groups) {
    idx <- which(group_key == g)
    center_x <- (min(flat$x[idx]) + max(flat$x[idx])) / 2
    center_y <- (min(flat$y[idx]) + max(flat$y[idx])) / 2
    flat$x[idx] <- flat$x[idx] - center_x
    flat$y[idx] <- flat$y[idx] - center_y
  }

  widths <- numeric(length(groups))
  half_widths <- numeric(length(groups))
  max_height <- 0
  for (i in seq_along(groups)) {
    idx <- which(group_key == groups[i])
    x_range <- range(flat$x[idx])
    y_range <- range(flat$y[idx])
    widths[i] <- diff(x_range)
    half_widths[i] <- max(abs(x_range))
    max_height <- max(max_height, max(abs(y_range)))
  }
  gap_size <- max(widths) * gap

  x_pos <- 0
  for (i in seq_along(groups)) {
    idx <- which(group_key == groups[i])
    x_offset <- x_pos + half_widths[i]
    flat$x[idx] <- flat$x[idx] + x_offset
    flat$y[idx] <- flat$y[idx] + max_height
    x_pos <- x_pos + widths[i] + gap_size
  }

  flat
}


#' Reposition a brain_polygons object
#' @noRd
#' @keywords internal
reposition_polygons <- function(polygons, type = NULL, gap = 0.15) {
  flat <- polygons_unnest(polygons)
  if (nrow(flat) == 0) {
    return(polygons)
  }
  polygons_renest(reposition_flat(flat, type = type, gap = gap))
}


#' Reorder view groups, then reposition
#' @noRd
#' @keywords internal
reorder_polygons <- function(polygons, order, type = NULL, gap = 0.15) {
  flat <- polygons_unnest(polygons)
  current_views <- unique(flat$view)
  order <- c(order, setdiff(current_views, order))
  order <- order[order %in% current_views]

  if (identical(type, "cortical")) {
    hemi <- ifelse(
      grepl("^lh[_.]", flat$label),
      "left",
      ifelse(grepl("^rh[_.]", flat$label), "right", "")
    )
    group_order <- unlist(lapply(order, function(v) {
      hemis <- intersect(c("left", "right", ""), unique(hemi[flat$view == v]))
      paste(hemis, v)
    }))
  } else {
    group_order <- order
  }

  polygons_renest(reposition_flat(
    flat,
    type = type,
    gap = gap,
    group_order = group_order
  ))
}
