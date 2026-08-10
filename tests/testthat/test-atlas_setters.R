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
