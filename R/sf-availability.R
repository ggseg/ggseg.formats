#' Ensure the sf package is installed
#'
#' Internal guard used by every function in ggseg.formats that uses the
#' `sf` package. Since `sf` moved to Suggests with the sf-optional
#' milestone, sf-using functions need to error gracefully (with a pointer
#' to the polygon alternative) when sf isn't installed.
#'
#' @param what Character describing the calling function or operation, used
#'   in the error message.
#' @return Invisible `TRUE` if sf is installed; aborts otherwise.
#' @keywords internal
#' @noRd
require_sf <- function(what) {
  if (!rlang::is_installed("sf")) {
    cli::cli_abort(c(
      "{what} requires the {.pkg sf} package, which is not installed.",
      "i" = "Install with {.run install.packages(\"sf\")}, or use the
             polygon-format alternative (see {.fn as_polygon_atlas})."
    ))
  }
  invisible(TRUE)
}


#' Test whether sf is available without raising
#'
#' @return Logical.
#' @keywords internal
#' @noRd
has_sf <- function() {
  rlang::is_installed("sf")
}
