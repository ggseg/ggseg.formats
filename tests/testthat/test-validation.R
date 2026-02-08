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

  it("errors when geometry is empty", {
    sf_bad <- sf::st_sf(
      label = c("region1", "region2"),
      view = c("lateral", "lateral"),
      geometry = sf::st_sfc(
        sf::st_polygon(),
        make_polygon()
      )
    )

    expect_error(
      cortical_data(sf = sf_bad),
      "Empty geometry for.*region1"
    )
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

  it("errors when mesh entries are NULL", {
    meshes <- data.frame(label = c("region1", "region2"))
    meshes$mesh <- list(
      NULL,
      list(
        vertices = data.frame(x = 1:10, y = 1:10, z = 1:10),
        faces = data.frame(i = 1:3, j = 2:4, k = 3:5)
      )
    )

    expect_error(
      subcortical_data(meshes = meshes),
      "Empty mesh for.*region1"
    )
  })

  it("errors when mesh vertices are empty", {
    meshes <- data.frame(label = "region1")
    meshes$mesh <- list(list(
      vertices = data.frame(x = numeric(0), y = numeric(0), z = numeric(0)),
      faces = data.frame(i = 1:3, j = 2:4, k = 3:5)
    ))

    expect_error(
      subcortical_data(meshes = meshes),
      "Empty mesh for.*region1"
    )
  })

  it("errors when mesh faces are empty", {
    meshes <- data.frame(label = "region1")
    meshes$mesh <- list(list(
      vertices = data.frame(x = 1:10, y = 1:10, z = 1:10),
      faces = data.frame(i = integer(0), j = integer(0), k = integer(0))
    ))

    expect_error(
      subcortical_data(meshes = meshes),
      "Empty mesh for.*region1"
    )
  })
})


describe("validate_tract_metadata", {
  it("errors when mesh metadata is not a list", {
    meshes <- data.frame(label = "cst_left")
    meshes$mesh <- list(list(
      vertices = data.frame(x = 1:10, y = 1:10, z = 1:10),
      faces = data.frame(i = 1:3, j = 2:4, k = 3:5),
      metadata = "not a list"
    ))

    expect_error(tract_data(meshes = meshes))
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
  it("allows context-only labels in vertices (not in core)", {
    core <- data.frame(hemi = "left", region = "frontal", label = "lh_frontal")
    vertices <- data.frame(label = c("lh_frontal", "lh_unknown"))
    vertices$vertices <- list(1L:3L, 4L:6L)

    expect_no_warning(
      brain_atlas(
        atlas = "test",
        type = "cortical",
        core = core,
        data = cortical_data(vertices = vertices)
      )
    )
  })

  it("allows context-only labels in sf (not in core)", {
    sf_geom <- sf::st_sf(
      label = c("lh_frontal", "lh_medialwall"),
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

    expect_no_warning(
      brain_atlas(
        atlas = "test",
        type = "cortical",
        core = core,
        data = cortical_data(sf = sf_geom)
      )
    )
  })

  it("allows context-only labels in meshes (not in core)", {
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

    expect_no_warning(
      brain_atlas(
        atlas = "test",
        type = "subcortical",
        core = core,
        data = subcortical_data(meshes = meshes)
      )
    )
  })

  it("errors when core labels are missing from data", {
    core <- data.frame(
      hemi = c("left", "right"),
      region = c("frontal", "frontal"),
      label = c("lh_frontal", "rh_frontal")
    )
    vertices <- data.frame(label = "lh_frontal")
    vertices$vertices <- list(1L:3L)

    expect_error(
      brain_atlas(
        atlas = "test",
        type = "cortical",
        core = core,
        data = cortical_data(vertices = vertices)
      ),
      "Missing from data.*rh_frontal"
    )
  })

  it("accepts core labels present in either sf or vertices", {
    sf_geom <- sf::st_sf(
      label = "lh_frontal",
      view = "lateral",
      geometry = sf::st_sfc(make_polygon())
    )
    vertices <- data.frame(label = "rh_frontal")
    vertices$vertices <- list(1L:3L)
    core <- data.frame(
      hemi = c("left", "right"),
      region = c("frontal", "frontal"),
      label = c("lh_frontal", "rh_frontal")
    )

    atlas <- brain_atlas(
      atlas = "test",
      type = "cortical",
      core = core,
      data = cortical_data(sf = sf_geom, vertices = vertices)
    )

    expect_s3_class(atlas, "brain_atlas")
  })
})
