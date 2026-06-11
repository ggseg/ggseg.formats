#' Constructor for ggseg atlas
#'
#' Creates an object of class 'ggseg_atlas' for plotting brain parcellations
#' using ggseg (2D) and ggseg3d (3D).
#'
#' @param atlas atlas short name, length one
#' @param type atlas type: "cortical", "subcortical", "tract", or "cerebellar"
#' @param palette named character vector of colours keyed by label
#' @param core data.frame with required columns hemi, region, label (one row per
#'   unique region). May contain additional columns for grouping or metadata
#'   (e.g., lobe, network, Brodmann area).
#' @param data a ggseg_atlas_data object created by
#'   [ggseg_data_cortical()], [ggseg_data_subcortical()],
#'   [ggseg_data_tract()], or [ggseg_data_cerebellar()].
#'   Must match the specified type.
#'
#' @return an object of class 'ggseg_atlas'
#' @export
#'
#' @examples
#' core <- data.frame(
#'   hemi = c("left", "left"),
#'   region = c("region1", "region2"),
#'   label = c("lh_region1", "lh_region2")
#' )
#' vertices <- data.frame(
#'   label = c("lh_region1", "lh_region2"),
#'   vertices = I(list(c(1L, 2L, 3L), c(4L, 5L, 6L)))
#' )
#' atlas <- ggseg_atlas(
#'   atlas = "test",
#'   type = "cortical",
#'   core = core,
#'   data = ggseg_data_cortical(vertices = vertices)
#' )
ggseg_atlas <- function(atlas, type, core, data, palette = NULL) {
  type <- match.arg(type, c("cortical", "subcortical", "tract", "cerebellar"))

  validate_ggseg_atlas_inputs(atlas, core, data, type)

  data <- validate_data_labels(data, core, check_sf = TRUE)

  if (!is.null(palette)) {
    palette <- validate_palette(palette, core)
  }

  structure(
    list(
      atlas = atlas,
      type = type,
      palette = palette,
      core = core,
      data = data
    ),
    class = c(
      paste0(type, "_atlas"),
      "ggseg_atlas",
      "list"
    )
  )
}


#' @rdname ggseg_atlas
#' @export
brain_atlas <- function(atlas, type, core, data, palette = NULL) {
  lifecycle::deprecate_warn(
    "0.2.0",
    "brain_atlas()",
    "ggseg_atlas()"
  )
  ggseg_atlas(
    atlas = atlas,
    type = type,
    core = core,
    data = data,
    palette = palette
  )
}


#' Check ggseg atlas class
#'
#' These functions check both the class tag and structural validity
#' by passing the object through [ggseg_atlas()]. An object that
#' carries the right class but fails validation returns `FALSE`.
#'
#' @param x an object
#' @return logical
#' @name is_ggseg_atlas
#' @export
#' @examples
#' is_ggseg_atlas(dk())
#' is_cortical_atlas(dk())
#' is_subcortical_atlas(aseg())
#' is_tract_atlas(tracula())
is_ggseg_atlas <- function(x) {
  is_atlas_class(x) && validate_ggseg_atlas(x)
}

#' @rdname is_ggseg_atlas
#' @export
is_cortical_atlas <- function(x) {
  inherits(x, "cortical_atlas") && validate_ggseg_atlas(x)
}

#' @rdname is_ggseg_atlas
#' @export
is_subcortical_atlas <- function(x) {
  inherits(x, "subcortical_atlas") && validate_ggseg_atlas(x)
}

#' @rdname is_ggseg_atlas
#' @export
is_tract_atlas <- function(x) {
  inherits(x, "tract_atlas") && validate_ggseg_atlas(x)
}

#' @rdname is_ggseg_atlas
#' @export
is_cerebellar_atlas <- function(x) {
  inherits(x, "cerebellar_atlas") && validate_ggseg_atlas(x)
}

