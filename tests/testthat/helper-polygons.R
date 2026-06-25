make_polygon <- function(coords = c(0, 0, 1, 0, 1, 1, 0, 0)) {
  sf::st_polygon(list(matrix(coords, ncol = 2, byrow = TRUE)))
}

make_polygon2 <- function() {
  coords <- c(2, 0, 3, 0, 3, 1, 2, 0)
  sf::st_polygon(list(matrix(coords, ncol = 2, byrow = TRUE)))
}

# The bundled atlases (dk, aseg, tracula) now ship in the sf-optional
# brain_polygons format. Tests that need to exercise the sf path rebuild sf
# geometry on the fly from the polygon atlas.
dk_sf_atlas <- function() as_sf_atlas(dk())

dk_sf_geom <- function() atlas_geom(dk_sf_atlas())
