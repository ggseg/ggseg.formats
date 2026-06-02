#' Extract unique region names from an atlas
#'
#' @param x brain atlas
#' @return Character vector of region names
#' @examples
#' atlas_regions(dk())
#' atlas_regions(aseg())
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
#' atlas_labels(dk())
#' atlas_labels(aseg())
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
#' atlas_type(dk())
#' atlas_type(aseg())
#' atlas_type(tracula())
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
#' - `atlas_context_remove()`: drop all contextual sf geometry
#' - `atlas_region_rename()`: rename regions in core
#' - `atlas_region_keep()`: keep only matching regions
#' - `atlas_region_op()`: combine two regions' geometry with a boolean op
#'   (difference / intersection / union / symdifference)
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
#' @param ignore.case For `atlas_region_contextual()`: passed to [grepl()].
#'   Defaults to `TRUE` for backwards compatibility, but note that a context
#'   pattern like `"Thalamus"` then also matches focus labels such as
#'   `"hypothalamus"`; set `FALSE` (and/or anchor the pattern) when that
#'   matters.
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
#' dk() |>
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


#' Move contextual geometry rows behind core rows
#'
#' 2D geometry is drawn in row order, so contextual (non-core) regions must
#' come first to render behind the core regions they may overlap. Stable
#' within each group, preserving existing view order. Works on either an sf
#' data.frame (one row per label/view) or a `brain_polygons` tibble (one row
#' per label) — both carry a `label` column — so reordering needs no sf.
#'
#' @param geom An sf data.frame, a `brain_polygons` tibble, or NULL.
#' @param core_labels Character vector of labels still present in core.
#' @return Reordered geometry of the same class, or NULL if `geom` is NULL.
#' @noRd
order_context_behind <- function(geom, core_labels) {
  if (is.null(geom) || nrow(geom) == 0) {
    return(geom)
  }
  is_core <- geom$label %in% core_labels
  out <- geom[c(which(!is_core), which(is_core)), , drop = FALSE]
  if (inherits(geom, "brain_polygons") && !inherits(out, "brain_polygons")) {
    out <- structure(out, class = class(geom))
  }
  out
}


#' @describeIn atlas_manipulation Keep geometry for visual context but remove
#'   from core, palette, and 3D data. Context geometries render grey and don't
#'   appear in legends. Contextual rows are moved behind the remaining core
#'   regions so focus regions draw on top where they overlap in projection.
#'   Operates on whichever 2D representation the atlas carries (`sf` and/or
#'   `polygons`), keeping both in sync, and needs no `sf` for a polygon atlas.
#' @export
atlas_region_contextual <- function(
  atlas,
  pattern,
  match_on = c("region", "label"),
  ignore.case = TRUE
) {
  match_on <- match.arg(match_on)

  match_col <- atlas$core[[match_on]]
  keep_mask <- !grepl(pattern, match_col, ignore.case = ignore.case)
  keep_mask[is.na(match_col)] <- TRUE

  labels_to_remove <- atlas$core$label[!keep_mask]

  new_core <- atlas$core[keep_mask, , drop = FALSE]
  new_palette <- atlas$palette[!names(atlas$palette) %in% labels_to_remove]

  # Draw contextual regions behind core regions: 2D geometry renders in row
  # order, so move every row whose label is no longer in core (the regions
  # just made contextual, plus pipeline outlines like `cortex`/`Background`)
  # ahead of the core rows. This keeps focus regions on top where context
  # structures spatially overlap them in projection. Reorder both 2D
  # representations identically so they stay in sync without invoking sf.
  new_sf <- order_context_behind(atlas$data$sf, new_core$label)
  new_poly <- order_context_behind(atlas$data$polygons, new_core$label)

  if (!is.null(atlas$data$vertices)) {
    new_vertices <- atlas$data$vertices[
      !atlas$data$vertices$label %in% labels_to_remove,
      ,
      drop = FALSE
    ]
    new_data <- ggseg_data_cortical(
      sf = new_sf,
      polygons = new_poly,
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
      polygons = new_poly,
      meshes = new_meshes
    )
  } else {
    new_data <- atlas$data
    new_data$sf <- new_sf
    new_data$polygons <- new_poly
  }

  validate_data_labels(new_data, new_core, check_sf = FALSE)

  structure(
    list(
      atlas = atlas$atlas,
      type = atlas$type,
      palette = new_palette,
      core = new_core,
      data = new_data
    ),
    class = class(atlas)
  )
}


