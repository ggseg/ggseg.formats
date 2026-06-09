describe("migrate_atlas_files()", {
  it("aborts when the target directory does not exist", {
    expect_error(
      migrate_atlas_files(file.path(tempdir(), "does-not-exist-xyz")),
      "does not exist"
    )
  })

  it("warns and returns nothing when the directory has no .rda files", {
    dir <- withr::local_tempdir()
    expect_warning(out <- migrate_atlas_files(dir), "No")
    expect_identical(out, character())
  })

  it("rewrites a legacy sf atlas to brain_polygons in place", {
    dir <- withr::local_tempdir()
    atlas <- dk()
    save(atlas, file = file.path(dir, "atlas.rda"))

    migrated <- migrate_atlas_files(dir, quiet = TRUE)
    expect_length(migrated, 1)

    env <- new.env()
    load(file.path(dir, "atlas.rda"), envir = env)
    expect_s3_class(atlas_geom(env$atlas), "brain_polygons")
    expect_null(env$atlas$data$sf)
  })

  it("stores geometry as sf when keep_sf = TRUE", {
    dir <- withr::local_tempdir()
    atlas <- as_polygon_atlas(dk())
    save(atlas, file = file.path(dir, "atlas.rda"))

    migrate_atlas_files(dir, keep_sf = TRUE, quiet = TRUE)

    env <- new.env()
    load(file.path(dir, "atlas.rda"), envir = env)
    expect_s3_class(atlas_geom(env$atlas), "sf")
  })

  it("skips files that are already in the target representation", {
    dir <- withr::local_tempdir()
    atlas <- as_polygon_atlas(dk())
    save(atlas, file = file.path(dir, "atlas.rda"))

    expect_identical(migrate_atlas_files(dir, quiet = TRUE), character())
  })
})
