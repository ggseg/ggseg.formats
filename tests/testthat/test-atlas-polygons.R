describe("sf_to_polygons()", {
  it("returns one row per label with a nested geometry list-column", {
    polys <- sf_to_polygons(dk()$data$sf)

    expect_s3_class(polys, "brain_polygons")
    expect_s3_class(polys, "tbl_df")
    expect_equal(nrow(polys), length(unique(dk()$data$sf$label)))
    expect_named(polys, c("label", "geometry"))
    expect_true(is.list(polys$geometry))
  })

  it("nested geometry tibbles carry view, x, y, group, subgroup", {
    polys <- sf_to_polygons(dk()$data$sf)
    inner <- polys$geometry[[1]]
    expect_s3_class(inner, "tbl_df")
    expect_named(inner, c("view", "x", "y", "group", "subgroup"))
    expect_type(inner$group, "integer")
    expect_type(inner$subgroup, "integer")
  })

  it("preserves coordinate counts across the conversion", {
    sf0 <- dk()$data$sf
    polys <- sf_to_polygons(sf0)
    n_sf <- sum(vapply(
      sf0$geometry,
      function(g) {
        nrow(sf::st_coordinates(g))
      },
      integer(1)
    ))
    n_poly <- sum(vapply(polys$geometry, nrow, integer(1)))
    expect_equal(n_sf, n_poly)
  })

  it("errors on non-sf input", {
    expect_error(sf_to_polygons(data.frame(a = 1)), "must inherit from class")
  })
})

describe("polygons_to_sf()", {
  it("round-trips dk geometry losslessly (areas equal)", {
    sf0 <- dk()$data$sf
    polys <- sf_to_polygons(sf0)
    sf1 <- polygons_to_sf(polys)

    expect_s3_class(sf1, "sf")
    expect_named(sf1, c("label", "view", "geometry"))

    key0 <- paste(sf0$label, sf0$view, sep = "@@")
    key1 <- paste(sf1$label, sf1$view, sep = "@@")
    o0 <- order(key0)
    o1 <- order(key1)
    a0 <- as.numeric(sf::st_area(sf0$geometry[o0]))
    a1 <- as.numeric(sf::st_area(sf1$geometry[o1]))
    expect_equal(a0, a1)
  })

  it("preserves holes through the round-trip", {
    outer <- matrix(c(0, 0, 10, 0, 10, 10, 0, 10, 0, 0), ncol = 2, byrow = TRUE)
    hole <- matrix(c(2, 2, 8, 2, 8, 8, 2, 8, 2, 2), ncol = 2, byrow = TRUE)
    holey_mp <- sf::st_multipolygon(list(list(outer, hole)))
    solid_mp <- sf::st_multipolygon(list(list(outer)))

    sf_in <- sf::st_sf(
      label = c("holey", "solid"),
      view = c("test", "test"),
      geometry = sf::st_sfc(holey_mp, solid_mp)
    )

    polys <- sf_to_polygons(sf_in)
    holey_nested <- polys$geometry[polys$label == "holey"][[1]]
    expect_equal(sort(unique(holey_nested$subgroup)), c(1L, 2L))

    sf_out <- polygons_to_sf(polys)
    holey_area <- as.numeric(sf::st_area(
      sf_out$geometry[sf_out$label == "holey"]
    ))
    expect_equal(holey_area, 100 - 36)
  })

  it("errors when polygons is malformed", {
    bad <- data.frame(label = "a", geometry = I(list(data.frame(x = 1))))
    expect_error(polygons_to_sf(bad), "missing columns")
  })
})

