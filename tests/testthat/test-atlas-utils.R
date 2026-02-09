make_polygon <- function() {
  coords <- c(0, 0, 1, 0, 1, 1, 0, 0)
  sf::st_polygon(list(matrix(coords, ncol = 2, byrow = TRUE)))
}

make_test_atlas <- function() {
  sf_geom <- sf::st_sf(
    label = c("lh_frontal", "lh_parietal", "rh_frontal", "lh_unknown"),
    view = c("lateral", "lateral", "medial", "lateral"),
    geometry = sf::st_sfc(
      make_polygon(),
      sf::st_polygon(list(matrix(
        c(2, 2, 4, 2, 4, 4, 2, 2),
        ncol = 2,
        byrow = TRUE
      ))),
      sf::st_polygon(list(matrix(
        c(5, 5, 8, 5, 8, 8, 5, 5),
        ncol = 2,
        byrow = TRUE
      ))),
      sf::st_polygon(list(matrix(
        c(0, 0, 10, 0, 10, 10, 0, 0),
        ncol = 2,
        byrow = TRUE
      )))
    )
  )
  core <- data.frame(
    hemi = c("left", "left", "right"),
    region = c("frontal", "parietal", "frontal"),
    label = c("lh_frontal", "lh_parietal", "rh_frontal"),
    stringsAsFactors = FALSE
  )
  palette <- c(
    lh_frontal = "#FF0000",
    lh_parietal = "#00FF00",
    rh_frontal = "#0000FF"
  )
  vertices <- data.frame(
    label = c("lh_frontal", "lh_parietal", "rh_frontal")
  )
  vertices$vertices <- list(1L:3L, 4L:6L, 7L:9L)

  ggseg_atlas(
    atlas = "test",
    type = "cortical",
    core = core,
    palette = palette,
    data = brain_data_cortical(sf = sf_geom, vertices = vertices)
  )
}

make_multiview_atlas <- function() {
  make_view_poly <- function(x_off, y_off, size = 1) {
    sf::st_polygon(list(matrix(
      c(
        x_off,
        y_off,
        x_off + size,
        y_off,
        x_off + size,
        y_off + size,
        x_off,
        y_off
      ),
      ncol = 2,
      byrow = TRUE
    )))
  }

  core_labels <- c(
    "lh_frontal",
    "lh_parietal",
    "lh_temporal",
    "lh_occipital",
    "lh_insula",
    "rh_frontal",
    "rh_parietal",
    "rh_temporal",
    "rh_occipital",
    "rh_insula"
  )
  small_labels <- c("lh_insula", "rh_insula")
  ctx <- c("ctx_left", "ctx_left", "ctx_right")
  views <- c("axial_1", "axial_2", "sagittal")

  sf_labels <- character(0)
  sf_views <- character(0)
  geoms <- list()

  for (v_idx in seq_along(views)) {
    x_base <- (v_idx - 1) * 40
    for (i in seq_along(core_labels)) {
      sz <- if (core_labels[i] %in% small_labels) 0.5 else 2
      sf_labels <- c(sf_labels, core_labels[i])
      sf_views <- c(sf_views, views[v_idx])
      geoms <- c(geoms, list(make_view_poly(x_base + (i - 1) * 3, 0, sz)))
    }
    sf_labels <- c(sf_labels, ctx[v_idx])
    sf_views <- c(sf_views, views[v_idx])
    geoms <- c(geoms, list(make_view_poly(x_base, 5, 4)))
  }

  sf_geom <- sf::st_sf(
    label = sf_labels,
    view = sf_views,
    geometry = sf::st_sfc(geoms)
  )

  core <- data.frame(
    hemi = c(rep("left", 5), rep("right", 5)),
    region = rep(
      c("frontal", "parietal", "temporal", "occipital", "insula"),
      2
    ),
    label = core_labels,
    stringsAsFactors = FALSE
  )

  palette <- setNames(
    c(
      "#FF0000",
      "#00FF00",
      "#0000FF",
      "#FFFF00",
      "#FF00FF",
      "#00FFFF",
      "#800000",
      "#008000",
      "#000080",
      "#808000"
    ),
    core_labels
  )

  ggseg_atlas(
    atlas = "test",
    type = "cortical",
    core = core,
    palette = palette,
    data = brain_data_cortical(sf = sf_geom)
  )
}


