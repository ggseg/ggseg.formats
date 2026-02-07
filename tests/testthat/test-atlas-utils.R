make_polygon <- function() {
  coords <- c(0, 0, 1, 0, 1, 1, 0, 0)
  sf::st_polygon(list(matrix(coords, ncol = 2, byrow = TRUE)))
}

describe("brain_regions", {
  it("extracts sorted unique regions from brain_atlas", {
    core <- data.frame(
      hemi = c("left", "left", "right"),
      region = c("frontal", "parietal", "frontal"),
      label = c("lh_frontal", "lh_parietal", "rh_frontal")
    )
    vertices <- data.frame(label = c("lh_frontal", "lh_parietal", "rh_frontal"))
    vertices$vertices <- list(1L:3L, 4L:6L, 7L:9L)

    atlas <- brain_atlas(
      atlas = "test",
      type = "cortical",
      core = core,
      data = cortical_data(vertices = vertices)
    )

    result <- brain_regions(atlas)
    expect_equal(result, c("frontal", "parietal"))
  })

  it("excludes context-only geometry (labels in sf but not in core)", {
    core <- data.frame(
      hemi = "left",
      region = "frontal",
      label = "lh_frontal"
    )
    vertices <- data.frame(label = c("lh_frontal", "lh_unknown"))
    vertices$vertices <- list(1L:3L, 4L:6L)

    atlas <- brain_atlas(
      atlas = "test",
      type = "cortical",
      core = core,
      data = cortical_data(vertices = vertices)
    )

    result <- brain_regions(atlas)
    expect_equal(result, "frontal")
  })
})


describe("brain_labels", {
  it("extracts sorted unique labels from brain_atlas", {
    core <- data.frame(
      hemi = c("left", "left", "right"),
      region = c("frontal", "parietal", "frontal"),
      label = c("lh_frontal", "lh_parietal", "rh_frontal")
    )
    vertices <- data.frame(label = c("lh_frontal", "lh_parietal", "rh_frontal"))
    vertices$vertices <- list(1L:3L, 4L:6L, 7L:9L)

    atlas <- brain_atlas(
      atlas = "test",
      type = "cortical",
      core = core,
      data = cortical_data(vertices = vertices)
    )

    result <- brain_labels(atlas)
    expect_equal(result, c("lh_frontal", "lh_parietal", "rh_frontal"))
  })

  it("excludes NA labels", {
    core <- data.frame(
      hemi = c("left", "left"),
      region = c("frontal", "unknown"),
      label = c("lh_frontal", NA)
    )
    vertices <- data.frame(label = c("lh_frontal", NA))
    vertices$vertices <- list(1L:3L, 4L:6L)

    atlas <- brain_atlas(
      atlas = "test",
      type = "cortical",
      core = core,
      data = cortical_data(vertices = vertices)
    )

    result <- brain_labels(atlas)
    expect_equal(result, "lh_frontal")
  })
})


describe("atlas_type", {
  it("returns the type for brain_atlas", {
    core <- data.frame(hemi = "left", region = "frontal", label = "lh_frontal")
    vertices <- data.frame(label = "lh_frontal")
    vertices$vertices <- list(1L:3L)

    atlas <- brain_atlas(
      atlas = "test",
      type = "cortical",
      core = core,
      data = cortical_data(vertices = vertices)
    )

    expect_equal(atlas_type(atlas), "cortical")
  })

  it("returns subcortical for subcortical atlas", {
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

    expect_equal(atlas_type(atlas), "subcortical")
  })

  it("returns tract for tract atlas", {
    meshes <- data.frame(label = "cst_left")
    meshes$mesh <- list(list(
      vertices = data.frame(x = 1:10, y = 1:10, z = 1:10),
      faces = data.frame(i = 1:3, j = 2:4, k = 3:5)
    ))
    core <- data.frame(hemi = "left", region = "cst", label = "cst_left")

    atlas <- brain_atlas(
      atlas = "test",
      type = "tract",
      core = core,
      data = tract_data(meshes = meshes)
    )

    expect_equal(atlas_type(atlas), "tract")
  })
})


describe("brain_regions.data.frame", {
  it("extracts sorted unique regions from data.frame", {
    df <- data.frame(
      region = c("frontal", "parietal", "frontal", "temporal"),
      other = 1:4
    )

    result <- brain_regions(df)
    expect_equal(result, c("frontal", "parietal", "temporal"))
  })
})




describe("guess_type", {
  it("guesses cortical from medial/lateral views", {
    df <- data.frame(
      type = NA,
      view = c("medial", "lateral")
    )

    expect_warning(
      result <- ggseg.formats:::guess_type(df),
      "attempting to guess"
    )
    expect_equal(result, "cortical")
  })

  it("guesses subcortical when no medial/lateral views", {
    df <- data.frame(
      type = NA,
      view = c("axial", "sagittal")
    )

    expect_warning(
      result <- ggseg.formats:::guess_type(df),
      "attempting to guess"
    )
    expect_equal(result, "subcortical")
  })
})


