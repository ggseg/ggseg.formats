polys <- atlas_polygons(as_polygon_atlas(dk()))

describe("polygons_unnest() / polygons_renest()", {
  it("flattens a brain_polygons table into canonical columns", {
    flat <- polygons_unnest(polys)
    expect_s3_class(flat, "data.frame")
    expect_true(all(
      c("label", "view", "x", "y", "group", "subgroup") %in% names(flat)
    ))
  })

  it("round-trips a brain_polygons table unchanged", {
    renested <- polygons_renest(polygons_unnest(polys))
    expect_s3_class(renested, "brain_polygons")
    expect_setequal(renested$label, polys$label)
  })

  it("returns NULL when re-nesting an empty table", {
    empty <- polygons_unnest(polys)[0, , drop = FALSE]
    expect_null(polygons_renest(empty))
  })
})

describe("polygons_keep_labels()", {
  it("keeps only the requested labels", {
    keep <- polys$label[1:2]
    out <- polygons_keep_labels(polys, keep)
    expect_setequal(out$label, keep)
  })
})

describe("polygons_drop_pattern()", {
  it("drops labels matching the pattern", {
    target <- polys$label[1]
    out <- polygons_drop_pattern(polys, paste0("^", target, "$"))
    expect_false(target %in% out$label)
  })
})

describe("polygon_ring_area()", {
  it("computes the unit-square area as 1", {
    expect_identical(polygon_ring_area(c(0, 1, 1, 0), c(0, 0, 1, 1)), 1)
  })

  it("is independent of vertex orientation", {
    ccw <- polygon_ring_area(c(0, 1, 1, 0), c(0, 0, 1, 1))
    cw <- polygon_ring_area(c(0, 0, 1, 1), c(0, 1, 1, 0))
    expect_identical(ccw, cw)
  })

  it("returns 0 for a degenerate ring", {
    expect_identical(polygon_ring_area(c(0, 1), c(0, 1)), 0)
  })
})
