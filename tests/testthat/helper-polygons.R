make_polygon <- function(coords = c(0, 0, 1, 0, 1, 1, 0, 0)) {
  sf::st_polygon(list(matrix(coords, ncol = 2, byrow = TRUE)))
}

make_polygon2 <- function() {
  coords <- c(2, 0, 3, 0, 3, 1, 2, 0)
  sf::st_polygon(list(matrix(coords, ncol = 2, byrow = TRUE)))
}
