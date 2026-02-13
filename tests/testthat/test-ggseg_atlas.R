describe("ggseg_atlas class", {
  it("dk is a ggseg_atlas", {
    expect_true(is_ggseg_atlas(dk))
    expect_s3_class(dk, "ggseg_atlas")
  })

  it("as_ggseg_atlas round-trips", {
    result <- as_ggseg_atlas(dk)
    expect_s3_class(result, "ggseg_atlas")
  })

  it("as.data.frame returns sf data", {
    df <- as.data.frame(dk)
    expect_true(inherits(df, "data.frame"))
    expect_true("geometry" %in% names(df))
    expect_true("region" %in% names(df))
    expect_true("hemi" %in% names(df))
    expect_true("view" %in% names(df))
  })

  it("print method works", {
    expect_snapshot(print(dk))
  })

  it("atlas_regions returns character vector", {
    regions <- atlas_regions(dk)
    expect_type(regions, "character")
    expect_true(length(regions) > 0)
  })

  it("atlas_labels returns character vector", {
    labels <- atlas_labels(dk)
    expect_type(labels, "character")
    expect_true(length(labels) > 0)
  })

  it("atlas_views returns character vector", {
    views <- atlas_views(dk)
    expect_type(views, "character")
    expect_true(all(c("lateral", "medial") %in% views))
  })

  it("aseg atlas works", {
    expect_true(is_ggseg_atlas(aseg))
    df <- as.data.frame(aseg)
    expect_true(inherits(df, "data.frame"))
  })
})


describe("is_*_atlas helpers", {
  it("is_cortical_atlas identifies cortical atlases", {
    expect_true(is_cortical_atlas(dk))
    expect_false(is_cortical_atlas(aseg))
    expect_false(is_cortical_atlas(tracula))
    expect_false(is_cortical_atlas(list()))
  })

  it("is_subcortical_atlas identifies subcortical atlases", {
    expect_true(is_subcortical_atlas(aseg))
    expect_false(is_subcortical_atlas(dk))
    expect_false(is_subcortical_atlas(tracula))
    expect_false(is_subcortical_atlas(NULL))
  })

  it("is_tract_atlas identifies tract atlases", {
    expect_true(is_tract_atlas(tracula))
    expect_false(is_tract_atlas(dk))
    expect_false(is_tract_atlas(aseg))
    expect_false(is_tract_atlas("string"))
  })

  it("is_ggseg_atlas matches all subtypes", {
    expect_true(is_ggseg_atlas(dk))
    expect_true(is_ggseg_atlas(aseg))
    expect_true(is_ggseg_atlas(tracula))
  })

  it("rejects objects with faked class", {
    fake <- structure(list(x = 1), class = "ggseg_atlas")
    expect_false(is_ggseg_atlas(fake))

    fake_cortical <- structure(
      list(x = 1),
      class = c("cortical_atlas", "ggseg_atlas")
    )
    expect_false(is_cortical_atlas(fake_cortical))
  })
})


describe("ggseg_atlas constructor validation", {
  it("errors when atlas is not a single string", {
    core <- data.frame(hemi = "left", region = "frontal", label = "lh_frontal")
    vertices <- data.frame(label = "lh_frontal")
    vertices$vertices <- list(1L:3L)

    expect_error(
      ggseg_atlas(
        atlas = c("a", "b"), type = "cortical",
        core = core, data = ggseg_data_cortical(vertices = vertices)
      ),
      "single character string"
    )
  })

  it("errors when core missing required columns", {
    core <- data.frame(hemi = "left", name = "frontal")
    vertices <- data.frame(label = "lh_frontal")
    vertices$vertices <- list(1L:3L)

    expect_error(
      ggseg_atlas(
        atlas = "test", type = "cortical",
        core = core, data = ggseg_data_cortical(vertices = vertices)
      ),
      "must contain columns"
    )
  })

  it("errors when data is not ggseg_atlas_data", {
    core <- data.frame(hemi = "left", region = "frontal", label = "lh_frontal")
    expect_error(
      ggseg_atlas(
        atlas = "test", type = "cortical",
        core = core, data = list(sf = NULL)
      ),
      "ggseg_atlas_data"
    )
  })

  it("errors when data type mismatches atlas type", {
    core <- data.frame(hemi = NA, region = "hippocampus", label = "hippocampus")
    meshes <- data.frame(label = "hippocampus")
    meshes$mesh <- list(list(
      vertices = data.frame(x = 1:10, y = 1:10, z = 1:10),
      faces = data.frame(i = 1:3, j = 2:4, k = 3:5)
    ))
    expect_error(
      ggseg_atlas(
        atlas = "test", type = "cortical",
        core = core, data = ggseg_data_subcortical(meshes = meshes)
      ),
      "requires.*ggseg_data_cortical"
    )
  })
})


