describe("plot.ggseg_atlas", {
  it("plots dk atlas", {
    set.seed(1234)
    expect_no_error(plot(dk()))
  })

  it("plots dk atlas without legend argument (ignored)", {
    set.seed(1234)
    expect_no_error(plot(dk(), show.legend = FALSE))
  })

  it("plots aseg atlas", {
    set.seed(1234)
    expect_no_error(plot(aseg()))
  })

  it("plots tracula atlas", {
    set.seed(1234)
    expect_no_error(plot(tracula()))
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
