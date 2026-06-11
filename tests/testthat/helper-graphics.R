local_null_pdf <- function(.local_envir = parent.frame()) {
  pdf(NULL)
  withr::defer(dev.off(), envir = .local_envir)
}