describe("deprecated wrappers", {
  it("brain_atlas() warns about deprecation", {
    core <- data.frame(hemi = "left", region = "frontal", label = "lh_frontal")
    vertices <- data.frame(label = "lh_frontal")
    vertices$vertices <- list(1L:3L)

    lifecycle::expect_deprecated(
      brain_atlas(
        atlas = "test", type = "cortical",
        core = core, data = ggseg_data_cortical(vertices = vertices)
      )
    )
  })

  it("is_brain_atlas() warns about deprecation", {
    lifecycle::expect_deprecated(is_brain_atlas(dk))
  })
})


describe("as.data.frame.ggseg_atlas", {
  it("infers hemi from label prefixes", {
    sf_geom <- sf::st_sf(
      label = c("lh_frontal", "rh_parietal"),
      view = c("lateral", "lateral"),
      geometry = sf::st_sfc(make_polygon(), make_polygon2())
    )
    core <- data.frame(
      region = c("frontal", "parietal"),
      label = c("lh_frontal", "rh_parietal")
    )
    vertices <- data.frame(label = c("lh_frontal", "rh_parietal"))
    vertices$vertices <- list(1L:3L, 4L:6L)

    atlas <- ggseg_atlas(
      atlas = "test", type = "cortical",
      core = core,
      data = ggseg_data_cortical(sf = sf_geom, vertices = vertices)
    )

    df <- as.data.frame(atlas)
    expect_true("hemi" %in% names(df))
    expect_true(all(df$hemi %in% c("left", "right")))
  })

  it("places context geometry last in row order", {
    sf_geom <- sf::st_sf(
      label = c("lh_medialwall", "lh_frontal"),
      view = c("lateral", "lateral"),
      geometry = sf::st_sfc(make_polygon(), make_polygon2())
    )
    core <- data.frame(
      hemi = "left", region = "frontal", label = "lh_frontal"
    )
    vertices <- data.frame(label = "lh_frontal")
    vertices$vertices <- list(1L:3L)

    atlas <- ggseg_atlas(
      atlas = "test", type = "cortical",
      core = core,
      data = ggseg_data_cortical(sf = sf_geom, vertices = vertices)
    )

    df <- as.data.frame(atlas)
    last_label <- df$label[nrow(df)]
    expect_equal(last_label, "lh_frontal")
  })

  it("errors when atlas has no 2D geometry", {
    core <- data.frame(hemi = "left", region = "frontal", label = "lh_frontal")
    vertices <- data.frame(label = "lh_frontal")
    vertices$vertices <- list(1L:3L)
    atlas <- ggseg_atlas(
      atlas = "test", type = "cortical",
      core = core,
      data = ggseg_data_cortical(vertices = vertices)
    )
    expect_error(as.data.frame(atlas), "no 2D geometry")
  })
})


describe("print.ggseg_atlas", {
  it("prints subcortical atlas with meshes", {
    expect_snapshot(print(aseg))
  })

  it("prints tract atlas with centerlines", {
    expect_snapshot(print(tracula))
  })

  it("prints atlas without palette or 3D data (render_3d = none)", {
    core <- data.frame(
      hemi = "left", region = "frontal", label = "lh_frontal"
    )
    sf_geom <- sf::st_sf(
      label = "lh_frontal", view = "lateral",
      geometry = sf::st_sfc(make_polygon())
    )
    atlas <- ggseg_atlas(
      atlas = "minimal", type = "cortical",
      core = core,
      data = ggseg_data_cortical(sf = sf_geom)
    )
    expect_snapshot(print(atlas))
  })
})


describe("is_ggseg3d_atlas", {
  it("returns TRUE for data.frame with ggseg_3d column", {
    x <- data.frame(ggseg_3d = 1)
    expect_true(is_ggseg3d_atlas(x))
  })

  it("returns FALSE for data.frame without ggseg_3d column", {
    x <- data.frame(a = 1)
    expect_false(is_ggseg3d_atlas(x))
  })

  it("returns FALSE for non-data.frame", {
    expect_false(is_ggseg3d_atlas(list(ggseg_3d = 1)))
  })
})


describe("ggseg_atlas constructor validation", {
  it("errors on vector atlas name", {
    core <- data.frame(
      hemi = "left", region = "frontal", label = "lh_frontal"
    )
    vertices <- data.frame(label = "lh_frontal")
    vertices$vertices <- list(1L:3L)
    expect_error(
      ggseg_atlas(
        atlas = c("a", "b"), type = "cortical",
        core = core, data = ggseg_data_cortical(vertices = vertices)
      ),
      "single character string"
    )
  })
})


