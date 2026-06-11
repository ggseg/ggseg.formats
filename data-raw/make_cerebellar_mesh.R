# Create SUIT cerebellar surface mesh with peduncular cap
#
# Reads the SUIT 3D cerebellar surface from ggseg.extra and adds a cap
# over the peduncular surface (where cerebellum meets brainstem) so the
# mesh renders as a closed surface in 3D.
#
# The cap duplicates boundary loop vertices and adds a centroid, then
# fan-triangulates to close the opening. Cap vertices (28935--30012)
# are not assigned to any atlas region, analogous to the medial wall
# in cortical atlases.
#
# Prerequisites:
#   - ggseg.extra installed (provides tpl-SUIT_3d.surf.gii)
#   - gifti package
#
# Run with: source("data-raw/make_cerebellar_mesh.R")

rlang::check_installed("gifti")
rlang::check_installed("ggseg.extra")

suit_path <- ggseg.extra::suit_3d_path()
gii <- gifti::readgii(suit_path)

vertices <- as.data.frame(gii$data$pointset)
names(vertices) <- c("x", "y", "z")

faces <- as.data.frame(gii$data$triangle)
names(faces) <- c("i", "j", "k")

n_orig <- nrow(vertices)
cli::cli_alert_info("Original mesh: {n_orig} vertices, {nrow(faces)} faces")

# ── Find boundary edges ──────────────────────────────────────────────
edge_count <- list()
for (fi in seq_len(nrow(faces))) {
  tri <- as.integer(faces[fi, ])
  edges <- list(
    sort(tri[1:2]),
    sort(tri[2:3]),
    sort(tri[c(1, 3)])
  )
  for (e in edges) {
    key <- paste(e, collapse = "_")
    edge_count[[key]] <- (edge_count[[key]] %||% 0L) + 1L
  }
}

boundary_edges <- names(edge_count)[
  vapply(edge_count, function(x) x == 1L, logical(1))
]
cli::cli_alert_info("{length(boundary_edges)} boundary edges found")

# ── Trace boundary loop ──────────────────────────────────────────────
adj <- list()
for (be in boundary_edges) {
  verts <- as.integer(strsplit(be, "_", fixed = TRUE)[[1]])
  v1 <- as.character(verts[1])
  v2 <- as.character(verts[2])
  adj[[v1]] <- c(adj[[v1]], verts[2])
  adj[[v2]] <- c(adj[[v2]], verts[1])
}

boundary_verts <- as.integer(names(adj))
start <- boundary_verts[1]
loop <- integer(length(boundary_verts))
loop[1] <- start
visited <- logical(max(boundary_verts) + 1L)
visited[start + 1L] <- TRUE

for (i in 2:length(loop)) {
  current <- loop[i - 1L]
  neighbors <- adj[[as.character(current)]]
  nxt <- neighbors[!visited[neighbors + 1L]]
  if (length(nxt) == 0) {
    break
  }
  loop[i] <- nxt[1]
  visited[nxt[1] + 1L] <- TRUE
}

n_loop <- sum(loop > 0 | seq_along(loop) == 1)
loop <- loop[seq_len(n_loop)]
cli::cli_alert_info("Boundary loop: {n_loop} vertices")

# ── Create cap ───────────────────────────────────────────────────────
# Duplicate boundary vertices so cap faces reference unassigned copies
cap_vertices <- vertices[loop + 1L, ]
centroid <- data.frame(
  x = mean(cap_vertices$x),
  y = mean(cap_vertices$y),
  z = mean(cap_vertices$z)
)

new_vertices <- rbind(vertices, cap_vertices, centroid)
n_cap_start <- n_orig
centroid_idx <- nrow(new_vertices) - 1L

cap_faces <- data.frame(
  i = integer(n_loop),
  j = integer(n_loop),
  k = integer(n_loop)
)
for (ci in seq_len(n_loop)) {
  ci_next <- if (ci == n_loop) 1L else ci + 1L
  cap_faces$i[ci] <- n_cap_start + ci - 1L
  cap_faces$j[ci] <- n_cap_start + ci_next - 1L
  cap_faces$k[ci] <- centroid_idx
}

all_faces <- rbind(faces, cap_faces)

cli::cli_alert_success(
  "Capped mesh: {nrow(new_vertices)} vertices, {nrow(all_faces)} faces"
)

cerebellar_mesh_suit <- list(
  vertices = new_vertices,
  faces = all_faces
)

save(
  cerebellar_mesh_suit,
  file = "data-raw/cerebellar_mesh_suit.rda",
  compress = "xz"
)
cli::cli_alert_success("Saved to data-raw/cerebellar_mesh_suit.rda")
