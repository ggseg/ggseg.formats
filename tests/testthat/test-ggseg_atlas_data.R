describe("brain_data_cortical", {
  it("creates brain_data_cortical with vertices", {
    vertices <- data.frame(label = c("region1", "region2"))
    vertices$vertices <- list(1L:5L, 6L:10L)

    data <- brain_data_cortical(vertices = vertices)

    expect_s3_class(data, "brain_data_cortical")
    expect_s3_class(data, "ggseg_atlas_data")
    expect_equal(nrow(data$vertices), 2)
  })

  it("errors when vertices is missing", {
    expect_error(brain_data_cortical(), "vertices.*is required")
  })

  it("errors when vertices is not a data.frame", {
    expect_error(brain_data_cortical(vertices = list()), "must be a data.frame")
  })

  it("errors when vertices is missing label column", {
    vertices <- data.frame(region = c("region1", "region2"))
    vertices$vertices <- list(1L:5L, 6L:10L)

    expect_error(
      brain_data_cortical(vertices = vertices),
      "must contain columns"
    )
  })

  it("errors when vertices column is not a list", {
    vertices <- data.frame(label = "region1", vertices = 1)

    expect_error(
      brain_data_cortical(vertices = vertices),
      "must be a list-column"
    )
  })

  it("errors when vertices entries are empty", {
    vertices <- data.frame(label = c("region1", "region2"))
    vertices$vertices <- list(integer(0), 1L:5L)

    expect_error(
      brain_data_cortical(vertices = vertices),
      "Empty vertices for.*region1"
    )
  })

  it("creates brain_data_cortical with both sf and vertices", {
    sf_geom <- sf::st_sf(
      label = c("lh_frontal"),
      view = c("lateral"),
      geometry = sf::st_sfc(
        make_polygon()
      )
    )
    vertices <- data.frame(label = "lh_frontal")
    vertices$vertices <- list(1L:3L)

    data <- brain_data_cortical(sf = sf_geom, vertices = vertices)

    expect_s3_class(data, "brain_data_cortical")
    expect_true(!is.null(data$sf))
    expect_true(!is.null(data$vertices))
  })
})


describe("brain_data_subcortical", {
  it("creates brain_data_subcortical with meshes", {
    meshes <- data.frame(label = "hippocampus")
    meshes$mesh <- list(list(
      vertices = data.frame(x = 1:10, y = 1:10, z = 1:10),
      faces = data.frame(i = 1:3, j = 2:4, k = 3:5)
    ))

    data <- brain_data_subcortical(meshes = meshes)

    expect_s3_class(data, "brain_data_subcortical")
    expect_s3_class(data, "ggseg_atlas_data")
    expect_equal(nrow(data$meshes), 1)
  })

  it("errors when meshes is missing", {
    expect_error(brain_data_subcortical(), "meshes.*is required")
  })

  it("validates mesh structure", {
    meshes <- data.frame(label = "region1")
    meshes$mesh <- list(list(vertices = 1))

    expect_error(
      brain_data_subcortical(meshes = meshes),
      "needs.*vertices.*faces"
    )
  })

  it("creates brain_data_subcortical with both sf and meshes", {
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

    data <- brain_data_subcortical(sf = sf_geom, meshes = meshes)

    expect_s3_class(data, "brain_data_subcortical")
    expect_true(!is.null(data$sf))
    expect_true(!is.null(data$meshes))
  })
})


describe("brain_data_tract", {
  it("creates brain_data_tract from meshes with centerline metadata", {
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

    data <- brain_data_tract(meshes = meshes)

    expect_s3_class(data, "brain_data_tract")
    expect_s3_class(data, "ggseg_atlas_data")
    expect_equal(nrow(data$centerlines), 1)
  })

  it("errors when no sf or centerlines provided", {
    expect_error(brain_data_tract(), "sf.*centerlines")
  })

  it("errors when all meshes lack centerline metadata", {
    meshes <- data.frame(label = "cst_left")
    meshes$mesh <- list(list(
      vertices = data.frame(x = 1:10, y = 1:10, z = 1:10),
      faces = data.frame(i = 1:3, j = 2:4, k = 3:5),
      metadata = list(n_centerline_points = 10)
    ))

    expect_warning(
      expect_error(brain_data_tract(meshes = meshes), "No valid centerlines"),
      "missing centerline metadata"
    )
  })

  it("creates brain_data_tract with sf geometry", {
    sf_geom <- sf::st_sf(
      label = c("cst_left"),
      view = c("sagittal"),
      geometry = sf::st_sfc(
        make_polygon()
      )
    )

    data <- brain_data_tract(sf = sf_geom)

    expect_s3_class(data, "brain_data_tract")
    expect_true(!is.null(data$sf))
  })
})
