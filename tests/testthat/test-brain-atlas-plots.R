library(vdiffr, quietly = TRUE, warn.conflicts = FALSE)

describe("plot.brain_atlas", {
  it("plots dk atlas", {
    set.seed(1234)
    expect_doppelganger("brain atlas dk plot", plot(dk))
  })

  it("plots dk atlas without legend", {
    set.seed(1234)
    expect_doppelganger(
      "brain atlas dk plot noleg",
      plot(dk, show.legend = FALSE)
    )
  })

  it("plots aseg atlas", {
    set.seed(1234)
    expect_doppelganger("brain atlas aseg plot", plot(aseg))
  })

  it("plots tracula atlas", {
    set.seed(1234)
    expect_doppelganger("brain atlas tracula plot", plot(tracula))
  })

  it("errors when atlas has no geometry", {
    k <- dk
    k$data$sf <- NULL
    expect_error(plot(k), "no 2D geometry")
  })

  it("returns a ggplot object", {
    p <- plot(dk)
    expect_s3_class(p, "gg")
  })

  it("includes atlas name in title", {
    p <- plot(dk)
    expect_true(grepl("dk", p$labels$title))
  })

  it("applies palette when available", {
    p <- plot(dk)
    has_fill_scale <- any(vapply(
      p$scales$scales,
      function(s) "fill" %in% s$aesthetics,
      logical(1)
    ))
    expect_true(has_fill_scale)
  })
})