#' @rdname is_ggseg_atlas
#' @export
is_brain_atlas <- function(x) {
  lifecycle::deprecate_warn(
    "0.2.0",
    "is_brain_atlas()",
    "is_ggseg_atlas()"
  )
  is_ggseg_atlas(x)
}

#' Check if object is a legacy ggseg3d atlas
#'
#' @param x an object
#' @return logical
#' @export
#' @examples
#' is_ggseg3d_atlas(dk())
is_ggseg3d_atlas <- function(x) {
  is.data.frame(x) && "ggseg_3d" %in% names(x)
}


#' @export
#' @importFrom stats na.omit
print.ggseg_atlas <- function(x, n = 10, ...) {
  data <- x$data
  geom <- geom_from_data(data)
  has_sf <- !is.null(geom)
  has_3d <- !is.null(data$vertices) ||
    !is.null(data$meshes) ||
    !is.null(data$centerlines)

  print_atlas_summary(x, has_sf)
  print_atlas_rendering(x, data, has_sf, has_3d)

  cli::cli_rule()

  core <- x$core
  print(utils::head(as.data.frame(core), n), ...)
  if (nrow(core) > n) {
    cli::cli_text("{.emph ... with {nrow(core) - n} more rows}")
  }

  invisible(x)
}


#' @export
as.list.ggseg_atlas <- function(x, ...) {
  list(
    atlas = x$atlas,
    type = x$type,
    palette = x$palette,
    core = x$core,
    data = x$data
  )
}


#' @export
as.data.frame.ggseg_atlas <- function(x, ...) {
  sf_data <- as_sf_for_data_frame(x)
  result <- merge_core_into_sf(sf_data, x$core)

  if (x$type == "cortical") {
    result <- infer_cortical_hemi(result)
  }

  result$atlas <- x$atlas
  result$type <- x$type

  if (!is.null(x$palette)) {
    result$colour <- unname(x$palette[result$label])
  }

  is_context <- !result$label %in% x$core$label | is.na(result$label)
  result <- result[order(is_context, decreasing = TRUE), , drop = FALSE]

  sf::st_as_sf(result)
}

#' @importFrom graphics mtext par plot.new plot.window polygon polypath
#' @export
plot.ggseg_atlas <- function(x, ...) {
  flat <- polygons_unnest(atlas_polygons(x))
  fill_colors <- resolve_fill_colors(flat$label, x$palette)
  dots <- list(...)

  # One panel per spatially separate piece, arranged in a near-square grid so
  # each gets enough room to read. This is a quick overview of the atlas, not a
  # publication figure.
  cell <- plot_cells(flat)
  cells <- sort(unique(cell))
  ncol <- ceiling(sqrt(length(cells)))
  nrow <- ceiling(length(cells) / ncol)
  cell_tables <- split(flat, cell)

  old_par <- par(
    mfrow = c(nrow, ncol),
    mar = c(0.3, 0.3, 0.3, 0.3),
    oma = c(0, 0, 2, 0)
  )
  on.exit(par(old_par), add = TRUE)

  for (ci in cells) {
    cf <- cell_tables[[as.character(ci)]]
    plot.new()
    plot.window(
      xlim = range(cf$x, na.rm = TRUE),
      ylim = range(cf$y, na.rm = TRUE),
      asp = 1
    )
    # `view` in the key keeps a region's per-view instances from being joined.
    piece_id <- paste(cf$label, cf$view, cf$group, sep = "\r")
    invisible(lapply(split(cf, piece_id), function(piece) {
      draw_piece(piece, fill_colors[[piece$label[[1L]]]], dots)
    }))
  }

  mtext(paste(x$atlas, x$type, "atlas"), outer = TRUE, cex = 1, line = 0.5)

  invisible(x)
}


#' Lightweight class check for atlas-classed objects
#'
#' `TRUE` when `x` carries the `ggseg_atlas` or legacy `brain_atlas` class
#' tag, without the structural revalidation that [is_ggseg_atlas()] performs.
#' @noRd
#' @keywords internal
is_atlas_class <- function(x) {
  inherits(x, "ggseg_atlas") || inherits(x, "brain_atlas")
}


