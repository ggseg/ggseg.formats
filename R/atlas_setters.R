#' Set the palette of an atlas
#'
#' Replaces the colour palette of a brain atlas, validating that `value` is a
#' named character vector and warning if it does not cover every atlas label.
#' This is the setter counterpart to the [atlas_palette()] accessor; it returns
#' the modified atlas, so it composes with the pipe.
#'
#' @inheritParams atlas_palette
#' @param value Named character vector of colours keyed by atlas `label`.
#'
#' @return The `ggseg_atlas` with its palette replaced.
#' @family atlas setters
#' @seealso [atlas_palette()] to read the palette.
#' @export
#' @examples
#' a <- aseg()
#' labs <- atlas_labels(a)
#' a <- set_atlas_palette(a, setNames(grDevices::rainbow(length(labs)), labs))
set_atlas_palette <- function(atlas, value) {
  if (!is_atlas_class(atlas)) {
    cli::cli_abort("{.arg atlas} must be a {.cls ggseg_atlas} object.")
  }
  if (!is.character(value) || is.null(names(value))) {
    cli::cli_abort(c(
      "{.arg value} must be a named character vector of colours.",
      "i" = "Names are the atlas region {.field label}s."
    ))
  }
  absent <- setdiff(atlas_labels(atlas), names(value))
  if (length(absent)) {
    cli::cli_warn(c(
      "Palette does not cover every atlas label.",
      "i" = "e.g. {.val {utils::head(absent, 3)}} ({length(absent)} total)."
    ))
  }
  atlas$palette <- value
  atlas
}
