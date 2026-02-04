describe("brain_atlas", {
  it("creates a brain_atlas object with valid inputs", {
    core <- data.frame(
      hemi = c("left", "right"),
      region = c("frontal", "frontal"),
      label = c("lh_frontal", "rh_frontal")
    )
    vertices <- data.frame(
      label = c("lh_frontal", "rh_frontal"),
      stringsAsFactors = FALSE
    )
    vertices$vertices <- list(c(1L, 2L, 3L), c(4L, 5L, 6L))

    atlas <- brain_atlas(
      atlas = "test",
      type = "cortical",
      core = core,
      data = cortical_data(vertices = vertices)
    )

    expect_s3_class(atlas, "brain_atlas")
    expect_equal(atlas$atlas, "test")
    expect_equal(atlas$type, "cortical")
  })

  it("errors with invalid type argument", {
    core <- data.frame(hemi = "left", region = "frontal", label = "lh_frontal")
    vertices <- data.frame(label = "lh_frontal")
    vertices$vertices <- list(1L:3L)

    expect_error(
      brain_atlas(
        atlas = "test",
        type = "invalid",
        core = core,
        data = cortical_data(vertices = vertices)
      ),
      "should be one of"
    )
  })

  it("errors when atlas is not length 1", {
    core <- data.frame(hemi = "left", region = "frontal", label = "lh_frontal")
    vertices <- data.frame(label = "lh_frontal")
    vertices$vertices <- list(1L:3L)

    expect_error(
      brain_atlas(
        atlas = c("test", "test"),
        type = "cortical",
        core = core,
        data = cortical_data(vertices = vertices)
      ),
      "must be a single character string"
    )
  })

  it("validates type matches data class", {
    core <- data.frame(hemi = "left", region = "frontal", label = "lh_frontal")
    vertices <- data.frame(label = "lh_frontal")
    vertices$vertices <- list(1L:3L)

    expect_error(
      brain_atlas(
        atlas = "test",
        type = "subcortical",
        core = core,
        data = cortical_data(vertices = vertices)
      ),
      "requires.*subcortical_data"
    )
  })

  it("errors when core is missing required columns", {
    core <- data.frame(hemi = "left", region = "frontal")
    vertices <- data.frame(label = "lh_frontal")
    vertices$vertices <- list(1L:3L)

    expect_error(
      brain_atlas(
        atlas = "test",
        type = "cortical",
        core = core,
        data = cortical_data(vertices = vertices)
      ),
      "must contain columns.*label"
    )
  })

  it("accepts and stores palette", {
    core <- data.frame(hemi = "left", region = "frontal", label = "lh_frontal")
    vertices <- data.frame(label = "lh_frontal")
    vertices$vertices <- list(1L:3L)
    palette <- c(lh_frontal = "#FF0000")

    atlas <- brain_atlas(
      atlas = "test",
      type = "cortical",
      palette = palette,
      core = core,
      data = cortical_data(vertices = vertices)
    )

    expect_equal(atlas$palette, palette)
  })

  it("errors when core is not a data.frame", {
    vertices <- data.frame(label = "lh_frontal")
    vertices$vertices <- list(1L:3L)

    expect_error(
      brain_atlas(
        atlas = "test",
        type = "cortical",
        core = list(hemi = "left"),
        data = cortical_data(vertices = vertices)
      ),
      "must be a data.frame"
    )
  })

  it("errors when data is not brain_atlas_data", {
    core <- data.frame(hemi = "left", region = "frontal", label = "lh_frontal")

    expect_error(
      brain_atlas(
        atlas = "test",
        type = "cortical",
        core = core,
        data = data.frame(label = "test")
      ),
      "must be a.*brain_atlas_data"
    )
  })
})


describe("is_brain_atlas", {
  it("returns TRUE for brain_atlas objects", {
    core <- data.frame(hemi = "left", region = "frontal", label = "lh_frontal")
    vertices <- data.frame(label = "lh_frontal")
    vertices$vertices <- list(1L:3L)

    atlas <- brain_atlas(
      atlas = "test",
      type = "cortical",
      core = core,
      data = cortical_data(vertices = vertices)
    )

    expect_true(is_brain_atlas(atlas))
  })

  it("returns FALSE for non-brain_atlas objects", {
    expect_false(is_brain_atlas(data.frame()))
    expect_false(is_brain_atlas(list()))
    expect_false(is_brain_atlas(NULL))
    expect_false(is_brain_atlas("string"))
  })
})