#' @keywords internal
#' @noRd
validate_ggseg_atlas <- function(x) {
  tryCatch(
    {
      ggseg_atlas(
        atlas = x$atlas,
        type = x$type,
        core = x$core,
        data = x$data,
        palette = x$palette
      )
      TRUE
    },
    error = function(e) FALSE
  )
}


#' Resolve an atlas's 2D geometry to a non-empty sf data frame
#'
#' Used by `as.data.frame.ggseg_atlas()`. Aborts when there is no 2D geometry
#' (or it is empty) and requires sf.
#' @noRd
#' @keywords internal
as_sf_for_data_frame <- function(x) {
  geom <- if (inherits(x$data, "ggseg_atlas_data")) {
    geom_from_data(x$data)
  } else {
    NULL
  }
  has_2d_slot <- !is.null(geom) ||
    inherits(x$data, "sf") ||
    inherits(x$data, "data.frame")
  if (!has_2d_slot) {
    cli::cli_abort("Cannot convert ggseg_atlas to data.frame: no 2D geometry.")
  }
  require_sf("as.data.frame.ggseg_atlas()")

  sf_data <- if (!is.null(geom)) {
    sf::st_as_sf(
      if (inherits(geom, "brain_polygons")) polygons_to_sf(geom) else geom
    )
  } else {
    sf::st_as_sf(x$data)
  }

  if (nrow(sf_data) == 0) {
    cli::cli_abort("Cannot convert ggseg_atlas to data.frame: no 2D geometry.")
  }
  sf_data
}


#' Merge atlas `core` metadata into the sf geometry by label
#'
#' Returns the sf data unchanged when `core` is `NULL`. Preserves an sf-side
#' `hemi` column to fill gaps left by the join.
#' @noRd
#' @keywords internal
merge_core_into_sf <- function(sf_data, core) {
  if (is.null(core)) {
    return(sf_data)
  }
  has_sf_hemi <- "hemi" %in% names(sf_data)
  if (has_sf_hemi) {
    sf_data$.sf_hemi <- sf_data$hemi
  }
  core_cols <- c("hemi", "region")
  if (any(core_cols %in% names(sf_data))) {
    sf_data[core_cols] <- NULL
  }
  result <- merge(sf_data, core, by = "label", all.x = TRUE)
  if (has_sf_hemi) {
    missing <- is.na(result$hemi) & !is.na(result$.sf_hemi)
    if (any(missing)) {
      result$hemi[missing] <- result$.sf_hemi[missing]
    }
    result$.sf_hemi <- NULL
  }
  result
}


#' Infer missing hemispheres from `lh`/`rh` label prefixes (cortical atlases)
#'
#' Rows whose hemisphere cannot be determined are dropped.
#' @noRd
#' @keywords internal
infer_cortical_hemi <- function(result) {
  if (!"hemi" %in% names(result)) {
    result$hemi <- NA_character_
  }
  missing_hemi <- is.na(result$hemi)
  if (any(missing_hemi)) {
    result$hemi[missing_hemi] <- hemi_from_label(
      result$label[missing_hemi],
      default = NA_character_
    )
  }
  still_missing <- is.na(result$hemi)
  if (any(still_missing)) {
    result <- result[!still_missing, , drop = FALSE]
  }
  result
}

#' Resolve per-label fill colours for plotting
#'
#' Palette entries win where present and non-NA; labels with no palette entry
#' (or an `NA` entry) fall back to grey. With no palette at all, qualitative
#' `hcl()` colours are generated across the label set. Pure and deterministic
#' so the colour logic can be tested without a graphics device.
#'
#' @param labels Character vector of region labels (deduplicated internally).
#' @param palette Optional named character vector of colours keyed by label.
#' @return Named character vector of colours, one per unique label.
#' @noRd
#' @keywords internal
resolve_fill_colors <- function(labels, palette = NULL) {
  labels <- unique(labels)

  if (!is.null(palette)) {
    vals <- palette[labels]
    matched <- !is.na(vals)
    return(stats::setNames(ifelse(matched, vals, "#CCCCCC"), labels))
  }

  n <- length(labels)
  stats::setNames(
    grDevices::hcl(
      h = seq(0, 360, length.out = n + 1L)[seq_len(n)],
      c = 80,
      l = 65
    ),
    labels
  )
}

