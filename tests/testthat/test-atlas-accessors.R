describe("atlas_palette", {
  it("returns palette from dk atlas by name", {
    pal <- atlas_palette("dk")
    expect_type(pal, "character")
    expect_true(length(pal) > 0)
    expect_true(all(grepl("^#", pal)))
  })

  it("returns palette from aseg atlas by name", {
    pal <- atlas_palette("aseg")
    expect_type(pal, "character")
    expect_true(length(pal) > 0)
  })

  it("returns palette from atlas object directly", {
    pal <- atlas_palette(dk)
    expect_type(pal, "character")
    expect_true(length(pal) > 0)
  })

  it("errors when atlas not found", {
    expect_error(atlas_palette("nonexistent_atlas"), "not found")
  })

  it("errors when object is not a ggseg_atlas", {
    my_df <- data.frame(x = 1)
    expect_error(atlas_palette("my_df"), "Could not find atlas")
  })
})

describe("atlas_sf", {
  it("returns sf data from atlas", {
    sf_data <- atlas_sf(dk)
    expect_s3_class(sf_data, "sf")
  })

  it("errors when atlas is not brain_atlas", {
    expect_error(atlas_sf(list()), "must be a")
  })

  it("errors when atlas has no sf data", {
    atlas <- dk
    atlas$data$sf <- NULL
    expect_error(atlas_sf(atlas), "does not contain sf")
  })

  it("returns sf joined with core and palette", {
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

    atlas <- ggseg_atlas(
      atlas = "test",
      type = "cortical",
      palette = palette,
      core = core,
      data = ggseg_data_cortical(sf = sf_geom)
    )

    result <- atlas_sf(atlas)

    expect_s3_class(result, "sf")
    expect_equal(nrow(result), 2)
    expect_true("hemi" %in% names(result))
    expect_true("region" %in% names(result))
    expect_true("colour" %in% names(result))
  })

  it("removes hemi/region from sf before merge", {
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

    atlas <- ggseg_atlas(
      atlas = "test",
      type = "cortical",
      core = core,
      data = ggseg_data_cortical(sf = sf_geom)
    )

    result <- atlas_sf(atlas)

    expect_true("hemi" %in% names(result))
    expect_true("region" %in% names(result))
  })
})


describe("atlas_vertices", {
  it("returns vertices joined with core and palette", {
    core <- data.frame(
      hemi = c("left", "right"),
      region = c("frontal", "frontal"),
      label = c("lh_frontal", "rh_frontal")
    )
    vertices <- data.frame(label = c("lh_frontal", "rh_frontal"))
    vertices$vertices <- list(1L:3L, 4L:6L)
    palette <- c(lh_frontal = "#FF0000", rh_frontal = "#00FF00")

    atlas <- ggseg_atlas(
      atlas = "test",
      type = "cortical",
      palette = palette,
      core = core,
      data = ggseg_data_cortical(vertices = vertices)
    )

    result <- atlas_vertices(atlas)

    expect_equal(nrow(result), 2)
    expect_true("hemi" %in% names(result))
    expect_true("region" %in% names(result))
    expect_true("colour" %in% names(result))
    expect_equal(result$colour, c("#FF0000", "#00FF00"))
  })

  it("errors for atlas without vertices", {
    meshes <- data.frame(label = "hippocampus")
    meshes$mesh <- list(list(
      vertices = data.frame(x = 1:10, y = 1:10, z = 1:10),
      faces = data.frame(i = 1:3, j = 2:4, k = 3:5)
    ))
    core <- data.frame(hemi = NA, region = "hippocampus", label = "hippocampus")

    atlas <- ggseg_atlas(
      atlas = "test",
      type = "subcortical",
      core = core,
      data = ggseg_data_subcortical(meshes = meshes)
    )

    expect_error(atlas_vertices(atlas), "does not contain vertices")
  })

  it("returns vertices without colour column when no palette", {
    core <- data.frame(
      hemi = c("left", "right"),
      region = c("frontal", "frontal"),
      label = c("lh_frontal", "rh_frontal")
    )
    vertices <- data.frame(label = c("lh_frontal", "rh_frontal"))
    vertices$vertices <- list(1L:3L, 4L:6L)

    atlas <- ggseg_atlas(
      atlas = "test",
      type = "cortical",
      core = core,
      data = ggseg_data_cortical(vertices = vertices)
    )

    result <- atlas_vertices(atlas)

    expect_false("colour" %in% names(result))
  })

  it("errors for non-ggseg_atlas input", {
    expect_error(atlas_vertices(data.frame()), "must be a.*ggseg_atlas")
  })
})


describe("atlas_meshes", {
  it("returns meshes joined with core and palette", {
    meshes <- data.frame(label = "hippocampus")
    meshes$mesh <- list(list(
      vertices = data.frame(x = 1:10, y = 1:10, z = 1:10),
      faces = data.frame(i = 1:3, j = 2:4, k = 3:5)
    ))
    core <- data.frame(hemi = NA, region = "hippocampus", label = "hippocampus")
    palette <- c(hippocampus = "#FF0000")

    atlas <- ggseg_atlas(
      atlas = "test",
      type = "subcortical",
      palette = palette,
      core = core,
      data = ggseg_data_subcortical(meshes = meshes)
    )

    result <- atlas_meshes(atlas)

    expect_equal(nrow(result), 1)
    expect_true("colour" %in% names(result))
    expect_equal(result$colour, "#FF0000")
  })

  it("errors for atlas without meshes", {
    core <- data.frame(hemi = "left", region = "frontal", label = "lh_frontal")
    vertices <- data.frame(label = "lh_frontal")
    vertices$vertices <- list(1L:3L)

    atlas <- ggseg_atlas(
      atlas = "test",
      type = "cortical",
      core = core,
      data = ggseg_data_cortical(vertices = vertices)
    )

    expect_error(atlas_meshes(atlas), "does not contain meshes")
  })

  it("returns meshes without colour column when no palette", {
    meshes <- data.frame(label = "hippocampus")
    meshes$mesh <- list(list(
      vertices = data.frame(x = 1:10, y = 1:10, z = 1:10),
      faces = data.frame(i = 1:3, j = 2:4, k = 3:5)
    ))
    core <- data.frame(hemi = NA, region = "hippocampus", label = "hippocampus")

    atlas <- ggseg_atlas(
      atlas = "test",
      type = "subcortical",
      core = core,
      data = ggseg_data_subcortical(meshes = meshes)
    )

    result <- atlas_meshes(atlas)

    expect_false("colour" %in% names(result))
  })

  it("errors for non-ggseg_atlas input", {
    expect_error(atlas_meshes(data.frame()), "must be a.*ggseg_atlas")
  })
})


describe("brain_pal (deprecated)", {
  it("warns and returns palette", {
    lifecycle::expect_deprecated(
      result <- brain_pal("dk")
    )
    expect_type(result, "character")
    expect_true(length(result) > 0)
  })
})