#' @describeIn atlas_manipulation Combine two sets of region geometry with a
#'   vector boolean operation (per view), writing the result to a new region
#'   `into`. `x` and `y` are patterns matched against `match_on`; within each
#'   view their matching geometries are unioned, then combined via `action`:
#'   `"difference"` (x minus y, e.g. punching white matter out of a cortex
#'   silhouette), `"intersection"`, `"union"`, or `"symdifference"`. Inputs are
#'   left in place; any existing `into` geometry is replaced. With a `colour`,
#'   `into` becomes a legended core region; otherwise it stays contextual
#'   (grey) and is drawn behind the core regions. Boolean ops need a geometry
#'   engine, so this is the one manipulation helper that always requires `sf`
#'   installed; a polygon-only atlas is rehydrated for the operation and the
#'   result is returned in polygon form.
#' @param x,y For `atlas_region_op()`: patterns selecting the two operands.
#' @param action For `atlas_region_op()`: the boolean operation to apply.
#' @param into For `atlas_region_op()`: label for the result region.
#' @param colour For `atlas_region_op()`: optional fill for `into`. When
#'   supplied, `into` is registered in core and palette; when `NULL`, the
#'   result is contextual geometry only.
#' @export
atlas_region_op <- function(
  atlas,
  x,
  y,
  action = c("difference", "intersection", "union", "symdifference"),
  into,
  match_on = c("label", "region"),
  colour = NULL
) {
  action <- match.arg(action)
  match_on <- match.arg(match_on)
  # Boolean geometry ops need a geometry engine (GEOS, via sf); there is no
  # pure-polygon equivalent. A polygon-only atlas is rehydrated to sf for the
  # operation and the result is converted back, so the atlas keeps its
  # original 2D format.
  require_sf("atlas_region_op()")

  if (missing(into) || !is.character(into) || length(into) != 1) {
    cli::cli_abort("{.arg into} must be a single label for the result region.")
  }

  was_polygon_only <- is.null(atlas$data$sf)
  sf_data <- atlas$data$sf
  if (is.null(sf_data)) {
    if (is.null(atlas$data$polygons)) {
      cli::cli_abort("Atlas has no 2D geometry to operate on.")
    }
    sf_data <- polygons_to_sf(atlas$data$polygons)
  }
  geom_col <- attr(sf_data, "sf_column")

  label_for <- function(pattern) {
    if (match_on == "region") {
      hit <- grepl(pattern, atlas$core$region, ignore.case = TRUE) &
        !is.na(atlas$core$region)
      atlas$core$label[hit]
    } else {
      unique(sf_data$label[grepl(pattern, sf_data$label, ignore.case = TRUE)])
    }
  }
  x_labels <- label_for(x)
  y_labels <- label_for(y)

  combine <- switch(
    action,
    difference = sf::st_difference,
    intersection = sf::st_intersection,
    union = function(a, b) sf::st_union(c(a, b)),
    symdifference = sf::st_sym_difference
  )

  template <- sf_data[sf_data$label %in% x_labels, , drop = FALSE][
    0,
    ,
    drop = FALSE
  ]
  result_rows <- lapply(unique(sf_data$view), function(v) {
    in_view <- sf_data$view == v
    gx <- sf_data[[geom_col]][in_view & sf_data$label %in% x_labels]
    gy <- sf_data[[geom_col]][in_view & sf_data$label %in% y_labels]
    if (length(gx) == 0) {
      return(NULL)
    }
    gx <- sf::st_union(sf::st_make_valid(gx))
    geom <- if (length(gy) > 0) {
      combine(gx, sf::st_union(sf::st_make_valid(gy)))
    } else if (action == "intersection") {
      gx[0]
    } else {
      gx
    }
    geom <- sf::st_make_valid(geom)
    if (length(geom) == 0 || all(sf::st_is_empty(geom))) {
      return(NULL)
    }
    row <- template[1, , drop = FALSE]
    row$label <- into
    row$view <- v
    geom <- sf::st_union(geom)
    sf::st_crs(geom) <- sf::st_crs(sf_data)
    sf::st_geometry(row) <- geom
    row
  })
  result <- do.call(rbind, result_rows)
  if (is.null(result) || nrow(result) == 0) {
    cli::cli_abort("{.arg action} produced no geometry for {.val {into}}.")
  }

  new_sf <- rbind(sf_data[sf_data$label != into, , drop = FALSE], result)

  new_core <- atlas$core
  new_palette <- atlas$palette
  if (!is.null(colour)) {
    if (!into %in% new_core$label) {
      core_row <- new_core[1, , drop = FALSE]
      core_row[] <- NA
      core_row$label <- into
      if ("region" %in% names(core_row)) {
        core_row$region <- into
      }
      new_core <- rbind(new_core, core_row)
    }
    new_palette[[into]] <- colour
  }

  # Context regions (not in core) draw behind core regions; keep that order.
  new_sf <- order_context_behind(new_sf, new_core$label)

  new_data <- rebuild_atlas_data(atlas, new_sf)
  if (was_polygon_only) {
    new_data$sf <- NULL
  }
  validate_data_labels(new_data, new_core, check_sf = FALSE)
  structure(
    list(
      atlas = atlas$atlas,
      type = atlas$type,
      palette = new_palette,
      core = new_core,
      data = new_data
    ),
    class = class(atlas)
  )
}


