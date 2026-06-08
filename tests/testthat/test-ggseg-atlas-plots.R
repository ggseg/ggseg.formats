describe("plot.ggseg_atlas", {
  it("plots dk atlas", {
    expect_no_error(plot(dk()))
  })

  it("forwards ... to the underlying graphics primitives", {
    expect_no_error(plot(dk(), lwd = 0.5, border = "black"))
  })

  it("plots atlases with holes without warning", {
    # aseg/tracula carry multi-ring regions exercising the polypath branch
    expect_no_warning(plot(aseg()))
    expect_no_warning(plot(tracula()))
  })

  it("errors when atlas has no geometry", {
    k <- dk()
    k$data$sf <- NULL
    expect_error(plot(k), "no 2D geometry")
  })

  it("returns the atlas invisibly", {
    result <- plot(dk())
    expect_s3_class(result, "ggseg_atlas")
  })
})

describe("resolve_fill_colors", {
  it("uses palette entries where present", {
    palette <- c(a = "#FF0000", b = "#00FF00")
    cols <- resolve_fill_colors(c("a", "b"), palette)
    expect_equal(cols, c(a = "#FF0000", b = "#00FF00"))
  })

  it("falls back to grey for labels missing from the palette", {
    cols <- resolve_fill_colors(c("a", "missing"), c(a = "#FF0000"))
    expect_equal(unname(cols["missing"]), "#CCCCCC")
  })

  it("falls back to grey for NA palette entries", {
    cols <- resolve_fill_colors(
      c("a", "b"),
      c(a = "#FF0000", b = NA_character_)
    )
    expect_equal(unname(cols["b"]), "#CCCCCC")
  })

  it("deduplicates labels", {
    cols <- resolve_fill_colors(
      c("a", "a", "b"),
      c(a = "#FF0000", b = "#00FF00")
    )
    expect_equal(names(cols), c("a", "b"))
  })

  it("generates one valid hcl colour per label when no palette", {
    cols <- resolve_fill_colors(c("a", "b", "c"), NULL)
    expect_length(cols, 3L)
    expect_equal(names(cols), c("a", "b", "c"))
    expect_true(all(grepl("^#[0-9A-Fa-f]{6}$", cols)))
  })

  it("is deterministic without a seed", {
    expect_identical(
      resolve_fill_colors(c("a", "b", "c"), NULL),
      resolve_fill_colors(c("a", "b", "c"), NULL)
    )
  })
})