describe("get_uniq", {
  it("returns sorted unique values excluding NA", {
    df <- data.frame(
      region = c("c", "a", "b", NA, "a"),
      label = c("l1", "l2", "l3", "l4", "l5")
    )

    result <- ggseg.formats:::get_uniq(df, "region")
    expect_equal(result, c("a", "b", "c"))
  })

  it("works with label type", {
    df <- data.frame(
      region = c("r1", "r2"),
      label = c("z_label", "a_label")
    )

    result <- ggseg.formats:::get_uniq(df, "label")
    expect_equal(result, c("a_label", "z_label"))
  })

  it("errors with invalid type", {
    df <- data.frame(region = "r1", label = "l1")

    expect_error(
      ggseg.formats:::get_uniq(df, "invalid"),
      "should be one of"
    )
  })
})


describe("brain_regions.ggseg_atlas", {
  it("extracts regions from ggseg_atlas", {
    ggseg_atlas <- structure(
      data.frame(
        region = c("frontal", "parietal", "frontal"),
        label = c("lh_frontal", "lh_parietal", "rh_frontal")
      ),
      class = c("ggseg_atlas", "data.frame")
    )

    result <- brain_regions(ggseg_atlas)
    expect_equal(result, c("frontal", "parietal"))
  })
})


describe("brain_labels.ggseg_atlas", {
  it("extracts labels from ggseg_atlas", {
    ggseg_atlas <- structure(
      data.frame(
        region = c("frontal", "parietal"),
        label = c("lh_frontal", "lh_parietal")
      ),
      class = c("ggseg_atlas", "data.frame")
    )

    result <- brain_labels(ggseg_atlas)
    expect_equal(result, c("lh_frontal", "lh_parietal"))
  })
})


describe("atlas_type.ggseg_atlas", {
  it("returns type from ggseg_atlas", {
    ggseg_atlas <- structure(
      data.frame(
        region = "frontal",
        type = "cortical"
      ),
      class = c("ggseg_atlas", "data.frame")
    )

    expect_equal(atlas_type(ggseg_atlas), "cortical")
  })
})


describe("guess_type with brain_atlas that has sf", {
  it("guesses type from sf views in brain_atlas", {
    sf_geom <- sf::st_sf(
      label = "lh_frontal",
      view = "lateral",
      geometry = sf::st_sfc(
        make_polygon()
      )
    )

    atlas_with_sf <- structure(
      list(
        atlas = "test",
        type = NA,
        sf = sf_geom
      ),
      class = "brain_atlas"
    )

    expect_warning(
      result <- ggseg.formats:::guess_type(atlas_with_sf),
      "attempting to guess"
    )
    expect_equal(result, "cortical")
  })

  it("returns subcortical when no views available", {
    atlas_no_views <- structure(
      list(
        atlas = "test",
        type = NA,
        sf = NULL
      ),
      class = "brain_atlas"
    )

    expect_warning(
      result <- ggseg.formats:::guess_type(atlas_no_views),
      "attempting to guess"
    )
    expect_equal(result, "subcortical")
  })
})


describe("atlas_region_contextual", {
  it("removes matching regions from core but keeps geometry", {
    core <- data.frame(
      hemi = c("left", "left", "right"),
      region = c("frontal", "unknown", "frontal"),
      label = c("lh_frontal", "lh_unknown", "rh_frontal")
    )
    vertices <- data.frame(label = c("lh_frontal", "lh_unknown", "rh_frontal"))
    vertices$vertices <- list(1L:3L, 4L:6L, 7L:9L)
    palette <- c(lh_frontal = "#FF0000", lh_unknown = "#CCCCCC", rh_frontal = "#FF0000")

    atlas <- brain_atlas(
      atlas = "test",
      type = "cortical",
      core = core,
      data = cortical_data(vertices = vertices),
      palette = palette
    )

    result <- atlas_region_contextual(atlas, "unknown")

    expect_equal(nrow(result$core), 2)
    expect_false("lh_unknown" %in% result$core$label)
    expect_equal(brain_regions(result), "frontal")
    expect_false("lh_unknown" %in% names(result$palette))
    expect_equal(nrow(result$data$vertices), 3)
  })

  it("matches on label when specified", {
    core <- data.frame(
      hemi = c("left", "left"),
      region = c("frontal", "parietal"),
      label = c("lh_frontal", "lh_parietal")
    )
    vertices <- data.frame(label = c("lh_frontal", "lh_parietal"))
    vertices$vertices <- list(1L:3L, 4L:6L)

    atlas <- brain_atlas(
      atlas = "test",
      type = "cortical",
      core = core,
      data = cortical_data(vertices = vertices)
    )

    result <- atlas_region_contextual(atlas, "^lh_f", match_on = "label")

    expect_equal(nrow(result$core), 1)
    expect_equal(result$core$label, "lh_parietal")
  })

  it("preserves NA regions in core", {
    core <- data.frame(
      hemi = c("left", "left"),
      region = c("frontal", NA),
      label = c("lh_frontal", "lh_medialwall")
    )
    vertices <- data.frame(label = c("lh_frontal", "lh_medialwall"))
    vertices$vertices <- list(1L:3L, 4L:6L)

    atlas <- brain_atlas(
      atlas = "test",
      type = "cortical",
      core = core,
      data = cortical_data(vertices = vertices)
    )

    result <- atlas_region_contextual(atlas, "nonexistent")

    expect_equal(nrow(result$core), 2)
  })
})
