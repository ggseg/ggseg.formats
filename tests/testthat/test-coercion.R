describe("as_brain_atlas", {
  it("converts list to brain_atlas", {
    core <- data.frame(hemi = "left", region = "frontal", label = "lh_frontal")
    vertices <- data.frame(label = "lh_frontal")
    vertices$vertices <- list(1L:3L)

    atlas <- brain_atlas(
      atlas = "test",
      type = "cortical",
      core = core,
      data = brain_data_cortical(vertices = vertices)
    )

    lst <- as.list(atlas)
    result <- as_brain_atlas(lst)

    expect_s3_class(result, "brain_atlas")
    expect_equal(result$atlas, "test")
  })

  it("errors for unsupported object types", {
    expect_error(as_brain_atlas(~age), "Cannot convert.*to.*brain_atlas")
  })

  it("errors for empty list", {
    expect_error(as_brain_atlas(list()), "Cannot convert list")
  })
})


describe("as_brain_atlas.brain_atlas", {
  it("converts legacy structure with separate sf/vertices fields", {
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

    legacy <- structure(
      list(
        atlas = "legacy",
        type = "cortical",
        palette = NULL,
        core = core,
        sf = sf_geom,
        vertices = NULL
      ),
      class = "brain_atlas"
    )

    result <- as_brain_atlas(legacy)

    expect_s3_class(result, "brain_atlas")
    expect_s3_class(result$data, "brain_atlas_data")
    expect_equal(result$atlas, "legacy")
  })

  it("returns unchanged if already has proper data structure", {
    core <- data.frame(hemi = "left", region = "frontal", label = "lh_frontal")
    vertices <- data.frame(label = "lh_frontal")
    vertices$vertices <- list(1L:3L)

    atlas <- brain_atlas(
      atlas = "test",
      type = "cortical",
      core = core,
      data = brain_data_cortical(vertices = vertices)
    )

    result <- as_brain_atlas(atlas)
    expect_identical(result, atlas)
  })

  it("errors for unrecognized brain_atlas structure", {
    bad_atlas <- structure(
      list(atlas = "bad", type = "cortical"),
      class = "brain_atlas"
    )

    expect_error(as_brain_atlas(bad_atlas), "unrecognized structure")
  })
})


describe("as_brain_atlas.list", {
  it("converts legacy list with separate sf field", {
    sf_geom <- sf::st_sf(
      label = c("lh_frontal"),
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

    legacy_list <- list(
      atlas = "legacy",
      type = "cortical",
      palette = NULL,
      core = core,
      sf = sf_geom,
      vertices = NULL
    )

    result <- as_brain_atlas(legacy_list)

    expect_s3_class(result, "brain_atlas")
    expect_s3_class(result$data, "brain_atlas_data")
  })
})


describe("convert_legacy_brain_data", {
  it("errors for non-brain_atlas input", {
    expect_error(convert_legacy_brain_data(list()), "must be a.*brain_atlas")
  })

  it("returns atlas unchanged if already has core", {
    core <- data.frame(hemi = "left", region = "frontal", label = "lh_frontal")
    vertices <- data.frame(label = "lh_frontal")
    vertices$vertices <- list(1L:3L)

    atlas <- brain_atlas(
      atlas = "test",
      type = "cortical",
      core = core,
      data = brain_data_cortical(vertices = vertices)
    )

    result <- convert_legacy_brain_data(atlas)
    expect_equal(result, atlas)
  })

  it("converts legacy atlas without core", {
    sf_geom <- sf::st_sf(
      hemi = c("left", "right"),
      region = c("frontal", "frontal"),
      label = c("lh_frontal", "rh_frontal"),
      view = c("lateral", "lateral"),
      colour = c("#FF0000", "#00FF00"),
      geometry = sf::st_sfc(
        make_polygon(),
        make_polygon2()
      )
    )

    legacy <- structure(
      list(
        atlas = "legacy",
        type = "cortical",
        data = sf_geom
      ),
      class = "brain_atlas"
    )

    result <- convert_legacy_brain_data(legacy)

    expect_s3_class(result, "brain_atlas")
    expect_true(!is.null(result$core))
    expect_s3_class(result$data, "brain_atlas_data")
    expect_equal(result$atlas, "legacy")
  })

  it("renames side column to view", {
    sf_geom <- sf::st_sf(
      hemi = c("left", "right"),
      region = c("frontal", "frontal"),
      label = c("lh_frontal", "rh_frontal"),
      side = c("lateral", "lateral"),
      geometry = sf::st_sfc(
        make_polygon(),
        make_polygon2()
      )
    )

    legacy <- structure(
      list(
        atlas = "legacy",
        type = "cortical",
        data = sf_geom
      ),
      class = "brain_atlas"
    )

    result <- convert_legacy_brain_data(legacy)

    expect_s3_class(result, "brain_atlas")
    expect_true("view" %in% names(result$data$sf))
  })

  it("handles legacy atlas without colour column", {
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
        data = sf_geom
      ),
      class = "brain_atlas"
    )

    result <- convert_legacy_brain_data(legacy)

    expect_s3_class(result, "brain_atlas")
    expect_null(result$palette)
  })
})
