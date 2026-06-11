describe("plot.ggseg_atlas", {
  it("plots dk atlas", {
    local_null_pdf()
    expect_no_error(plot(dk()))
  })

  it("forwards ... to the underlying graphics primitives", {
    local_null_pdf()
    expect_no_error(plot(dk(), lwd = 0.5, border = "black"))
  })

  it("plots atlases with holes without warning", {
    local_null_pdf()
    # aseg/tracula carry multi-ring regions exercising the polypath branch
    expect_no_warning(plot(aseg()))
    expect_no_warning(plot(tracula()))
  })

  it("plots a polygon-only (sf-free) atlas without warning", {
    local_null_pdf()
    expect_no_warning(plot(suit()))
  })

  it("errors when atlas has no geometry", {
    k <- dk()
    k$data$sf <- NULL
    expect_error(plot(k), "2D geometry")
  })

  it("returns the atlas invisibly", {
    local_null_pdf()
    result <- plot(dk())
    expect_s3_class(result, "ggseg_atlas")
  })
})

describe("gap_groups", {
  it("keeps densely sampled contiguous values in a single group", {
    vals <- seq(0, 10, by = 0.5)
    expect_identical(gap_groups(vals, 0.2), rep(1L, length(vals)))
  })

  it("splits across an empty band wider than the fraction", {
    # two clusters with a gap of 6 (60% of the span of 10)
    vals <- c(seq(0, 2, by = 0.5), seq(8, 10, by = 0.5))
    expect_identical(gap_groups(vals, 0.2), rep(1:2, each = 5L))
  })

  it("preserves input order, not sorted order", {
    expect_identical(gap_groups(c(100, 1, 101, 2), 0.2), c(2L, 1L, 2L, 1L))
  })

  it("returns one group when all values are equal", {
    expect_identical(gap_groups(c(5, 5, 5), 0.2), c(1L, 1L, 1L))
  })
})

describe("plot_cells", {
  it("separates the two hemispheres of each surface view", {
    flat <- polygons_unnest(atlas_polygons(dk()))
    cells <- plot_cells(flat)
    expect_length(cells, nrow(flat))
    # 4 views x 2 hemispheres
    expect_length(unique(cells), 8L)
  })

  it("keeps each slice view as a single cell for a subcortical atlas", {
    flat <- polygons_unnest(atlas_polygons(aseg()))
    cells <- plot_cells(flat)
    expect_length(unique(cells), length(unique(flat$view)))
  })
})

describe("resolve_fill_colors", {
  it("uses palette entries where present", {
    palette <- c(a = "#FF0000", b = "#00FF00")
    cols <- resolve_fill_colors(c("a", "b"), palette)
    expect_identical(cols, c(a = "#FF0000", b = "#00FF00"))
  })

  it("falls back to grey for labels missing from the palette", {
    cols <- resolve_fill_colors(c("a", "missing"), c(a = "#FF0000"))
    expect_identical(unname(cols["missing"]), "#CCCCCC")
  })

  it("falls back to grey for NA palette entries", {
    cols <- resolve_fill_colors(
      c("a", "b"),
      c(a = "#FF0000", b = NA_character_)
    )
    expect_identical(unname(cols["b"]), "#CCCCCC")
  })

  it("deduplicates labels", {
    cols <- resolve_fill_colors(
      c("a", "a", "b"),
      c(a = "#FF0000", b = "#00FF00")
    )
    expect_named(cols, c("a", "b"))
  })

  it("generates one valid hcl colour per label when no palette", {
    cols <- resolve_fill_colors(c("a", "b", "c"), NULL)
    expect_length(cols, 3L)
    expect_named(cols, c("a", "b", "c"))
    expect_true(all(grepl("^#[0-9A-Fa-f]{6}$", cols)))
  })

  it("is deterministic without a seed", {
    expect_identical(
      resolve_fill_colors(c("a", "b", "c"), NULL),
      resolve_fill_colors(c("a", "b", "c"), NULL)
    )
  })
})
