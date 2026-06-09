describe("as_polygon_atlas()", {
  it("converts an sf atlas into the brain_polygons representation", {
    poly <- as_polygon_atlas(dk())
    expect_true(is_atlas_polygon(poly))
    expect_s3_class(atlas_geom(poly), "brain_polygons")
    expect_null(poly$data$sf)
  })

  it("leaves a polygon atlas unchanged", {
    once <- as_polygon_atlas(dk())
    twice <- as_polygon_atlas(once)
    expect_true(is_atlas_polygon(twice))
    expect_setequal(atlas_labels(twice), atlas_labels(once))
  })

  it("errors on non-atlas input", {
    expect_error(as_polygon_atlas(list()), "ggseg_atlas")
  })
})

describe("as_sf_atlas()", {
  it("rehydrates a polygon atlas back into sf", {
    rehy <- as_sf_atlas(as_polygon_atlas(dk()))
    expect_true(is_atlas_sf(rehy))
    expect_s3_class(atlas_geom(rehy), "sf")
  })

  it("preserves region labels through a full round trip", {
    expect_setequal(
      atlas_labels(as_sf_atlas(as_polygon_atlas(dk()))),
      atlas_labels(dk())
    )
  })

  it("errors on non-atlas input", {
    expect_error(as_sf_atlas(list()), "ggseg_atlas")
  })
})
