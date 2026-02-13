#' Get brain surface mesh
#'
#' Retrieves a brain surface mesh for the specified hemisphere and surface type.
#' By default, provides the inflated fsaverage5 surface from internal data.
#' Other surfaces (pial, white, semi-inflated) require the ggseg3d package.
#'
#' @param hemisphere `"lh"` or `"rh"`
#' @param surface Surface type (default `"inflated"`). Other surfaces require
#'   ggseg3d or a custom `brain_meshes` argument.
#' @param brain_meshes Optional user-supplied mesh data. Accepts either
#'   `list(lh = list(vertices, faces), rh = ...)` or the legacy
#'   `list(lh_inflated = list(vertices, faces), ...)` format.
#'
#' @return A list with `vertices` (data.frame with x, y, z) and `faces`
#'   (data.frame with i, j, k), or NULL if the mesh is not available.
#' @export
#' @examples
#' mesh <- get_brain_mesh("lh")
#' head(mesh$vertices)
get_brain_mesh <- function(
  hemisphere = c("lh", "rh"),
  surface = "inflated",
  brain_meshes = NULL
) {
  hemisphere <- match.arg(hemisphere)

  if (!is.null(brain_meshes)) {
    mesh <- brain_meshes[[hemisphere]]
    if (is.null(mesh)) {
      mesh <- brain_meshes[[paste(hemisphere, surface, sep = "_")]]
    }
    return(mesh)
  }

  if (surface == "inflated") {
    return(brain_mesh_inflated[[hemisphere]])
  }

  cli::cli_abort(c(
    "Surface {.val {surface}} not available in {.pkg ggseg.formats}.",
    "i" = "Install {.pkg ggseg3d} for pial/white/semi-inflated surfaces.",
    "i" = "Or provide custom meshes via {.arg brain_meshes}."
  ))
}
