describe("cortical_data", {
  it("creates cortical_data with vertices", {
    vertices <- data.frame(label = c("region1", "region2"))
    vertices$vertices <- list(1L:5L, 6L:10L)

    data <- cortical_data(vertices = vertices)

    expect_s3_class(data, "cortical_data")
    expect_s3_class(data, "brain_atlas_data")
    expect_equal(nrow(data$vertices), 2)
  })

  it("errors when vertices is missing", {
    expect_error(cortical_data(), "vertices.*is required")
  })

  it("errors when vertices is not a data.frame", {
    expect_error(cortical_data(vertices = list()), "must be a data.frame")
  })

  it("errors when vertices is missing label column", {
    vertices <- data.frame(region = c("region1", "region2"))
    vertices$vertices <- list(1L:5L, 6L:10L)

    expect_error(
      cortical_data(vertices = vertices),
      "must contain columns"
    )
  })

  it("errors when vertices column is not a list", {
    vertices <- data.frame(label = "region1", vertices = 1)

    expect_error(cortical_data(vertices = vertices), "must be a list-column")
  })

  it("errors when vertices entries are empty", {
    vertices <- data.frame(label = c("region1", "region2"))
    vertices$vertices <- list(integer(0), 1L:5L)

    expect_error(
      cortical_data(vertices = vertices),
      "Empty vertices for.*region1"
    )
  })

  it("creates cortical_data with both sf and vertices", {
    sf_geom <- sf::st_sf(
      label = c("lh_frontal"),
      view = c("lateral"),
      geometry = sf::st_sfc(
        make_polygon()
      )
    )
    vertices <- data.frame(label = "lh_frontal")
    vertices$vertices <- list(1L:3L)

    data <- cortical_data(sf = sf_geom, vertices = vertices)

    expect_s3_class(data, "cortical_data")
    expect_true(!is.null(data$sf))
    expect_true(!is.null(data$vertices))
  })
})


describe("subcortical_data", {
  it("creates subcortical_data with meshes", {
    meshes <- data.frame(label = "hippocampus")
    meshes$mesh <- list(list(
      vertices = data.frame(x = 1:10, y = 1:10, z = 1:10),
      faces = data.frame(i = 1:3, j = 2:4, k = 3:5)
    ))

    data <- subcortical_data(meshes = meshes)

    expect_s3_class(data, "subcortical_data")
    expect_s3_class(data, "brain_atlas_data")
    expect_equal(nrow(data$meshes), 1)
  })

  it("errors when meshes is missing", {
    expect_error(subcortical_data(), "meshes.*is required")
  })

  it("validates mesh structure", {
    meshes <- data.frame(label = "region1")
    meshes$mesh <- list(list(vertices = 1))

    expect_error(
      subcortical_data(meshes = meshes),
      "needs.*vertices.*faces"
    )
  })

  it("creates subcortical_data with both sf and meshes", {
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

    data <- subcortical_data(sf = sf_geom, meshes = meshes)

    expect_s3_class(data, "subcortical_data")
    expect_true(!is.null(data$sf))
    expect_true(!is.null(data$meshes))
  })
})


describe("tract_data", {
  it("creates tract_data with meshes", {
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

    data <- tract_data(meshes = meshes)

    expect_s3_class(data, "tract_data")
    expect_s3_class(data, "brain_atlas_data")
    expect_equal(nrow(data$meshes), 1)
  })

  it("errors when meshes is missing", {
    expect_error(tract_data(), "meshes.*is required")
  })

  it("warns about missing tract metadata", {
    meshes <- data.frame(label = "cst_left")
    meshes$mesh <- list(list(
      vertices = data.frame(x = 1:10, y = 1:10, z = 1:10),
      faces = data.frame(i = 1:3, j = 2:4, k = 3:5),
      metadata = list(n_centerline_points = 10)
    ))

    expect_warning(tract_data(meshes = meshes), "missing.*centerline")
  })

  it("creates tract_data with sf geometry", {
    sf_geom <- sf::st_sf(
      label = c("cst_left"),
      view = c("sagittal"),
      geometry = sf::st_sfc(
        make_polygon()
      )
    )

    data <- tract_data(sf = sf_geom)

    expect_s3_class(data, "tract_data")
    expect_true(!is.null(data$sf))
  })
})
