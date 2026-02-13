describe("ggseg_data_cortical", {
  it("creates ggseg_data_cortical with vertices", {
    vertices <- data.frame(label = c("region1", "region2"))
    vertices$vertices <- list(1L:5L, 6L:10L)

    data <- ggseg_data_cortical(vertices = vertices)

    expect_s3_class(data, "ggseg_data_cortical")
    expect_s3_class(data, "ggseg_atlas_data")
    expect_equal(nrow(data$vertices), 2)
  })

  it("errors when vertices is missing", {
    expect_error(ggseg_data_cortical(), "vertices.*is required")
  })

  it("errors when vertices is not a data.frame", {
    expect_error(ggseg_data_cortical(vertices = list()), "must be a data.frame")
  })

  it("errors when vertices is missing label column", {
    vertices <- data.frame(region = c("region1", "region2"))
    vertices$vertices <- list(1L:5L, 6L:10L)

    expect_error(
      ggseg_data_cortical(vertices = vertices),
      "must contain columns"
    )
  })

  it("errors when vertices column is not a list", {
    vertices <- data.frame(label = "region1", vertices = 1)

    expect_error(
      ggseg_data_cortical(vertices = vertices),
      "must be a list-column"
    )
  })

  it("errors when vertices entries are empty", {
    vertices <- data.frame(label = c("region1", "region2"))
    vertices$vertices <- list(integer(0), 1L:5L)

    expect_error(
      ggseg_data_cortical(vertices = vertices),
      "Empty vertices for.*region1"
    )
  })

  it("creates ggseg_data_cortical with both sf and vertices", {
    sf_geom <- sf::st_sf(
      label = c("lh_frontal"),
      view = c("lateral"),
      geometry = sf::st_sfc(
        make_polygon()
      )
    )
    vertices <- data.frame(label = "lh_frontal")
    vertices$vertices <- list(1L:3L)

    data <- ggseg_data_cortical(sf = sf_geom, vertices = vertices)

    expect_s3_class(data, "ggseg_data_cortical")
    expect_true(!is.null(data$sf))
    expect_true(!is.null(data$vertices))
  })
})


describe("ggseg_data_subcortical", {
  it("creates ggseg_data_subcortical with meshes", {
    meshes <- data.frame(label = "hippocampus")
    meshes$mesh <- list(list(
      vertices = data.frame(x = 1:10, y = 1:10, z = 1:10),
      faces = data.frame(i = 1:3, j = 2:4, k = 3:5)
    ))

    data <- ggseg_data_subcortical(meshes = meshes)

    expect_s3_class(data, "ggseg_data_subcortical")
    expect_s3_class(data, "ggseg_atlas_data")
    expect_equal(nrow(data$meshes), 1)
  })

  it("errors when meshes is missing", {
    expect_error(ggseg_data_subcortical(), "meshes.*is required")
  })

  it("validates mesh structure", {
    meshes <- data.frame(label = "region1")
    meshes$mesh <- list(list(vertices = 1))

    expect_error(
      ggseg_data_subcortical(meshes = meshes),
      "needs.*vertices.*faces"
    )
  })

  it("creates ggseg_data_subcortical with both sf and meshes", {
    sf_geom <- sf::st_sf(
      label = c("hippocampus"),
      view = c("axial"),
      geometry = sf::st_sfc(
        make_polygon()
      )
    )
    meshes <- data.frame(label = "hippocampus")
    meshes$mesh <- list(list(
      vertices = data.frame(x = 1:10, y = 1:10, z = 1:10),
      faces = data.frame(i = 1:3, j = 2:4, k = 3:5)
    ))

    data <- ggseg_data_subcortical(sf = sf_geom, meshes = meshes)

    expect_s3_class(data, "ggseg_data_subcortical")
    expect_true(!is.null(data$sf))
    expect_true(!is.null(data$meshes))
  })
})