#' Draw a single atlas polygon piece on the current device
#'
#' One contiguous region piece, keyed by label × view × group. A piece with a
#' single ring is drawn with [graphics::polygon()]; a piece with holes (multiple
#' `subgroup` rings) is drawn with [graphics::polypath()] using NA-separated
#' rings and the even-odd rule. `dots` overrides the styling defaults so callers
#' can pass e.g. `lwd` or `border` through `plot()`.
#' @noRd
#' @keywords internal
draw_piece <- function(piece, col, dots = list()) {
  rings <- sort(unique(piece$subgroup))
  defaults <- list(col = col, border = "white", lwd = 0.3)

  if (length(rings) == 1L) {
    do.call(
      polygon,
      c(
        list(x = piece$x, y = piece$y),
        utils::modifyList(defaults, dots)
      )
    )
    return(invisible())
  }

  rings_xy <- split(piece[c("x", "y")], piece$subgroup)[as.character(rings)]
  xs <- unlist(
    lapply(rings_xy, function(r) c(r$x, NA_real_)),
    use.names = FALSE
  )
  ys <- unlist(
    lapply(rings_xy, function(r) c(r$y, NA_real_)),
    use.names = FALSE
  )
  do.call(
    polypath,
    c(
      list(x = xs[-length(xs)], y = ys[-length(ys)]),
      utils::modifyList(c(defaults, list(rule = "evenodd")), dots)
    )
  )
  invisible()
}

#' Partition coordinates into groups separated by empty gaps along one axis
#'
#' Returns a contiguous integer group id per element. A break is placed wherever
#' the sorted values jump by more than `gap_frac` of the total span — i.e. an
#' empty band wider than that fraction. Order of the input is preserved.
#' @noRd
#' @keywords internal
gap_groups <- function(values, gap_frac) {
  span <- diff(range(values))
  if (span == 0) {
    return(rep(1L, length(values)))
  }
  o <- order(values)
  breaks <- cumsum(c(0L, diff(values[o]) > gap_frac * span))
  out <- integer(length(values))
  out[o] <- breaks + 1L
  out
}

#' Subdivide an existing grouping by gaps along one axis
#'
#' Splits each current group further wherever `values` has an empty band, and
#' renumbers the result to contiguous ids. Order is preserved.
#' @noRd
#' @keywords internal
refine_by_gaps <- function(cell, values, gap_frac) {
  refined <- integer(length(cell))
  next_id <- 0L
  for (cid in unique(cell)) {
    within <- which(cell == cid)
    sub <- gap_groups(values[within], gap_frac)
    refined[within] <- sub + next_id
    next_id <- next_id + max(sub)
  }
  refined
}

#' Assign each row to a display cell
#'
#' The atlas views are pre-positioned in one coordinate space, but a surface
#' atlas still splits into spatially separate pieces within a view (e.g. the
#' left and right hemispheres, drawn apart with empty space between). Within
#' each view, rows are partitioned into cells by gap-splitting along x then y,
#' so each contiguous piece becomes its own panel. Returns a cell id per row,
#' with order preserved.
#' @noRd
#' @keywords internal
plot_cells <- function(flat, gap_frac = 0.12) {
  ids <- integer(nrow(flat))
  base <- 0L
  for (v in unique(flat$view)) {
    ix <- which(flat$view == v)
    cell <- rep(1L, length(ix))
    for (axis in c("x", "y")) {
      cell <- refine_by_gaps(cell, flat[[axis]][ix], gap_frac)
    }
    ids[ix] <- cell + base
    base <- base + max(cell)
  }
  ids
}

