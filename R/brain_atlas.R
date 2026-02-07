#' Constructor for brain atlas
#'
#' Creates an object of class 'brain_atlas' for plotting brain parcellations
#' using ggseg (2D) and ggseg3d (3D).
#'
#' @param atlas atlas short name, length one
#' @param type atlas type: "cortical", "subcortical", or "tract"
#' @param palette named character vector of colours keyed by label
#' @param core data.frame with required columns hemi, region, label (one row per
#'   unique region). May contain additional columns for grouping or metadata
#'   (e.g., lobe, network, Brodmann area).
#' @param data a brain_atlas_data object created by one of:
#'   [cortical_data()], [subcortical_data()], or [tract_data()].
#'   Must match the specified type.
#'
#' @return an object of class 'brain_atlas'
#' @export
#'
#' @examples
#' \dontrun{
#' # Cortical atlas
#' atlas <- brain_atlas(
#'   atlas = "dk",
#'   type = "cortical",
#'   core = core_df,
#'   data = cortical_data(sf = geometry, vertices = vertex_indices)
#' )
#'
#' # Tract atlas
#' atlas <- brain_atlas(
#'   atlas = "hcp_tracts",
#'   type = "tract",
#'   core = core_df,
#'   data = tract_data(meshes = tube_meshes, scalars = list(FA = fa_values))
#' )
#' }
brain_atlas <- function(atlas, type, core, data, palette = NULL) {
  type <- match.arg(type, c("cortical", "subcortical", "tract"))

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

  if (!inherits(data, "brain_atlas_data")) {
    cli::cli_abort(
      "{.arg data} must be a {.cls brain_atlas_data} object created by ",
      "{.fn cortical_data}, {.fn subcortical_data}, or {.fn tract_data}."
    )
  }

  expected_class <- paste0(type, "_data")
  if (!inherits(data, expected_class)) {
    cli::cli_abort(c(
      "Atlas type {.val {type}} requires {.cls {expected_class}}.",
      "x" = "Got {.cls {class(data)[1]}}."
    ))
  }

  data <- validate_data_labels(data, core)

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
    class = "brain_atlas"
  )
}


#' Validate brain atlas
#' @param x an object
#' @return logical if object is of class 'brain_atlas'
#' @export
is_brain_atlas <- function(x) inherits(x, "brain_atlas")


#' @export
#' @importFrom stats na.omit
print.brain_atlas <- function(x, ...) {
  data <- x$data
  has_sf <- !is.null(data$sf)
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
    views <- paste0(unique(data$sf$view), collapse = ", ") # nolint
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

  render_3d <- if (!is.null(data$centerlines)) {
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

  print(dplyr::as_tibble(x$core), ...)

  invisible(x)
}


#' @export
as.list.brain_atlas <- function(x, ...) {
  list(
    atlas = x$atlas,
    type = x$type,
    palette = x$palette,
    core = x$core,
    data = x$data
  )
}


#' @export
#' @importFrom dplyr left_join select any_of
as.data.frame.brain_atlas <- function(x, ...) {
  sf_data <- if (inherits(x$data, "brain_atlas_data") && !is.null(x$data$sf)) {
    sf::st_as_sf(x$data$sf)
  } else if (inherits(x$data, "sf") || inherits(x$data, "data.frame")) {
    sf::st_as_sf(x$data)
  } else {
    NULL
  }

  n <- if (!is.null(sf_data)) nrow(sf_data) else 0
  if (is.null(n) || n == 0) {
    cli::cli_abort("Cannot convert brain_atlas to data.frame: no 2D geometry.")
  }

  if (!is.null(x$core)) {
    core_cols <- c("hemi", "region")
    sf_has_core <- any(core_cols %in% names(sf_data))
    if (sf_has_core) {
      sf_data[core_cols] <- NULL
    }
    result <- merge(sf_data, x$core, by = "label", all.x = TRUE)
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

  sf::st_as_sf(result)
}


## quiets concerns of R CMD checks
utils::globalVariables(c("region", "label"))
