extdata_path <- function(...) {
  system.file("extdata", ..., package = "ggseg.formats", mustWork = TRUE)
}
