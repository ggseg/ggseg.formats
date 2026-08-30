describe("atlas_structure_reorder()", {
  drawn <- function(atlas) ggseg.formats::atlas_geom(atlas)$label

  it("moves a structure after another", {
    a <- aseg()
    before <- drawn(a)
    out <- atlas_structure_reorder(
      a,
      before[2],
      .after = before[5]
    )

    expect_identical(
      drawn(out),
      c(before[c(1, 3, 4, 5, 2)], before[-(1:5)])
    )
  })

  it("moves a structure before another", {
    a <- aseg()
    before <- drawn(a)
    out <- atlas_structure_reorder(a, before[5], .before = before[2])

    expect_identical(
      drawn(out),
      c(before[c(1, 5, 2, 3, 4)], before[-(1:5)])
    )
  })

  it("moves to the front when given no anchor, as relocate() does", {
    a <- aseg()
    before <- drawn(a)
    out <- atlas_structure_reorder(a, before[4])

    expect_identical(drawn(out), c(before[4], before[-4]))
  })

  it("keeps the order the structures were named in", {
    a <- aseg()
    before <- drawn(a)
    out <- atlas_structure_reorder(a, before[c(5, 2)])

    expect_identical(drawn(out)[1:2], before[c(5, 2)])
  })

  it("moves both hemispheres when given a region", {
    a <- aseg()
    region <- atlas_regions(a)[1]
    out <- atlas_structure_reorder(a, region, match_on = "region")

    moved <- a$core$label[a$core$region == region]
    expect_setequal(utils::head(drawn(out), length(moved)), moved)
  })

  it("leaves core, palette and type alone", {
    a <- aseg()
    out <- atlas_structure_reorder(a, drawn(a)[2], .after = drawn(a)[4])

    expect_identical(out$core, a$core)
    expect_identical(atlas_palette(out), atlas_palette(a))
    expect_identical(atlas_type(out), atlas_type(a))
    expect_setequal(drawn(out), drawn(a))
  })

  it("errors on an unknown structure", {
    expect_snapshot(
      atlas_structure_reorder(aseg(), "notastructure"),
      error = TRUE
    )
  })

  it("errors when given both anchors", {
    a <- aseg()
    expect_snapshot(
      atlas_structure_reorder(
        a,
        drawn(a)[1],
        .before = drawn(a)[2],
        .after = drawn(a)[3]
      ),
      error = TRUE
    )
  })

  it("errors when the anchor is one of the structures moved", {
    a <- aseg()
    expect_snapshot(
      atlas_structure_reorder(a, drawn(a)[1], .after = drawn(a)[1]),
      error = TRUE
    )
  })

  it("errors on a non-atlas", {
    expect_snapshot(
      atlas_structure_reorder(list(), "x"),
      error = TRUE
    )
  })
})
