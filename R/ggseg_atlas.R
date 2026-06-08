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
  (inherits(x, "ggseg_atlas") || inherits(x, "brain_atlas")) &&
    validate_ggseg_atlas(x)
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


#' @export
#' @importFrom stats na.omit
print.ggseg_atlas <- function(x, n = 10, ...) {
  data <- x$data
  geom <- geom_from_data(data)
  has_sf <- !is.null(geom)
  has_3d <- !is.null(data$vertices) ||
    !is.null(data$meshes) ||
    !is.null(data$centerlines)
  has_palette <- !is.null(x$palette) # nolint: object_usage_linter
  n_regions <- length(stats::na.omit(unique(x$core$region))) # nolint
  hemis <- paste0(unique(x$core$hemi), collapse = ", ") # nolint

  cli::cli_h1("{x$atlas} ggseg atlas")

  cli::cli_text("{.strong Type: {x$type}}")
  cli::cli_text("{.strong Regions:} {n_regions}")
  cli::cli_text("{.strong Hemispheres:} {hemis}")

  if (has_sf) {
    geom_views <- if (inherits(geom, "brain_polygons")) {
      unique(polygons_unnest(geom)$view)
    } else {
      unique(geom$view)
    }
    views <- paste0(geom_views, collapse = ", ") # nolint
    cli::cli_text("{.strong Views:} {views}")
  }

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
  geom <- if (inherits(x$data, "ggseg_atlas_data")) {
    geom_from_data(x$data)
  } else {
    NULL
  }
  has_2d_slot <- !is.null(geom) ||
    inherits(x$data, "sf") ||
    inherits(x$data, "data.frame")
  if (!has_2d_slot) {
    cli::cli_abort(
      "Cannot convert ggseg_atlas to data.frame: no 2D geometry."
    )
  }
  require_sf("as.data.frame.ggseg_atlas()")

  sf_data <- if (!is.null(geom)) {
    sf::st_as_sf(
      if (inherits(geom, "brain_polygons")) {
        polygons_to_sf(geom)
      } else {
        geom
      }
    )
  } else if (inherits(x$data, "sf") || inherits(x$data, "data.frame")) {
    sf::st_as_sf(x$data)
  } else {
    NULL
  }

  n <- if (!is.null(sf_data)) nrow(sf_data) else 0
  if (is.null(n) || n == 0) {
    cli::cli_abort(
      "Cannot convert ggseg_atlas to data.frame: no 2D geometry."
    )
  }

  if (!is.null(x$core)) {
    has_sf_hemi <- "hemi" %in% names(sf_data)
    if (has_sf_hemi) {
      sf_data$.sf_hemi <- sf_data$hemi
    }
    core_cols <- c("hemi", "region")
    sf_has_core <- any(core_cols %in% names(sf_data))
    if (sf_has_core) {
      sf_data[core_cols] <- NULL
    }
    result <- merge(sf_data, x$core, by = "label", all.x = TRUE)
    if (has_sf_hemi) {
      missing <- is.na(result$hemi) & !is.na(result$.sf_hemi)
      if (any(missing)) {
        result$hemi[missing] <- result$.sf_hemi[missing]
      }
      result$.sf_hemi <- NULL
    }
  } else {
    result <- sf_data
  }

  if (x$type == "cortical") {
    if (!"hemi" %in% names(result)) {
      result$hemi <- NA_character_
    }
    missing_hemi <- is.na(result$hemi)
    if (any(missing_hemi)) {
      result$hemi[missing_hemi] <- ifelse(
        grepl("^lh[_.]", result$label[missing_hemi]),
        "left",
        ifelse(
          grepl("^rh[_.]", result$label[missing_hemi]),
          "right",
          NA_character_
        )
      )
    }
    still_missing <- is.na(result$hemi)
    if (any(still_missing)) {
      result <- result[!still_missing, , drop = FALSE]
    }
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
    matched <- labels %in% names(palette) & !is.na(palette[labels])
    return(stats::setNames(
      ifelse(matched, palette[labels], "#CCCCCC"),
      labels
    ))
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

#' @importFrom graphics mtext par plot.new plot.window polygon polypath title
#' @export
plot.ggseg_atlas <- function(x, ...) {
  geom <- geom_from_data(x$data)

  if (is.null(geom)) {
    cli::cli_abort("Cannot plot: atlas has no 2D geometry.")
  }

  # Convert sf geometry to the sf-free polygon representation
  if (inherits(geom, "sf")) {
    require_sf("plot.ggseg_atlas() with sf-backed atlas")
    geom <- sf_to_polygons(geom)
  }

  flat <- polygons_unnest(geom)
  fill_colors <- resolve_fill_colors(flat$label, x$palette)
  dots <- list(...)

  views <- unique(flat$view)
  n_views <- length(views)

  old_par <- par(
    mfrow = c(1L, n_views),
    mar = c(0.5, 0.5, 1.5, 0.5),
    oma = c(0, 0, 2, 0)
  )
  on.exit(par(old_par), add = TRUE)

  # Shared coordinate extent so all panels use the same scale
  xlim_all <- range(flat$x, na.rm = TRUE)
  ylim_all <- range(flat$y, na.rm = TRUE)

  for (v in views) {
    view_flat <- flat[flat$view == v, , drop = FALSE]

    plot.new()
    plot.window(xlim = xlim_all, ylim = ylim_all, asp = 1)

    # Collapse label × group loops: split once, then lapply over all pieces
    piece_id <- paste(view_flat$label, view_flat$group, sep = "\r")
    pieces <- split(view_flat, piece_id)

    invisible(lapply(pieces, function(piece) {
      col <- fill_colors[[piece$label[[1L]]]]
      rings <- sort(unique(piece$subgroup))

      if (length(rings) == 1L) {
        do.call(
          polygon,
          c(
            list(x = piece$x, y = piece$y),
            utils::modifyList(
              list(col = col, border = "white", lwd = 0.3),
              dots
            )
          )
        )
      } else {
        # NA-separated rings; polypath cuts holes via the even-odd rule
        rings_xy <- split(piece[c("x", "y")], piece$subgroup)[
          as.character(rings)
        ]
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
            utils::modifyList(
              list(col = col, border = "white", lwd = 0.3, rule = "evenodd"),
              dots
            )
          )
        )
      }
    }))

    title(v, cex.main = 0.8)
  }

  mtext(
    paste(x$atlas, x$type, "atlas"),
    outer = TRUE,
    cex = 1,
    line = 0.5
  )

  invisible(x)
}
