# Base-R replacements for the dplyr/tidyr verbs the package used to depend on.
#
# Returned objects are plain data.frames tagged with the `tbl_df`/`tbl`
# classes. The package does not import tibble, but ggplot2 (an Import) loads
# the tibble namespace, so `print.tbl_df` is registered at runtime and these
# objects render as tibbles. Without tibble loaded, dispatch falls back to
# `print.data.frame`.

#' Tag a data.frame with the tibble classes
#' @noRd
#' @keywords internal
as_tbl <- function(x, extra_class = character()) {
  x <- as.data.frame(x, stringsAsFactors = FALSE)
  rownames(x) <- NULL
  class(x) <- unique(c(extra_class, "tbl_df", "tbl", "data.frame"))
  x
}

#' Distinct rows over a set of columns
#' @noRd
#' @keywords internal
df_distinct <- function(df, cols) {
  as_tbl(unique(df[, cols, drop = FALSE]))
}

#' Left join on one or more key columns
#'
#' Replicates dplyr's one-to-many semantics: each row of `x` is repeated once
#' per matching row of `y` (in `y`'s order), and unmatched `x` rows are kept
#' once with `NA` in the added columns.
#' @noRd
#' @keywords internal
df_left_join <- function(x, y, by) {
  add <- setdiff(names(y), by)
  xkey <- do.call(paste, c(x[by], sep = "\r"))
  ykey <- do.call(paste, c(y[by], sep = "\r"))
  matches <- lapply(xkey, function(k) which(ykey == k))
  reps <- vapply(matches, function(m) max(length(m), 1L), integer(1))
  yidx <- unlist(lapply(
    matches,
    function(m) if (length(m)) m else NA_integer_
  ))
  out <- x[rep(seq_len(nrow(x)), reps), , drop = FALSE]
  for (col in add) {
    out[[col]] <- y[[col]][yidx]
  }
  as_tbl(out)
}

#' Row-bind a list of data.frames, optionally adding an id column from names
#' @noRd
#' @keywords internal
df_bind_rows <- function(dfs, .id = NULL) {
  dfs <- Filter(Negate(is.null), dfs)
  if (!length(dfs)) {
    return(as_tbl(data.frame()))
  }
  if (!is.null(.id)) {
    nm <- names(dfs)
    dfs <- Map(
      function(d, n) {
        d[[.id]] <- rep(n, nrow(d))
        d[c(.id, setdiff(names(d), .id))]
      },
      dfs,
      nm
    )
  }
  as_tbl(do.call(rbind, dfs))
}

#' Nest every column except `key` into a list-column named `into`
#' @noRd
#' @keywords internal
df_nest <- function(df, key, into) {
  ukey <- unique(df[[key]])
  rest <- setdiff(names(df), key)
  geoms <- lapply(ukey, function(k) {
    as_tbl(df[df[[key]] == k, rest, drop = FALSE])
  })
  out <- as_tbl(stats::setNames(list(ukey), key))
  out[[into]] <- geoms
  out
}

#' Unnest a list-column of data.frames, recycling the other columns
#' @noRd
#' @keywords internal
df_unnest <- function(df, col) {
  inner <- df[[col]]
  reps <- vapply(inner, nrow, integer(1))
  outer <- df[
    rep(seq_len(nrow(df)), reps),
    setdiff(names(df), col),
    drop = FALSE
  ]
  as_tbl(cbind(outer, do.call(rbind, inner)))
}
