describe("validate_sf", {
  it("errors when sf is not a data.frame", {
    expect_error(
      cortical_data(sf = "not a dataframe"),
      "must be a data.frame"
    )
  })

  it("errors when sf is missing required columns", {
    sf_bad <- data.frame(label = "test", view = "lateral")
    expect_error(
      cortical_data(sf = sf_bad),
      "must contain columns.*geometry"
    )
  })

  it("errors when geometry is not sfc", {
    sf_bad <- data.frame(label = "test", view = "lateral", geometry = "not sfc")
    expect_error(
      cortical_data(sf = sf_bad),
      "must be an sf geometry column"
    )
  })

  it("converts data.frame with sfc geometry to sf", {
    geom <- sf::st_sfc(
      make_polygon()
    )
    df <- data.frame(label = "test", view = "lateral")
    df$geometry <- geom

    data <- cortical_data(sf = df)

    expect_s3_class(data$sf, "sf")
  })
})


describe("validate_vertices", {
  it("errors when vertices is missing required columns", {
    vertices <- data.frame(region = "test")
    vertices$vertices <- list(1L:3L)

    expect_error(
      cortical_data(vertices = vertices),
      "must contain columns.*label"
    )
  })
})


describe("validate_meshes", {
  it("errors when meshes is not a data.frame", {
    expect_error(
      subcortical_data(meshes = "not a dataframe"),
      "must be a data.frame"
    )
  })

  it("errors when meshes is missing required columns", {
    meshes <- data.frame(region = "test")
    meshes$mesh <- list(NULL)

    expect_error(
      subcortical_data(meshes = meshes),
      "must contain columns.*label"
    )
  })

  it("errors when mesh column is not a list", {
    meshes <- data.frame(label = "test", mesh = "not a list")

    expect_error(
      subcortical_data(meshes = meshes),
      "must be a list-column"
    )
  })

  it("errors when mesh vertices are missing xyz columns", {
    meshes <- data.frame(label = "bad_mesh")
    meshes$mesh <- list(list(
      vertices = data.frame(a = 1:10, b = 1:10),
      faces = data.frame(i = 1:3, j = 2:4, k = 3:5)
    ))

    expect_error(
      subcortical_data(meshes = meshes),
      "Mesh vertices.*must be a data.frame"
    )
  })

  it("errors when mesh faces are missing ijk columns", {
    meshes <- data.frame(label = "bad_mesh")
    meshes$mesh <- list(list(
      vertices = data.frame(x = 1:10, y = 1:10, z = 1:10),
      faces = data.frame(a = 1:3, b = 2:4)
    ))

    expect_error(
      subcortical_data(meshes = meshes),
      "Mesh faces.*must be a data.frame"
    )
  })

  it("allows NULL mesh entries", {
    meshes <- data.frame(label = c("region1", "region2"))
    meshes$mesh <- list(
      NULL,
      list(
        vertices = data.frame(x = 1:10, y = 1:10, z = 1:10),
        faces = data.frame(i = 1:3, j = 2:4, k = 3:5)
      )
    )

    data <- subcortical_data(meshes = meshes)
    expect_s3_class(data, "subcortical_data")
  })
})


describe("validate_tract_metadata", {
  it("warns when metadata is not a list", {
    meshes <- data.frame(label = "cst_left")
    meshes$mesh <- list(list(
      vertices = data.frame(x = 1:10, y = 1:10, z = 1:10),
      faces = data.frame(i = 1:3, j = 2:4, k = 3:5),
      metadata = "not a list"
    ))

    expect_warning(tract_data(meshes = meshes), "should be a list")
  })
})


describe("validate_palette", {
  it("errors when palette is not a named character vector", {
    core <- data.frame(hemi = "left", region = "frontal", label = "lh_frontal")
    vertices <- data.frame(label = "lh_frontal")
    vertices$vertices <- list(1L:3L)

    expect_error(
      brain_atlas(
        atlas = "test",
        type = "cortical",
        palette = c("red", "blue"),
        core = core,
        data = cortical_data(vertices = vertices)
      ),
      "must be a named character vector"
    )
  })

  it("warns about unknown labels in palette", {
    core <- data.frame(hemi = "left", region = "frontal", label = "lh_frontal")
    vertices <- data.frame(label = "lh_frontal")
    vertices$vertices <- list(1L:3L)

    expect_warning(
      brain_atlas(
        atlas = "test",
        type = "cortical",
        palette = c(lh_frontal = "#FF0000", unknown = "#00FF00"),
        core = core,
        data = cortical_data(vertices = vertices)
      ),
      "not found in.*core"
    )
  })
})


describe("validate_data_labels", {
  it("warns about unknown labels in vertices data", {
    core <- data.frame(hemi = "left", region = "frontal", label = "lh_frontal")
    vertices <- data.frame(label = c("lh_frontal", "unknown_label"))
    vertices$vertices <- list(1L:3L, 4L:6L)

    expect_warning(
      brain_atlas(
        atlas = "test",
        type = "cortical",
        core = core,
        data = cortical_data(vertices = vertices)
      ),
      "Unknown labels in vertices"
    )
  })

  it("warns about unknown labels in sf data", {
    sf_geom <- sf::st_sf(
      label = c("lh_frontal", "unknown_region"),
      view = c("lateral", "lateral"),
      geometry = sf::st_sfc(
        make_polygon(),
        make_polygon2()
      )
    )
    core <- data.frame(
      hemi = "left",
      region = "frontal",
      label = "lh_frontal"
    )

    expect_warning(
      brain_atlas(
        atlas = "test",
        type = "cortical",
        core = core,
        data = cortical_data(sf = sf_geom)
      ),
      "Unknown labels in sf"
    )
  })

  it("warns about unknown labels in meshes data", {
    meshes <- data.frame(label = c("hippocampus", "unknown_structure"))
    meshes$mesh <- list(
      list(
        vertices = data.frame(x = 1:10, y = 1:10, z = 1:10),
        faces = data.frame(i = 1:3, j = 2:4, k = 3:5)
      ),
      list(
        vertices = data.frame(x = 1:10, y = 1:10, z = 1:10),
        faces = data.frame(i = 1:3, j = 2:4, k = 3:5)
      )
    )
    core <- data.frame(hemi = NA, region = "hippocampus", label = "hippocampus")

    expect_warning(
      brain_atlas(
        atlas = "test",
        type = "subcortical",
        core = core,
        data = subcortical_data(meshes = meshes)
      ),
      "Unknown labels in meshes"
    )
  })
})