describe("ggseg_data_tract", {
  it("creates ggseg_data_tract from meshes with centerline metadata", {
    meshes <- data.frame(label = "cst_left")
    meshes$mesh <- list(list(
      vertices = data.frame(x = 1:10, y = 1:10, z = 1:10),
      faces = data.frame(i = 1:3, j = 2:4, k = 3:5),
      metadata = list(
        n_centerline_points = 10,
        centerline = matrix(1:30, ncol = 3),
        tangents = matrix(1:30, ncol = 3)
      )
    ))

    data <- ggseg_data_tract(meshes = meshes)

    expect_s3_class(data, "ggseg_data_tract")
    expect_s3_class(data, "ggseg_atlas_data")
    expect_equal(nrow(data$centerlines), 1)
  })

  it("errors when no sf or centerlines provided", {
    expect_error(ggseg_data_tract(), "sf.*centerlines")
  })

  it("errors when all meshes lack centerline metadata", {
    meshes <- data.frame(label = "cst_left")
    meshes$mesh <- list(list(
      vertices = data.frame(x = 1:10, y = 1:10, z = 1:10),
      faces = data.frame(i = 1:3, j = 2:4, k = 3:5),
      metadata = list(n_centerline_points = 10)
    ))

    expect_warning(
      expect_error(ggseg_data_tract(meshes = meshes), "No valid centerlines"),
      "missing centerline metadata"
    )
  })

  it("creates ggseg_data_tract with sf geometry", {
    sf_geom <- sf::st_sf(
      label = c("cst_left"),
      view = c("sagittal"),
      geometry = sf::st_sfc(
        make_polygon()
      )
    )

    data <- ggseg_data_tract(sf = sf_geom)

    expect_s3_class(data, "ggseg_data_tract")
    expect_true(!is.null(data$sf))
  })

  it("creates ggseg_data_tract with centerlines directly", {
    pts <- matrix(rnorm(30), ncol = 3)
    tangents <- matrix(rnorm(30), ncol = 3)
    centerlines <- data.frame(label = "cst_left")
    centerlines$points <- list(pts)
    centerlines$tangents <- list(tangents)

    data <- ggseg_data_tract(centerlines = centerlines)

    expect_s3_class(data, "ggseg_data_tract")
    expect_equal(nrow(data$centerlines), 1)
  })

  it("computes tangents when not provided", {
    pts <- matrix(c(0, 0, 0, 1, 0, 0, 2, 0, 0), ncol = 3, byrow = TRUE)
    centerlines <- data.frame(label = "cst_left")
    centerlines$points <- list(pts)

    data <- ggseg_data_tract(centerlines = centerlines)

    expect_true("tangents" %in% names(data$centerlines))
    expect_true(is.matrix(data$centerlines$tangents[[1]]))
    expect_equal(ncol(data$centerlines$tangents[[1]]), 3)
  })
})


describe("validate_centerlines", {
  it("errors when missing required columns", {
    bad <- data.frame(trajectory = "a")
    bad$points <- list(matrix(1:9, ncol = 3))
    expect_error(
      ggseg_data_tract(centerlines = bad),
      "missing required columns"
    )
  })

  it("errors when points is not a list", {
    bad <- data.frame(label = "a", points = 1)
    expect_error(
      ggseg_data_tract(centerlines = bad),
      "list-column"
    )
  })

  it("errors when points entry is not an n x 3 matrix", {
    bad <- data.frame(label = "a")
    bad$points <- list(matrix(1:6, ncol = 2))
    expect_error(
      ggseg_data_tract(centerlines = bad),
      "n x 3 matrix"
    )
  })
})


describe("compute_tangents", {
  it("handles single-segment centerline", {
    pts <- matrix(c(0, 0, 0, 1, 0, 0), ncol = 3, byrow = TRUE)
    centerlines <- data.frame(label = "a")
    centerlines$points <- list(pts)

    data <- ggseg_data_tract(centerlines = centerlines)
    tangents <- data$centerlines$tangents[[1]]

    expect_equal(nrow(tangents), 2)
  })

  it("handles zero-length tangent vectors", {
    pts <- matrix(c(0, 0, 0, 0, 0, 0, 1, 0, 0), ncol = 3, byrow = TRUE)
    centerlines <- data.frame(label = "a")
    centerlines$points <- list(pts)

    data <- ggseg_data_tract(centerlines = centerlines)
    tangents <- data$centerlines$tangents[[1]]

    expect_equal(tangents[1, ], c(1, 0, 0))
    expect_equal(nrow(tangents), 3)
  })
})