# atlas_regions ----

describe("atlas_regions", {
  it("extracts sorted unique regions from brain_atlas", {
    atlas <- make_test_atlas()
    result <- atlas_regions(atlas)
    expect_equal(result, c("frontal", "parietal"))
  })

  it("excludes context-only geometry (labels in sf but not in core)", {
    atlas <- make_test_atlas()
    result <- atlas_regions(atlas)
    expect_false("unknown" %in% result)
  })

  it("works with data.frame", {
    df <- data.frame(region = c("frontal", "parietal", "frontal"))
    result <- atlas_regions(df)
    expect_equal(result, c("frontal", "parietal"))
  })

  it("works with ggseg_atlas", {
    atlas <- make_test_atlas()
    result <- atlas_regions(atlas)
    expect_true("frontal" %in% result)
    expect_true("parietal" %in% result)
  })
})


# atlas_labels ----

describe("atlas_labels", {
  it("extracts sorted unique labels from brain_atlas", {
    atlas <- make_test_atlas()
    result <- atlas_labels(atlas)
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
    atlas <- ggseg_atlas(
      atlas = "test",
      type = "cortical",
      core = core,
      data = brain_data_cortical(vertices = vertices)
    )
    expect_equal(atlas_labels(atlas), "lh_frontal")
  })
})


# atlas_views ----

describe("atlas_views", {
  it("returns unique view names", {
    atlas <- make_multiview_atlas()
    result <- atlas_views(atlas)
    expect_equal(result, c("axial_1", "axial_2", "sagittal"))
  })

  it("returns NULL when no sf data", {
    atlas <- make_test_atlas()
    atlas$data$sf <- NULL
    expect_null(atlas_views(atlas))
  })
})


# atlas_type ----

describe("atlas_type", {
  it("returns type from brain_atlas", {
    atlas <- make_test_atlas()
    expect_equal(atlas_type(atlas), "cortical")
  })
})


# get_uniq ----

describe("get_uniq", {
  it("returns sorted unique values excluding NA", {
    df <- data.frame(region = c("c", "a", "b", NA, "a"), label = 1:5)
    expect_equal(ggseg.formats:::get_uniq(df, "region"), c("a", "b", "c"))
  })

  it("errors with invalid type", {
    expect_error(ggseg.formats:::get_uniq(data.frame(), "invalid"))
  })
})


# guess_type ----

describe("guess_type", {
  it("guesses cortical from medial/lateral views", {
    df <- data.frame(type = NA, view = c("medial", "lateral"))
    expect_warning(
      result <- ggseg.formats:::guess_type(df),
      "attempting to guess"
    )
    expect_equal(result, "cortical")
  })

  it("guesses subcortical when no medial/lateral views", {
    df <- data.frame(type = NA, view = c("axial", "sagittal"))
    expect_warning(
      result <- ggseg.formats:::guess_type(df),
      "attempting to guess"
    )
    expect_equal(result, "subcortical")
  })
})


# atlas_region_remove ----

describe("atlas_region_remove", {
  it("removes matching regions from core, palette, sf, and vertices", {
    atlas <- make_test_atlas()
    result <- atlas_region_remove(atlas, "parietal")

    expect_false("lh_parietal" %in% result$core$label)
    expect_false("lh_parietal" %in% names(result$palette))
    expect_false("lh_parietal" %in% result$data$sf$label)
    expect_false("lh_parietal" %in% result$data$vertices$label)
  })

  it("matches on label when specified", {
    atlas <- make_test_atlas()
    result <- atlas_region_remove(atlas, "^lh_f", match_on = "label")

    expect_false("lh_frontal" %in% result$core$label)
    expect_equal(nrow(result$core), 2)
  })

  it("preserves NA regions in core", {
    atlas <- make_test_atlas()
    atlas$core$region[1] <- NA
    result <- atlas_region_remove(atlas, "nonexistent")
    expect_equal(nrow(result$core), 3)
  })
})


# atlas_region_contextual ----

