describe("get_brain_mesh", {
  it("returns inflated mesh for lh", {
    mesh <- get_brain_mesh(hemisphere = "lh", surface = "inflated")

    expect_true(!is.null(mesh))
    expect_true("vertices" %in% names(mesh))
    expect_true("faces" %in% names(mesh))
    expect_true(nrow(mesh$vertices) > 0)
    expect_true(nrow(mesh$faces) > 0)
    expect_equal(ncol(mesh$vertices), 3)
    expect_equal(ncol(mesh$faces), 3)
  })

  it("returns inflated mesh for rh", {
    mesh <- get_brain_mesh(hemisphere = "rh", surface = "inflated")

    expect_true(!is.null(mesh))
    expect_equal(nrow(mesh$vertices), 10242)
    expect_equal(nrow(mesh$faces), 20480)
  })

  it("returns both hemispheres with same vertex count", {
    lh <- get_brain_mesh(hemisphere = "lh", surface = "inflated")
    rh <- get_brain_mesh(hemisphere = "rh", surface = "inflated")

    expect_equal(nrow(lh$vertices), nrow(rh$vertices))
  })

  it("validates hemisphere argument", {
    expect_error(get_brain_mesh(hemisphere = "invalid"))
  })

  it("errors for non-inflated surfaces without brain_meshes", {
    expect_error(
      get_brain_mesh(hemisphere = "lh", surface = "pial"),
      "not available"
    )
  })

  it("uses user-supplied brain_meshes with lh/rh format", {
    custom_mesh <- list(
      lh = list(
        vertices = data.frame(x = 1:3, y = 4:6, z = 7:9),
        faces = data.frame(i = 1, j = 2, k = 3)
      )
    )

    mesh <- get_brain_mesh(
      hemisphere = "lh", surface = "custom",
      brain_meshes = custom_mesh
    )

    expect_equal(mesh$vertices$x, 1:3)
  })

  it("uses user-supplied brain_meshes with lh_surface format", {
    custom_mesh <- list(
      lh_pial = list(
        vertices = data.frame(x = 10:12, y = 1:3, z = 1:3),
        faces = data.frame(i = 1, j = 2, k = 3)
      )
    )

    mesh <- get_brain_mesh(
      hemisphere = "lh", surface = "pial",
      brain_meshes = custom_mesh
    )

    expect_equal(mesh$vertices$x, 10:12)
  })

  it("returns NULL for missing hemisphere in user-supplied meshes", {
    custom_mesh <- list(
      lh = list(
        vertices = data.frame(x = 1:3, y = 1:3, z = 1:3),
        faces = data.frame(i = 1, j = 2, k = 3)
      )
    )

    mesh <- get_brain_mesh(
      hemisphere = "rh", surface = "inflated",
      brain_meshes = custom_mesh
    )

    expect_null(mesh)
  })
})
