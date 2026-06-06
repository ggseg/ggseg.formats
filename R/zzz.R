.onLoad <- function(libname, pkgname) {
  # Return objects carry the `tbl_df`/`tbl` classes so they render as tibbles.
  # tibble is an optional Suggests (never pulled in by an Import). Soft-loading
  # its namespace when installed registers `print.tbl_df`, so every print path
  # formats consistently; when tibble is absent these objects fall back to base
  # `data.frame` printing.
  requireNamespace("tibble", quietly = TRUE)
  invisible()
}
