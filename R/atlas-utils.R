#' Extract unique names of brain regions
#'
#' Convenience function to extract names of
#' brain regions from a \code{\link{brain_atlas}}
#'
#' @param x brain atlas
#' @return Character vector of brain region names
#' @export
brain_regions <- function(x){
  UseMethod("brain_regions")
}

#' @export
#' @rdname brain_regions
brain_regions.ggseg_atlas <- function(x){
  get_uniq(x, "region")
}

#' @export
#' @rdname brain_regions
brain_regions.brain_atlas <- function(x){
  get_uniq(x$data, "region")
}

#' @export
#' @rdname brain_regions
brain_regions.data.frame <- function(x){
  get_uniq(x, "region")
}


#' Get unique label or region values
#' @keywords internal
#' @noRd
get_uniq <- function(x, type){
  type <- match.arg(type, c("label", "region"))
  x <- unique(x[[type]])
  x <- x[!is.na(x)]
  x[order(x)]
}

#' Extract unique labels of brain regions
#'
#' Convenience function to extract names of
#' brain labels from a \code{\link{brain_atlas}}.
#' Brain labels are usually default naming obtained
#' from the original atlas data.
#'
#' @param x brain atlas
#' @return Character vector of atlas region labels
#' @export
brain_labels <- function(x){
  UseMethod("brain_labels")
}

#' @export
#' @rdname brain_labels
brain_labels.ggseg_atlas <- function(x){
  get_uniq(x, "label")
}

#' @export
#' @rdname brain_labels
brain_labels.brain_atlas <- function(x){
  get_uniq(x$data, "label")
}


#' Detect atlas type
#' @keywords internal
#' @export
atlas_type <- function(x){
  UseMethod("atlas_type")
}

#' @keywords internal
#' @export
atlas_type.ggseg_atlas <- function(x){
  guess_type(x)
}

#' @keywords internal
#' @export
atlas_type.brain_atlas <- function(x){
  guess_type(x)
}

#' guess the atlas type
#' @keywords internal
#' @noRd
guess_type <- function(x){
  k <- if("type" %in% names(x))
    unique(x$type)

  if(is.na(k)){
    warning("atlas type not set, attempting to guess type",
            call. = FALSE)
    k <- ifelse(any("medial" %in% x$side), "cortical", "subcortical")
  }

  unique(k)
}