describe("validate_polygons()", {
  it("rejects non-data.frames", {
    expect_error(validate_polygons(list()), "must be a data.frame")
  })

  it("rejects duplicated labels", {
    bad <- dplyr::tibble(
      label = c("a", "a"),
      geometry = list(
        dplyr::tibble(view = "x", x = 1, y = 1, group = 1L, subgroup = 1L),
        dplyr::tibble(view = "x", x = 2, y = 2, group = 1L, subgroup = 1L)
      )
    )
    expect_error(validate_polygons(bad), "one row per")
  })

  it("rejects missing geometry columns", {
    bad <- dplyr::tibble(
      label = "a",
      geometry = list(dplyr::tibble(view = "x", x = 1, y = 1))
    )
    expect_error(validate_polygons(bad), "missing columns")
  })
})

describe("ggseg_data_cortical() geometry", {
  it("accepts polygons input as geom", {
    polys <- sf_to_polygons(atlas_geom(dk()))
    d <- ggseg_data_cortical(geom = polys)
    expect_s3_class(d$geom, "brain_polygons")
    expect_null(d$sf)
    expect_null(d$polygons)
  })

  it("accepts sf input as geom", {
    d <- ggseg_data_cortical(geom = atlas_geom(dk()))
    expect_s3_class(d$geom, "sf")
  })

  it("converts a deprecated sf= argument to polygons", {
    withr::local_options(lifecycle_verbosity = "quiet")
    d <- ggseg_data_cortical(sf = atlas_geom(dk()))
    expect_s3_class(d$geom, "brain_polygons")
  })

  it("errors with no 2D and no 3D source", {
    expect_error(
      ggseg_data_cortical(),
      "At least one of"
    )
  })
})

describe("as_polygon_atlas() / as_sf_atlas()", {
  it("as_polygon_atlas stores polygons in the geom slot", {
    poly <- as_polygon_atlas(dk())
    expect_true(is_atlas_polygon(poly))
    expect_s3_class(atlas_geom(poly), "brain_polygons")
    expect_null(poly$data$sf)
    expect_null(poly$data$polygons)
    expect_true(is_ggseg_atlas(poly))
  })

  it("as_sf_atlas rehydrates sf into the geom slot", {
    rehy <- as_sf_atlas(as_polygon_atlas(dk()))
    expect_true(is_atlas_sf(rehy))
    expect_s3_class(atlas_geom(rehy), "sf")
  })

  it("is_cortical_atlas still holds after conversion", {
    expect_true(is_cortical_atlas(as_polygon_atlas(dk())))
  })

  it("errors on non-atlas input", {
    expect_error(as_polygon_atlas(list()), "ggseg_atlas")
    expect_error(as_sf_atlas(list()), "ggseg_atlas")
  })
})

describe("migrate_atlas_files()", {
  it("rewrites .rda files to a polygon geom slot", {
    tmp <- withr::local_tempdir()
    atlas <- dk()
    save(atlas, file = file.path(tmp, "atlas.rda"))

    migrated <- migrate_atlas_files(tmp, quiet = TRUE)
    expect_length(migrated, 1)

    env <- new.env()
    load(file.path(tmp, "atlas.rda"), envir = env)
    expect_null(env$atlas$data$sf)
    expect_null(env$atlas$data$polygons)
    expect_s3_class(env$atlas$data$geom, "brain_polygons")
  })

  it("keep_sf = TRUE stores the geom as sf", {
    tmp <- withr::local_tempdir()
    atlas <- dk()
    save(atlas, file = file.path(tmp, "atlas.rda"))

    migrate_atlas_files(tmp, keep_sf = TRUE, quiet = TRUE)

    env <- new.env()
    load(file.path(tmp, "atlas.rda"), envir = env)
    expect_s3_class(env$atlas$data$geom, "sf")
    expect_null(env$atlas$data$sf)
    expect_null(env$atlas$data$polygons)
  })

  it("skips .rda files with no atlas to migrate", {
    tmp <- withr::local_tempdir()
    notatlas <- list(a = 1)
    save(notatlas, file = file.path(tmp, "other.rda"))

    migrated <- migrate_atlas_files(tmp, quiet = TRUE)
    expect_length(migrated, 0)
  })

  it("errors on non-existent path", {
    expect_error(migrate_atlas_files("/no/such/dir"), "does not exist")
  })
})
