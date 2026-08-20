describe("set_atlas_palette", {
  it("replaces the palette and round-trips through the accessor", {
    a <- dk()
    labs <- atlas_labels(a)
    new_pal <- setNames(rep("#123456", length(labs)), labs)
    a <- set_atlas_palette(a, new_pal)
    expect_identical(atlas_palette(a), new_pal)
  })

  it("warns when the palette does not cover every label", {
    a <- dk()
    labs <- atlas_labels(a)
    expect_warning(
      set_atlas_palette(a, setNames("#123456", labs[1])),
      "does not cover"
    )
  })

  it("errors on an unnamed or non-character value", {
    a <- dk()
    expect_error(
      set_atlas_palette(a, c("#111111", "#222222")),
      "named character"
    )
    expect_error(set_atlas_palette(a, 1:3), "named character")
  })

  it("errors when the object is not an atlas", {
    expect_error(
      set_atlas_palette(data.frame(y = 1), c(a = "#111111")),
      "must be a.*ggseg_atlas"
    )
  })
})

describe("set_atlas_type", {
  it("retypes an atlas whose payload matches the new type", {
    a <- tracula()
    b <- set_atlas_type(a, "tract")
    expect_identical(atlas_type(b), "tract")
    expect_true(is_tract_atlas(b))
    expect_identical(class(b)[1], "tract_atlas")
  })

  it("keeps the ggseg_atlas class and ordering intact", {
    b <- set_atlas_type(tracula(), "tract")
    expect_s3_class(b, c("tract_atlas", "ggseg_atlas", "list"), exact = TRUE)
  })

  it("leaves every other atlas component untouched", {
    a <- tracula()
    b <- set_atlas_type(a, "tract")
    expect_identical(b$core, a$core)
    expect_identical(atlas_palette(b), atlas_palette(a))
    expect_identical(b$data, a$data)
  })

  it("is idempotent when the type is unchanged", {
    a <- aseg()
    expect_identical(set_atlas_type(a, atlas_type(a)), a)
  })

  it("errors when the payload does not match the requested type", {
    expect_error(set_atlas_type(aseg(), "tract"), "requires")
    expect_error(set_atlas_type(dk(), "subcortical"), "requires")
  })

  it("errors on an unknown type", {
    expect_error(set_atlas_type(aseg(), "wibble"), "'arg' should be one of")
  })

  it("errors when the object is not an atlas", {
    expect_error(
      set_atlas_type(data.frame(y = 1), "tract"),
      "must be a.*ggseg_atlas"
    )
  })
})