describe("as.data.frame.ggseg_atlas edge cases", {
  it("maps palette colours to result", {
    df <- as.data.frame(dk)
    expect_true("colour" %in% names(df))
    expect_true(any(!is.na(df$colour)))
  })

  it("handles sf with hemi column via core merge", {
    sf_geom <- sf::st_sf(
      label = c("lh_frontal", NA_character_),
      view = c("lateral", "lateral"),
      hemi = c("left", NA_character_),
      geometry = sf::st_sfc(make_polygon(), make_polygon2())
    )
    core <- data.frame(
      hemi = "left", region = "frontal", label = "lh_frontal"
    )
    atlas <- ggseg_atlas(
      atlas = "test", type = "cortical",
      core = core,
      data = ggseg_data_cortical(
        sf = sf_geom,
        vertices = data.frame(label = "lh_frontal", vertices = I(list(1L:3L)))
      )
    )
    df <- as.data.frame(atlas)
    expect_true("hemi" %in% names(df))
    expect_equal(df$hemi[df$label == "lh_frontal"], "left")
  })

  it("backfills sf hemi when core hemi is NA", {
    sf_geom <- sf::st_sf(
      label = c("lh_frontal", "context"),
      view = c("lateral", "lateral"),
      hemi = c("left", "bg"),
      geometry = sf::st_sfc(make_polygon(), make_polygon2())
    )
    core <- data.frame(
      hemi = NA_character_, region = "frontal", label = "lh_frontal"
    )
    atlas <- ggseg_atlas(
      atlas = "test", type = "subcortical",
      core = core,
      data = ggseg_data_subcortical(sf = sf_geom)
    )
    df <- as.data.frame(atlas)
    frontal_row <- df[df$label == "lh_frontal", ]
    expect_equal(frontal_row$hemi, "left")
  })

  it("removes rows with missing hemi for cortical atlas", {
    sf_geom <- sf::st_sf(
      label = c("lh_frontal", "no_prefix"),
      view = c("lateral", "lateral"),
      geometry = sf::st_sfc(make_polygon(), make_polygon2())
    )
    core <- data.frame(
      hemi = c("left", NA_character_),
      region = c("frontal", "unknown"),
      label = c("lh_frontal", "no_prefix")
    )
    atlas <- ggseg_atlas(
      atlas = "test", type = "cortical",
      core = core,
      data = ggseg_data_cortical(
        sf = sf_geom,
        vertices = data.frame(
          label = c("lh_frontal", "no_prefix"),
          vertices = I(list(1L:3L, 4L:6L))
        )
      )
    )
    df <- as.data.frame(atlas)
    expect_false("no_prefix" %in% df$label)
  })
})


describe("ggseg_atlas constructor: non-data.frame core", {
  it("errors when core is not a data.frame", {
    vertices <- data.frame(label = "lh_frontal")
    vertices$vertices <- list(1L:3L)
    expect_error(
      ggseg_atlas(
        atlas = "test", type = "cortical",
        core = list(hemi = "left", region = "frontal", label = "lh_frontal"),
        data = ggseg_data_cortical(vertices = vertices)
      ),
      "must be a data.frame"
    )
  })
})


describe("as.data.frame with legacy data structure", {
  it("handles data as raw sf (not ggseg_atlas_data)", {
    sf_geom <- sf::st_sf(
      label = "lh_frontal", view = "lateral",
      geometry = sf::st_sfc(make_polygon())
    )
    core <- data.frame(
      hemi = "left", region = "frontal", label = "lh_frontal"
    )
    atlas <- structure(
      list(
        atlas = "test", type = "cortical",
        palette = c(lh_frontal = "#FF0000"),
        core = core,
        data = sf_geom
      ),
      class = c("cortical_atlas", "ggseg_atlas", "list")
    )
    df <- as.data.frame(atlas)
    expect_true(inherits(df, "data.frame"))
    expect_true("lh_frontal" %in% df$label)
  })

  it("handles NULL core", {
    sf_geom <- sf::st_sf(
      label = "lh_frontal", view = "lateral",
      geometry = sf::st_sfc(make_polygon())
    )
    atlas <- structure(
      list(
        atlas = "test", type = "subcortical",
        palette = NULL,
        core = NULL,
        data = sf_geom
      ),
      class = c("subcortical_atlas", "ggseg_atlas", "list")
    )
    df <- as.data.frame(atlas)
    expect_true(inherits(df, "data.frame"))
    expect_true("lh_frontal" %in% df$label)
  })
})