#' @describeIn atlas_manipulation Drop all contextual sf geometry — every
#'   sf row whose `label` is not present in `core`. Covers labels marked
#'   via [atlas_region_contextual()] plus pipeline-generated outlines
#'   (`cortex_`, `Background`, `unknown`). Remaining views are re-packed
#'   via [atlas_view_gather()] so the plot focuses tightly on the
#'   labelled regions.
#' @export
atlas_context_remove <- function(atlas) {
  if (is.null(atlas$data$sf)) {
    return(atlas)
  }

  require_sf("atlas_context_remove()")
  keep_mask <- atlas$data$sf$label %in% atlas$core$label
  new_sf <- atlas$data$sf[keep_mask, , drop = FALSE]

  new_data <- rebuild_atlas_data(atlas, new_sf)
  atlas_view_gather(rebuild_atlas(atlas, new_data))
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
#' atlas_views(aseg())
#' atlas_views(tracula())
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


#' @describeIn atlas_manipulation Remove views matching pattern from sf
#'   data. Remaining views are re-packed via [atlas_view_gather()] so
#'   the layout stays tight.
#' @export
atlas_view_remove <- function(atlas, views) {
  if (is.null(atlas$data$sf)) {
    cli::cli_warn("Atlas has no sf data, nothing to remove")
    return(atlas)
  }

  require_sf("atlas_view_remove()")
  pattern <- paste(views, collapse = "|")
  keep_mask <- !grepl(pattern, atlas$data$sf$view, ignore.case = TRUE)
  new_sf <- atlas$data$sf[keep_mask, , drop = FALSE]

  if (nrow(new_sf) == 0) {
    cli::cli_warn("All views removed, sf data will be NULL")
    new_sf <- NULL
  }

  new_data <- rebuild_atlas_data(atlas, new_sf)
  atlas_view_gather(rebuild_atlas(atlas, new_data))
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
#'   data only. Core, palette, and 3D data are unchanged. Views are
#'   re-packed via [atlas_view_gather()] in case any view shrank.
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

  require_sf("atlas_view_remove_region()")

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
  atlas_view_gather(rebuild_atlas(atlas, new_data))
}


#' @describeIn atlas_manipulation Remove region geometries below a minimum
#'   area threshold. Context geometries (labels not in core) are never
#'   removed. Optionally scope to specific views. Views are re-packed
#'   via [atlas_view_gather()] in case any view shrank.
#' @export
atlas_view_remove_small <- function(atlas, min_area, views = NULL) {
  if (is.null(atlas$data$sf)) {
    cli::cli_warn("Atlas has no sf data, nothing to remove")
    return(atlas)
  }

  require_sf("atlas_view_remove_small()")
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
  atlas_view_gather(rebuild_atlas(atlas, new_data))
}


#' @describeIn atlas_manipulation Reposition remaining views to close gaps
#'   after view removal.
#' @export
atlas_view_gather <- function(atlas, gap = 0.15) {
  sf_data <- atlas$data$sf
  if (is.null(sf_data) || !inherits(sf_data, "sf") || nrow(sf_data) == 0) {
    if (is.null(sf_data)) {
      cli::cli_warn("Atlas has no sf data")
    }
    return(atlas)
  }

  new_sf <- reposition_views(sf_data, type = atlas$type, gap = gap)
  if (is.null(new_sf) || !inherits(new_sf, "sf")) {
    return(atlas)
  }
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

  if (atlas$type == "cortical") {
    hemi <- ifelse(
      grepl("^lh[_.]", atlas$data$sf$label),
      "left",
      ifelse(grepl("^rh[_.]", atlas$data$sf$label), "right", "")
    )
    group_key <- paste(hemi, atlas$data$sf$view)
    expanded_order <- unlist(lapply(order, function(v) {
      hemis <- unique(hemi[atlas$data$sf$view == v])
      hemis <- intersect(c("left", "right", ""), hemis)
      paste(hemis, v)
    }))
    group_key <- factor(group_key, levels = expanded_order)
    new_sf <- atlas$data$sf[order(group_key), ]
  } else {
    atlas$data$sf$view <- factor(atlas$data$sf$view, levels = order)
    new_sf <- atlas$data$sf[order(atlas$data$sf$view), ]
    new_sf$view <- as.character(new_sf$view)
  }

  new_sf <- reposition_views(new_sf, type = atlas$type, gap = gap)
  new_data <- rebuild_atlas_data(atlas, new_sf)
  rebuild_atlas(atlas, new_data)
}


#' @keywords internal
#' @noRd
reposition_views <- function(sf_obj, type = NULL, gap = 0.15) {
  if (!inherits(sf_obj, "sf") && !inherits(sf_obj, "data.frame")) {
    return(sf_obj)
  }
  if (is.null(sf_obj) || nrow(sf_obj) == 0) {
    return(sf_obj)
  }

  require_sf("reposition_views()")

  if (inherits(sf_obj$geometry, "sfc_GEOMETRY")) {
    sf_obj <- sf::st_cast(sf_obj, "MULTIPOLYGON")
  }

  group_key <- sf_obj$view

  if (identical(type, "cortical")) {
    hemi <- ifelse(
      grepl("^lh[_.]", sf_obj$label),
      "left",
      ifelse(grepl("^rh[_.]", sf_obj$label), "right", "")
    )
    group_key <- paste(hemi, sf_obj$view)
  }

  groups <- unique(group_key)

  view_data <- lapply(groups, function(g) {
    idx <- group_key == g
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
  if (!is.null(atlas$data$vertices) && !is.null(atlas$data$meshes)) {
    ggseg_data_cerebellar(
      sf = new_sf,
      vertices = atlas$data$vertices,
      meshes = atlas$data$meshes
    )
  } else if (!is.null(atlas$data$vertices)) {
    if (inherits(atlas$data, "ggseg_data_cerebellar")) {
      ggseg_data_cerebellar(sf = new_sf, vertices = atlas$data$vertices)
    } else {
      ggseg_data_cortical(sf = new_sf, vertices = atlas$data$vertices)
    }
  } else if (!is.null(atlas$data$meshes)) {
    ggseg_data_subcortical(sf = new_sf, meshes = atlas$data$meshes)
  } else if (!is.null(atlas$data$centerlines)) {
    ggseg_data_tract(sf = new_sf, centerlines = atlas$data$centerlines)
  } else {
    # 2D-only atlas: keep both representations in sync rather than leaving
    # a stale polygons slot behind the freshly assigned sf.
    atlas$data$sf <- new_sf
    atlas$data$polygons <- if (is.null(new_sf)) NULL else sf_to_polygons(new_sf)
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
