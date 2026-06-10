# Generate the hex logo for ggseg.formats
#
# Run with: source("data-raw/make_hex.R")
#
# Concept: the brain as its atlas data. The dk regions are dissolved to lobes,
# tiled into an adjacent coverage, and traced as sparse "connect-the-dots"
# vertices joined by edges — each section boundary a single shared line. It is
# the structural layer beneath the coloured visualisations of the ggsegverse.

library(hexSticker)
library(ggplot2)
library(dplyr)
library(sf)
devtools::load_all(".")

accent <- "#e4d4e1" # light lavender brain + text
fill <- "#5d3d59" # plum hex background
border <- "#3a2738" # darker plum rim

# Left-hemisphere lateral cortex, regions tagged by lobe.
regions <- dk() |>
  as.data.frame() |>
  st_as_sf() |>
  filter(hemi == "left", view == "lateral", !is.na(lobe))

# Dissolve regions to lobes (buffer out so neighbours overlap, then union),
# then tile into an adjacent coverage by sequentially subtracting the lobes
# already placed — this gives single shared seams between lobes.
lobe_geom <- regions |>
  group_by(lobe) |>
  summarise(geom = st_union(st_buffer(geometry, 8)), .groups = "drop")

g <- st_geometry(lobe_geom)
placed <- g[1]
tiled <- list(g[1])
for (i in seq_along(g)[-1]) {
  tiled[[i]] <- st_difference(g[i], st_union(placed))
  placed <- c(placed, g[i])
}
tiled <- do.call(c, lapply(tiled, st_cast, "MULTIPOLYGON"))
lobes <- rmapshaper::ms_simplify(
  st_sf(lobe = lobe_geom$lobe, geometry = tiled),
  keep = 0.18,
  keep_shapes = TRUE
)

# Single-seam line network: inner shared boundaries (each once) + the outer
# silhouette, thinned to a sparse set of nodes.
net <- c(
  st_geometry(rmapshaper::ms_innerlines(lobes)),
  st_cast(st_boundary(st_union(st_geometry(lobes))), "MULTILINESTRING")
)
net <- st_simplify(net, dTolerance = 18, preserveTopology = FALSE)

co <- as.data.frame(st_coordinates(st_cast(net, "MULTILINESTRING")))
co$rid <- interaction(co$L1, co$L2, drop = TRUE)

edges <- do.call(
  rbind,
  lapply(split(co, co$rid), function(d) {
    m <- nrow(d)
    if (m < 2) {
      return(NULL)
    }
    data.frame(x = d$X[-m], y = d$Y[-m], xend = d$X[-1], yend = d$Y[-1])
  })
)
nodes <- unique(data.frame(
  x = c(edges$x, edges$xend),
  y = c(edges$y, edges$yend)
))

p <- ggplot() +
  geom_segment(
    data = edges,
    aes(x = x, y = y, xend = xend, yend = yend),
    colour = accent,
    linewidth = 0.3,
    alpha = 0.95
  ) +
  geom_point(data = nodes, aes(x = x, y = y), colour = accent, size = 0.7) +
  coord_fixed() +
  theme_void() +
  theme_transparent()

hex_args <- list(
  package = "ggseg.formats",
  s_x = 1,
  s_y = 1.16,
  s_width = 1.58,
  s_height = 1.2,
  p_family = "mono",
  p_size = 5.6,
  p_color = accent,
  p_y = 0.49,
  h_fill = fill,
  h_color = border
)

# PNG only: hexSticker's svglite output mis-sizes the package-name font, so we
# do not ship a logo.svg (matching the rest of the ggsegverse).
do.call(sticker, c(list(p, filename = "man/figures/logo.png"), hex_args))

# Favicons: realfavicongenerator.net (used by pkgdown::build_favicons) is
# unreliable, so render the standard set locally from the logo with magick.
img <- magick::image_read("man/figures/logo.png")
square <- function(px) {
  geom <- sprintf("%dx%d", px, px)
  magick::image_extent(magick::image_resize(img, geom), geom, color = "none")
}
favicons <- list(
  "favicon-16x16.png" = 16,
  "favicon-32x32.png" = 32,
  "apple-touch-icon-60x60.png" = 60,
  "apple-touch-icon-76x76.png" = 76,
  "apple-touch-icon-120x120.png" = 120,
  "apple-touch-icon-152x152.png" = 152,
  "apple-touch-icon-180x180.png" = 180,
  "apple-touch-icon.png" = 180
)
dir.create("pkgdown/favicon", recursive = TRUE, showWarnings = FALSE)
for (nm in names(favicons)) {
  magick::image_write(
    square(favicons[[nm]]),
    file.path("pkgdown/favicon", nm),
    format = "png"
  )
}
magick::image_write(
  magick::image_join(square(16), square(32)),
  "pkgdown/favicon/favicon.ico",
  format = "ico"
)