describe("atlas_region_contextual", {
  it("removes from core and palette but keeps sf geometry", {
    atlas <- make_test_atlas()
    result <- atlas_region_contextual(atlas, "parietal")

    expect_false("lh_parietal" %in% result$core$label)
    expect_false("lh_parietal" %in% names(result$palette))
    expect_true("lh_parietal" %in% result$data$sf$label)
  })

  it("removes from 3D data", {
    atlas <- make_test_atlas()
    result <- atlas_region_contextual(atlas, "parietal")
    expect_false("lh_parietal" %in% result$data$vertices$label)
  })

  it("matches on label when specified", {
    atlas <- make_test_atlas()
    result <- atlas_region_contextual(atlas, "^lh_f", match_on = "label")
    expect_equal(nrow(result$core), 2)
    expect_equal(result$core$label, c("lh_parietal", "rh_frontal"))
  })
})


# atlas_region_rename ----

describe("atlas_region_rename", {
  it("renames matching regions with string replacement", {
    atlas <- make_test_atlas()
    result <- atlas_region_rename(atlas, "frontal", "prefrontal")
    non_parietal <- result$core$region != "parietal"
    expect_true(all(result$core$region[non_parietal] == "prefrontal"))
  })

  it("renames matching regions with function", {
    atlas <- make_test_atlas()
    result <- atlas_region_rename(atlas, ".*", toupper)
    expect_true(all(result$core$region %in% c("FRONTAL", "PARIETAL")))
  })

  it("does not modify labels", {
    atlas <- make_test_atlas()
    result <- atlas_region_rename(atlas, "frontal", "prefrontal")
    expect_equal(result$core$label, atlas$core$label)
  })

  it("preserves NA regions", {
    atlas <- make_test_atlas()
    atlas$core$region[1] <- NA
    result <- atlas_region_rename(atlas, "parietal", "PARIETAL")
    expect_true(is.na(result$core$region[1]))
  })
})


# atlas_region_keep ----

describe("atlas_region_keep", {
  it("keeps only matching regions in core and palette", {
    atlas <- make_test_atlas()
    result <- atlas_region_keep(atlas, "frontal")

    expect_equal(nrow(result$core), 2)
    expect_true(all(result$core$region == "frontal"))
    expect_equal(length(result$palette), 2)
  })

  it("preserves sf geometry for surface continuity", {
    atlas <- make_test_atlas()
    result <- atlas_region_keep(atlas, "frontal")
    expect_equal(nrow(result$data$sf), nrow(atlas$data$sf))
  })

  it("filters 3D data", {
    atlas <- make_test_atlas()
    result <- atlas_region_keep(atlas, "frontal")
    expect_equal(nrow(result$data$vertices), 2)
  })

  it("matches on label", {
    atlas <- make_test_atlas()
    result <- atlas_region_keep(atlas, "^lh_", match_on = "label")
    expect_equal(nrow(result$core), 2)
  })
})


# atlas_core_add ----

describe("atlas_core_add", {
  it("joins metadata columns to core", {
    atlas <- make_test_atlas()
    meta <- data.frame(
      region = c("frontal", "parietal"),
      lobe = c("frontal", "parietal"),
      stringsAsFactors = FALSE
    )
    result <- atlas_core_add(atlas, meta)
    expect_true("lobe" %in% names(result$core))
    expect_equal(result$core$lobe, c("frontal", "parietal", "frontal"))
  })

  it("joins by custom column", {
    atlas <- make_test_atlas()
    meta <- data.frame(
      label = c("lh_frontal"),
      network = "DMN",
      stringsAsFactors = FALSE
    )
    result <- atlas_core_add(atlas, meta, by = "label")
    expect_true("network" %in% names(result$core))
    expect_equal(result$core$network[1], "DMN")
    expect_true(is.na(result$core$network[2]))
  })
})


# atlas_view_remove ----

describe("atlas_view_remove", {
  it("removes matching views from sf", {
    atlas <- make_multiview_atlas()
    result <- atlas_view_remove(atlas, "axial_1")
    expect_false("axial_1" %in% result$data$sf$view)
    expect_true("axial_2" %in% result$data$sf$view)
  })

  it("removes multiple views with vector", {
    atlas <- make_multiview_atlas()
    result <- atlas_view_remove(atlas, c("axial_1", "axial_2"))
    expect_equal(unique(result$data$sf$view), "sagittal")
  })

  it("warns when no sf data", {
    atlas <- make_test_atlas()
    atlas$data$sf <- NULL
    expect_warning(atlas_view_remove(atlas, "lateral"), "no sf data")
  })

  it("warns when all views removed", {
    atlas <- make_multiview_atlas()
    expect_warning(atlas_view_remove(atlas, ".*"), "All views removed")
  })
})