describe("print methods", {
  it("prints ggseg_data_cortical with sf and vertices", {
    sf_geom <- sf::st_sf(
      label = "lh_frontal",
      view = "lateral",
      geometry = sf::st_sfc(make_polygon())
    )
    vertices <- data.frame(label = "lh_frontal")
    vertices$vertices <- list(1L:3L)

    data <- ggseg_data_cortical(sf = sf_geom, vertices = vertices)
    expect_snapshot(print(data))
  })

  it("prints ggseg_data_subcortical with sf and meshes", {
    sf_geom <- sf::st_sf(
      label = "hippocampus",
      view = "axial",
      geometry = sf::st_sfc(make_polygon())
    )
    meshes <- data.frame(label = "hippocampus")
    meshes$mesh <- list(list(
      vertices = data.frame(x = 1:10, y = 1:10, z = 1:10),
      faces = data.frame(i = 1:3, j = 2:4, k = 3:5)
    ))

    data <- ggseg_data_subcortical(sf = sf_geom, meshes = meshes)
    expect_snapshot(print(data))
  })

  it("prints ggseg_data_tract with centerlines", {
    pts <- matrix(rnorm(30), ncol = 3)
    tangents <- matrix(rnorm(30), ncol = 3)
    centerlines <- data.frame(label = "cst_left")
    centerlines$points <- list(pts)
    centerlines$tangents <- list(tangents)

    data <- ggseg_data_tract(centerlines = centerlines)
    expect_snapshot(print(data))
  })

  it("prints ggseg_data_cortical without sf", {
    vertices <- data.frame(label = "lh_frontal")
    vertices$vertices <- list(1L:3L)

    data <- ggseg_data_cortical(vertices = vertices)
    expect_snapshot(print(data))
  })

  it("prints ggseg_data_subcortical without sf", {
    meshes <- data.frame(label = "hippocampus")
    meshes$mesh <- list(list(
      vertices = data.frame(x = 1:10, y = 1:10, z = 1:10),
      faces = data.frame(i = 1:3, j = 2:4, k = 3:5)
    ))

    data <- ggseg_data_subcortical(meshes = meshes)
    expect_snapshot(print(data))
  })

  it("prints ggseg_data_tract with sf and centerlines", {
    sf_geom <- sf::st_sf(
      label = "cst_left",
      view = "sagittal",
      geometry = sf::st_sfc(make_polygon())
    )
    pts <- matrix(rnorm(30), ncol = 3)
    tangents <- matrix(rnorm(30), ncol = 3)
    centerlines <- data.frame(label = "cst_left")
    centerlines$points <- list(pts)
    centerlines$tangents <- list(tangents)

    data <- ggseg_data_tract(sf = sf_geom, centerlines = centerlines)
    expect_snapshot(print(data))
  })
})


describe("deprecated brain_data wrappers", {
  it("brain_data_cortical warns and returns correct class", {
    vertices <- data.frame(label = "lh_frontal")
    vertices$vertices <- list(1L:3L)

    lifecycle::expect_deprecated(
      result <- brain_data_cortical(vertices = vertices)
    )
    expect_s3_class(result, "ggseg_data_cortical")
  })

  it("brain_data_subcortical warns and returns correct class", {
    meshes <- data.frame(label = "hippocampus")
    meshes$mesh <- list(list(
      vertices = data.frame(x = 1:10, y = 1:10, z = 1:10),
      faces = data.frame(i = 1:3, j = 2:4, k = 3:5)
    ))

    lifecycle::expect_deprecated(
      result <- brain_data_subcortical(meshes = meshes)
    )
    expect_s3_class(result, "ggseg_data_subcortical")
  })

  it("brain_data_tract warns and returns correct class", {
    centerlines <- data.frame(label = "cst_left")
    centerlines$points <- list(matrix(rnorm(30), ncol = 3))
    centerlines$tangents <- list(matrix(rnorm(30), ncol = 3))

    lifecycle::expect_deprecated(
      result <- brain_data_tract(centerlines = centerlines)
    )
    expect_s3_class(result, "ggseg_data_tract")
  })
})


describe("meshes_to_centerlines", {
  it("returns NULL for NULL input", {
    expect_null(meshes_to_centerlines(NULL))
  })
})


describe("print_mesh_summary with NULL mesh entries", {
  it("handles NULL mesh in vapply without error", {
    meshes <- data.frame(label = c("region1", "region2"))
    meshes$mesh <- list(
      NULL,
      list(
        vertices = data.frame(x = 1:5, y = 1:5, z = 1:5),
        faces = data.frame(i = 1:2, j = 2:3, k = 3:4)
      )
    )
    expect_output(
      ggseg.formats:::print_mesh_summary(meshes),
      "region1"
    )
  })
})
