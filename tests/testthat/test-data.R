describe("dk atlas", {
  it("is a valid brain_atlas", {
    expect_true(is_brain_atlas(dk))
    expect_s3_class(dk, "brain_atlas")
  })

  it("has correct atlas name and type", {
    expect_equal(dk$atlas, "dk")
    expect_equal(dk$type, "cortical")
  })

  it("has required core columns", {
    expect_true(all(c("hemi", "region", "label") %in% names(dk$core)))
  })

  it("has valid data structure", {
    expect_s3_class(dk$data, "brain_atlas_data")
    expect_s3_class(dk$data, "cortical_data")
  })

  it("has both hemispheres", {
    hemis <- unique(dk$core$hemi)
    expect_true("left" %in% hemis)
    expect_true("right" %in% hemis)
  })

  it("has expected number of regions", {
    regions <- brain_regions(dk)
    expect_gt(length(regions), 30)
  })

  it("has sf geometry for 2D rendering", {
    expect_true(!is.null(dk$data$sf))
    expect_s3_class(dk$data$sf, "sf")
  })

  # TODO: reinstate once vertex data is populated

  # it("has vertex data for 3D rendering", {
  #   expect_true(!is.null(dk$data$vertices))
  #   expect_s3_class(dk$data$vertices, "data.frame")
  #   expect_true("vertices" %in% names(dk$data$vertices))
  #   vertex_lengths <- vapply(dk$data$vertices$vertices, length, integer(1))
  #   expect_true(all(vertex_lengths > 0), info = "all regions must have vertex data")
  # })
})


describe("aseg atlas", {
  it("is a valid brain_atlas", {
    expect_true(is_brain_atlas(aseg))
    expect_s3_class(aseg, "brain_atlas")
  })

  it("has correct atlas name and type", {
    expect_equal(aseg$atlas, "aseg")
    expect_equal(aseg$type, "subcortical")
  })

  it("has required core columns", {
    expect_true(all(c("hemi", "region", "label") %in% names(aseg$core)))
  })

  it("has valid data structure", {
    expect_s3_class(aseg$data, "brain_atlas_data")
    expect_s3_class(aseg$data, "subcortical_data")
  })

  it("has expected subcortical regions", {
    regions <- brain_regions(aseg)
    expect_gt(length(regions), 5)
  })

  it("has sf geometry for 2D rendering", {
    expect_true(!is.null(aseg$data$sf))
    expect_s3_class(aseg$data$sf, "sf")
  })
})
