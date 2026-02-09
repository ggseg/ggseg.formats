describe("dk atlas", {
  it("is a valid brain_atlas", {
    expect_true(is_ggseg_atlas(dk))
    expect_s3_class(dk, "ggseg_atlas")
  })

  it("has correct atlas name and type", {
    expect_equal(dk$atlas, "dk")
    expect_equal(dk$type, "cortical")
  })

  it("has required core columns", {
    expect_true(all(c("hemi", "region", "label") %in% names(dk$core)))
  })

  it("has valid data structure", {
    expect_s3_class(dk$data, "ggseg_atlas_data")
    expect_s3_class(dk$data, "ggseg_data_cortical")
  })

  it("has both hemispheres", {
    hemis <- unique(dk$core$hemi)
    expect_true("left" %in% hemis)
    expect_true("right" %in% hemis)
  })

  it("has expected number of regions", {
    regions <- atlas_regions(dk)
    expect_gt(length(regions), 30)
  })

  it("has sf geometry for 2D rendering", {
    expect_true(!is.null(dk$data$sf))
    expect_s3_class(dk$data$sf, "sf")
  })
})


describe("aseg atlas", {
  it("is a valid brain_atlas", {
    expect_true(is_ggseg_atlas(aseg))
    expect_s3_class(aseg, "ggseg_atlas")
  })

  it("has correct atlas name and type", {
    expect_equal(aseg$atlas, "aseg")
    expect_equal(aseg$type, "subcortical")
  })

  it("has required core columns", {
    expect_true(all(c("hemi", "region", "label") %in% names(aseg$core)))
  })

  it("has valid data structure", {
    expect_s3_class(aseg$data, "ggseg_atlas_data")
    expect_s3_class(aseg$data, "ggseg_data_subcortical")
  })

  it("has expected subcortical regions", {
    regions <- atlas_regions(aseg)
    expect_gt(length(regions), 5)
  })

  it("has sf geometry for 2D rendering", {
    expect_true(!is.null(aseg$data$sf))
    expect_s3_class(aseg$data$sf, "sf")
  })
})