#' Validate constructor inputs for [ggseg_atlas()]
#'
#' Checks `atlas`, `core`, and `data` for type, required columns, and the
#' expected `ggseg_data_*`/`brain_data_*` class for `type`. Aborts on the first
#' violation; returns invisibly when all checks pass.
#' @noRd
#' @keywords internal
validate_ggseg_atlas_inputs <- function(atlas, core, data, type) {
  if (length(atlas) != 1 || !is.character(atlas)) {
    cli::cli_abort(
      "{.arg atlas} must be a single character string, not {length(atlas)}."
    )
  }

  if (!is.data.frame(core)) {
    cli::cli_abort("{.arg core} must be a data.frame.")
  }

  required_core <- c("region", "label")
  missing_core <- setdiff(required_core, names(core))
  if (length(missing_core) > 0) {
    cli::cli_abort(
      "{.arg core} must contain columns: {.field {missing_core}}."
    )
  }

  if (
    !inherits(data, "ggseg_atlas_data") &&
      !inherits(data, "brain_atlas_data")
  ) {
    cli::cli_abort(c(
      "{.arg data} must be a {.cls ggseg_atlas_data} object.",
      "i" = "Use {.fn ggseg_data_cortical}, {.fn ggseg_data_subcortical},
      {.fn ggseg_data_tract}, or {.fn ggseg_data_cerebellar}."
    ))
  }

  expected_new <- paste0("ggseg_data_", type)
  expected_old <- paste0("brain_data_", type)
  if (!inherits(data, expected_new) && !inherits(data, expected_old)) {
    cli::cli_abort(c(
      "Atlas type {.val {type}} requires {.cls {expected_new}}.",
      "x" = "Got {.cls {class(data)[1]}}."
    ))
  }

  invisible()
}

#' Print the header and summary block for a ggseg atlas
#'
#' Emits the title, type, region count, hemispheres, and (when 2D geometry is
#' present) the available views. Side-effecting; returns invisibly.
#' @noRd
#' @keywords internal
print_atlas_summary <- function(x, has_sf) {
  n_regions <- length(stats::na.omit(unique(x$core$region))) # nolint
  hemis <- paste0(unique(x$core$hemi), collapse = ", ") # nolint

  cli::cli_h1("{x$atlas} ggseg atlas")

  cli::cli_text("{.strong Type: {x$type}}")
  cli::cli_text("{.strong Regions:} {n_regions}")
  cli::cli_text("{.strong Hemispheres:} {hemis}")

  if (has_sf) {
    views <- paste0(atlas_views(x), collapse = ", ") # nolint
    cli::cli_text("{.strong Views:} {views}")
  }

  invisible()
}

#' Print the palette and rendering-support block for a ggseg atlas
#'
#' Emits palette presence plus ggseg (2D) and ggseg3d (3D) rendering status,
#' noting which 3D geometry slot is available. Side-effecting; returns
#' invisibly.
#' @noRd
#' @keywords internal
print_atlas_rendering <- function(x, data, has_sf, has_3d) {
  has_palette <- !is.null(x$palette) # nolint: object_usage_linter

  check <- function(val) {
    # nolint: object_usage_linter
    if (val) {
      cli::col_green(cli::symbol$tick)
    } else {
      cli::col_red(cli::symbol$cross)
    }
  }

  cli::cli_text("{.strong Palette:} {check(has_palette)}")

  # nolint start: object_usage_linter
  render_3d <- if (!is.null(data$centerlines)) {
    # nolint end
    "centerlines"
  } else if (!is.null(data$meshes)) {
    "meshes"
  } else if (!is.null(data$vertices)) {
    "vertices"
  } else {
    "none"
  }
  ggseg_status <- check(has_sf) # nolint: object_usage_linter
  ggseg3d_status <- check(has_3d) # nolint: object_usage_linter
  cli::cli_text("{.strong Rendering:} {ggseg_status} ggseg")
  cli::cli_text("             {ggseg3d_status} ggseg3d ({render_3d})")

  invisible()
}
