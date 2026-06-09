describe("ggseg.formats package", {
  it("is an installed, documented package", {
    expect_identical(
      utils::packageDescription("ggseg.formats")$Package,
      "ggseg.formats"
    )
  })

  it("exports its core atlas constructors", {
    constructors <- c("dk", "aseg", "tracula", "suit")
    expect_true(all(vapply(
      constructors,
      function(f) is.function(get(f, envir = asNamespace("ggseg.formats"))),
      logical(1)
    )))
  })
})
