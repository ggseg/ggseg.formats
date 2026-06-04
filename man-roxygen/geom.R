#' @param geom 2D geometry for rendering, stored in the single `geom` slot:
#'   either an sf data.frame (columns `label`, `view`, `geometry`) or a
#'   `brain_polygons` tibble (see [sf_to_polygons()]). The class of `geom`
#'   determines the rendering path used downstream.