describe("print.brain_atlas", {
  it("returns the atlas invisibly", {
    core <- data.frame(hemi = "left", region = "frontal", label = "lh_frontal")
    vertices <- data.frame(label = "lh_frontal")
    vertices$vertices <- list(1L:3L)

    atlas <- brain_atlas(
      atlas = "test",
      type = "cortical",
      core = core,
      data = cortical_data(vertices = vertices)
    )

    expect_invisible(print(atlas))
    expect_s3_class(print(atlas), "brain_atlas")
  })

  it("prints atlas with sf without error", {
    sf_geom <- sf::st_sf(
      label = c("lh_frontal", "rh_frontal"),
      view = c("lateral", "medial"),
      geometry = sf::st_sfc(
        make_polygon(),
        make_polygon2()
      )
    )
    core <- data.frame(
      hemi = c("left", "right"),
      region = c("frontal", "frontal"),
      label = c("lh_frontal", "rh_frontal")
    )

    atlas <- brain_atlas(
      atlas = "test",
      type = "cortical",
      core = core,
      data = cortical_data(sf = sf_geom)
    )

    expect_invisible(print(atlas))
    expect_s3_class(print(atlas), "brain_atlas")
  })

  it("prints atlas with meshes without error", {
    meshes <- data.frame(label = "hippocampus")
    meshes$mesh <- list(list(
      vertices = data.frame(x = 1:10, y = 1:10, z = 1:10),
      faces = data.frame(i = 1:3, j = 2:4, k = 3:5)
    ))
    core <- data.frame(hemi = NA, region = "hippocampus", label = "hippocampus")

    atlas <- brain_atlas(
      atlas = "test",
      type = "subcortical",
      core = core,
      data = subcortical_data(meshes = meshes)
    )

    expect_invisible(print(atlas))
    expect_s3_class(print(atlas), "brain_atlas")
  })

  it("prints atlas with sf only without error", {
    sf_geom <- sf::st_sf(
      label = "lh_frontal",
      view = "lateral",
      geometry = sf::st_sfc(
        make_polygon()
      )
    )
    core <- data.frame(hemi = "left", region = "frontal", label = "lh_frontal")

    atlas <- brain_atlas(
      atlas = "test",
      type = "cortical",
      core = core,
      data = cortical_data(sf = sf_geom)
    )

    expect_invisible(print(atlas))
    expect_s3_class(print(atlas), "brain_atlas")
  })
})


describe("as.list.brain_atlas", {
  it("converts brain_atlas to list", {
    core <- data.frame(hemi = "left", region = "frontal", label = "lh_frontal")
    vertices <- data.frame(label = "lh_frontal")
    vertices$vertices <- list(1L:3L)

    atlas <- brain_atlas(
      atlas = "test",
      type = "cortical",
      core = core,
      data = cortical_data(vertices = vertices)
    )

    result <- as.list(atlas)

    expect_type(result, "list")
    expect_equal(result$atlas, "test")
    expect_equal(result$type, "cortical")
    expect_true("data" %in% names(result))
  })
})


describe("as.data.frame.brain_atlas", {
  it("converts brain_atlas with sf to data.frame", {
    sf_geom <- sf::st_sf(
      label = c("lh_frontal", "rh_frontal"),
      view = c("lateral", "lateral"),
      geometry = sf::st_sfc(
        make_polygon(),
        make_polygon2()
      )
    )
    core <- data.frame(
      hemi = c("left", "right"),
      region = c("frontal", "frontal"),
      label = c("lh_frontal", "rh_frontal")
    )
    palette <- c(lh_frontal = "#FF0000", rh_frontal = "#00FF00")

    atlas <- brain_atlas(
      atlas = "test",
      type = "cortical",
      palette = palette,
      core = core,
      data = cortical_data(sf = sf_geom)
    )

    result <- as.data.frame(atlas)

    expect_s3_class(result, "sf")
    expect_true("atlas" %in% names(result))
    expect_true("type" %in% names(result))
    expect_true("colour" %in% names(result))
  })

  it("errors when atlas has no sf data", {
    core <- data.frame(hemi = "left", region = "frontal", label = "lh_frontal")
    vertices <- data.frame(label = "lh_frontal")
    vertices$vertices <- list(1L:3L)

    atlas <- brain_atlas(
      atlas = "test",
      type = "cortical",
      core = core,
      data = cortical_data(vertices = vertices)
    )

    expect_error(as.data.frame(atlas), "no 2D geometry")
  })

  it("properly merges core columns", {
    sf_geom <- sf::st_sf(
      label = c("lh_frontal", "rh_frontal"),
      view = c("lateral", "lateral"),
      geometry = sf::st_sfc(
        make_polygon(),
        make_polygon2()
      )
    )
    core <- data.frame(
      hemi = c("left", "right"),
      region = c("frontal", "frontal"),
      label = c("lh_frontal", "rh_frontal"),
      lobe = c("frontal_lobe", "frontal_lobe")
    )

    atlas <- brain_atlas(
      atlas = "test",
      type = "cortical",
      core = core,
      data = cortical_data(sf = sf_geom)
    )

    result <- as.data.frame(atlas)

    expect_true("lobe" %in% names(result))
    expect_true("hemi" %in% names(result))
  })

  it("removes duplicate core columns from sf before merge", {
    sf_geom <- sf::st_sf(
      label = c("lh_frontal"),
      hemi = c("left"),
      region = c("frontal"),
      view = c("lateral"),
      geometry = sf::st_sfc(
        make_polygon()
      )
    )
    core <- data.frame(
      hemi = "left",
      region = "frontal",
      label = "lh_frontal"
    )

    atlas <- brain_atlas(
      atlas = "test",
      type = "cortical",
      core = core,
      data = cortical_data(sf = sf_geom)
    )

    result <- as.data.frame(atlas)

    expect_equal(sum(names(result) == "hemi"), 1)
    expect_equal(sum(names(result) == "region"), 1)
  })

  it("handles legacy atlas with sf directly in data", {
    sf_geom <- sf::st_sf(
      hemi = c("left"),
      region = c("frontal"),
      label = c("lh_frontal"),
      view = c("lateral"),
      geometry = sf::st_sfc(
        make_polygon()
      )
    )

    legacy <- structure(
      list(
        atlas = "legacy",
        type = "cortical",
        data = sf_geom,
        core = NULL,
        palette = NULL
      ),
      class = "brain_atlas"
    )

    result <- as.data.frame(legacy)

    expect_s3_class(result, "sf")
    expect_true("atlas" %in% names(result))
  })
})