# atlas_view_keep ----

describe("atlas_view_keep", {
  it("keeps only matching views", {
    atlas <- make_multiview_atlas()
    result <- atlas_view_keep(atlas, "sagittal")
    expect_equal(unique(result$data$sf$view), "sagittal")
  })

  it("keeps multiple views with vector", {
    atlas <- make_multiview_atlas()
    result <- atlas_view_keep(atlas, c("axial_1", "sagittal"))
    expect_equal(sort(unique(result$data$sf$view)), c("axial_1", "sagittal"))
  })

  it("warns when no views match", {
    atlas <- make_multiview_atlas()
    expect_warning(atlas_view_keep(atlas, "nonexistent"), "No views matched")
  })
})


# atlas_view_remove_region ----

describe("atlas_view_remove_region", {
  it("removes region from sf only, keeps core and palette", {
    atlas <- make_multiview_atlas()
    result <- atlas_view_remove_region(atlas, "lh_frontal")

    expect_false("lh_frontal" %in% result$data$sf$label)
    expect_true("lh_frontal" %in% result$core$label)
    expect_true("lh_frontal" %in% names(result$palette))
  })

  it("matches on region via core lookup", {
    atlas <- make_multiview_atlas()
    result <- atlas_view_remove_region(atlas, "frontal", match_on = "region")

    expect_false("lh_frontal" %in% result$data$sf$label)
    expect_false("rh_frontal" %in% result$data$sf$label)
    expect_true("lh_parietal" %in% result$data$sf$label)
  })

  it("preserves NA-label rows", {
    atlas <- make_multiview_atlas()
    atlas$data$sf$label[1] <- NA
    n_na <- sum(is.na(atlas$data$sf$label))
    result <- atlas_view_remove_region(atlas, "insula")
    expect_equal(sum(is.na(result$data$sf$label)), n_na)
  })

  it("preserves context geometry labels", {
    atlas <- make_multiview_atlas()
    result <- atlas_view_remove_region(atlas, "ctx_left")
    expect_false("ctx_left" %in% result$data$sf$label)
  })
})


# atlas_view_remove_small ----

describe("atlas_view_remove_small", {
  it("removes small polygons below threshold", {
    atlas <- make_multiview_atlas()
    n_before <- nrow(atlas$data$sf)
    result <- atlas_view_remove_small(atlas, min_area = 2)
    n_after <- nrow(result$data$sf)
    expect_true(n_after < n_before)
  })

  it("never removes context geometries", {
    atlas <- make_multiview_atlas()
    ctx_labels <- setdiff(atlas$data$sf$label, c(atlas$core$label, NA))
    result <- atlas_view_remove_small(atlas, min_area = 2)
    remaining_labels <- unique(result$data$sf$label)
    expect_true(all(ctx_labels %in% remaining_labels))
  })

  it("scopes to specific views", {
    atlas <- make_multiview_atlas()
    result_all <- atlas_view_remove_small(atlas, min_area = 2)
    result_axial <- atlas_view_remove_small(
      atlas,
      min_area = 2,
      views = "axial"
    )

    expect_true(nrow(result_axial$data$sf) >= nrow(result_all$data$sf))
  })

  it("preserves core and palette", {
    atlas <- make_multiview_atlas()
    result <- atlas_view_remove_small(atlas, min_area = 2)
    expect_equal(result$core, atlas$core)
    expect_equal(result$palette, atlas$palette)
  })

  it("warns when no sf data", {
    atlas <- make_test_atlas()
    atlas$data$sf <- NULL
    expect_warning(
      atlas_view_remove_small(atlas, min_area = 1),
      "no sf data"
    )
  })
})


# atlas_view_gather ----

