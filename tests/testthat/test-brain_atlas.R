describe("brain_atlas class", {
  it("dk is a brain_atlas", {
    expect_true(is_brain_atlas(dk))
    expect_s3_class(dk, "brain_atlas")
  })

  it("as_brain_atlas round-trips", {
    result <- as_brain_atlas(dk)
    expect_s3_class(result, "brain_atlas")
  })

  it("as.data.frame returns sf data", {
    df <- as.data.frame(dk)
    expect_true(inherits(df, "data.frame"))
    expect_true("geometry" %in% names(df))
    expect_true("region" %in% names(df))
    expect_true("hemi" %in% names(df))
    expect_true("view" %in% names(df))
  })

  it("print method works", {
    output <- capture.output(print(dk))
    expect_true(length(output) > 0)
  })

  it("atlas_regions returns character vector", {
    regions <- atlas_regions(dk)
    expect_type(regions, "character")
    expect_true(length(regions) > 0)
  })

  it("atlas_labels returns character vector", {
    labels <- atlas_labels(dk)
    expect_type(labels, "character")
    expect_true(length(labels) > 0)
  })

  it("atlas_views returns character vector", {
    views <- atlas_views(dk)
    expect_type(views, "character")
    expect_true(all(c("lateral", "medial") %in% views))
  })

  it("aseg atlas works", {
    expect_true(is_brain_atlas(aseg))
    df <- as.data.frame(aseg)
    expect_true(inherits(df, "data.frame"))
  })
})


describe("is_*_atlas helpers", {
  it("is_cortical_atlas identifies cortical atlases", {
    expect_true(is_cortical_atlas(dk))
    expect_false(is_cortical_atlas(aseg))
    expect_false(is_cortical_atlas(tracula))
    expect_false(is_cortical_atlas(list()))
  })

  it("is_subcortical_atlas identifies subcortical atlases", {
    expect_true(is_subcortical_atlas(aseg))
    expect_false(is_subcortical_atlas(dk))
    expect_false(is_subcortical_atlas(tracula))
    expect_false(is_subcortical_atlas(NULL))
  })

  it("is_tract_atlas identifies tract atlases", {
    expect_true(is_tract_atlas(tracula))
    expect_false(is_tract_atlas(dk))
    expect_false(is_tract_atlas(aseg))
    expect_false(is_tract_atlas("string"))
  })

  it("is_brain_atlas matches all subtypes", {
    expect_true(is_brain_atlas(dk))
    expect_true(is_brain_atlas(aseg))
    expect_true(is_brain_atlas(tracula))
  })

  it("rejects objects with faked class", {
    fake <- structure(list(x = 1), class = "brain_atlas")
    expect_false(is_brain_atlas(fake))

    fake_cortical <- structure(
      list(x = 1),
      class = c("cortical_atlas", "brain_atlas")
    )
    expect_false(is_cortical_atlas(fake_cortical))
  })
})