describe("atlas_view_gather", {
  it("repositions views without gaps", {
    atlas <- make_multiview_atlas()
    trimmed <- atlas_view_remove(atlas, "axial_2")
    result <- atlas_view_gather(trimmed)

    expect_s3_class(result$data$sf, "sf")
    expect_equal(
      sort(unique(result$data$sf$view)),
      sort(unique(trimmed$data$sf$view))
    )
  })

  it("warns when no sf data", {
    atlas <- make_test_atlas()
    atlas$data$sf <- NULL
    expect_warning(atlas_view_gather(atlas), "no sf data")
  })
})


# atlas_view_reorder ----

describe("atlas_view_reorder", {
  it("reorders views as specified", {
    atlas <- make_multiview_atlas()
    result <- atlas_view_reorder(atlas, c("sagittal", "axial_2", "axial_1"))

    views_in_order <- unique(result$data$sf$view)
    expect_equal(views_in_order, c("sagittal", "axial_2", "axial_1"))
  })

  it("appends unspecified views at end", {
    atlas <- make_multiview_atlas()
    result <- atlas_view_reorder(atlas, c("sagittal"))

    views_in_order <- unique(result$data$sf$view)
    expect_equal(views_in_order[1], "sagittal")
    expect_equal(length(views_in_order), 3)
  })

  it("appends all current views when given only nonexistent ones", {
    atlas <- make_multiview_atlas()
    result <- atlas_view_reorder(atlas, "nonexistent")
    expect_equal(length(unique(result$data$sf$view)), 3)
  })
})


# context ordering in as.data.frame ----

describe("as.data.frame context ordering", {
  it("places context geometries before non-context", {
    atlas <- make_test_atlas()
    df <- as.data.frame(atlas)

    is_ctx <- !df$label %in% atlas$core$label | is.na(df$label)
    ctx_positions <- which(is_ctx)
    non_ctx_positions <- which(!is_ctx)

    if (length(ctx_positions) > 0 && length(non_ctx_positions) > 0) {
      expect_true(max(ctx_positions) < min(non_ctx_positions))
    }
  })

  it("works with atlas that has no context geometry", {
    atlas <- make_test_atlas()
    atlas$data$sf <- atlas$data$sf[atlas$data$sf$label %in% atlas$core$label, ]
    df <- as.data.frame(atlas)
    expect_s3_class(df, "sf")
    expect_equal(nrow(df), 3)
  })
})


describe("subclass preservation", {
  it("manipulation functions preserve cortical_atlas subclass", {
    atlas <- make_test_atlas()
    expect_s3_class(atlas, "cortical_atlas")

    expect_s3_class(
      atlas_region_remove(atlas, "parietal"),
      "cortical_atlas"
    )
    expect_s3_class(
      atlas_region_keep(atlas, "frontal"),
      "cortical_atlas"
    )
    expect_s3_class(
      atlas_region_contextual(atlas, "parietal"),
      "cortical_atlas"
    )
    expect_s3_class(
      atlas_region_rename(atlas, "frontal", "front"),
      "cortical_atlas"
    )
    expect_s3_class(
      atlas_core_add(atlas, data.frame(region = "frontal", x = 1)),
      "cortical_atlas"
    )
  })

  it("view functions preserve cortical_atlas subclass", {
    atlas <- make_multiview_atlas()
    expect_s3_class(atlas, "cortical_atlas")

    expect_s3_class(
      atlas_view_remove(atlas, "sagittal"),
      "cortical_atlas"
    )
    expect_s3_class(
      atlas_view_keep(atlas, "axial"),
      "cortical_atlas"
    )
    expect_s3_class(
      atlas_view_remove_region(atlas, "lh_frontal"),
      "cortical_atlas"
    )
    expect_s3_class(
      atlas_view_remove_small(atlas, min_area = 2),
      "cortical_atlas"
    )
    expect_s3_class(atlas_view_gather(atlas), "cortical_atlas")
    expect_s3_class(
      atlas_view_reorder(atlas, c("sagittal", "axial_1", "coronal_2")),
      "cortical_atlas"
    )
  })

  it("bundled atlases have correct subclasses", {
    expect_equal(class(dk), c("cortical_atlas", "ggseg_atlas", "list"))
    expect_equal(class(aseg), c("subcortical_atlas", "ggseg_atlas", "list"))
    expect_equal(class(tracula), c("tract_atlas", "ggseg_atlas", "list"))
  })
})
