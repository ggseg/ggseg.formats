describe("as_tbl", {
  it("applies the tibble classes to a data.frame", {
    out <- as_tbl(data.frame(a = 1:2, b = c("x", "y")))
    expect_s3_class(out, "tbl_df")
    expect_s3_class(out, "tbl")
    expect_s3_class(out, "data.frame")
    expect_identical(class(out), c("tbl_df", "tbl", "data.frame"))
  })

  it("resets row names", {
    df <- data.frame(a = 1:3)
    out <- as_tbl(df[c(3, 1), , drop = FALSE])
    expect_identical(attr(out, "row.names"), 1:2)
  })

  it("preserves list-columns", {
    df <- data.frame(label = "a")
    df$geometry <- list(data.frame(x = 1:2))
    out <- as_tbl(df)
    expect_true(is.list(out$geometry))
    expect_equal(nrow(out$geometry[[1]]), 2)
  })
})

describe("df_distinct", {
  it("returns unique rows over the given columns as a tibble", {
    df <- data.frame(
      hemi = c("l", "l", "r"),
      region = c("a", "a", "b"),
      extra = 1:3
    )
    out <- df_distinct(df, c("hemi", "region"))
    expect_s3_class(out, "tbl_df")
    expect_equal(nrow(out), 2)
    expect_named(out, c("hemi", "region"))
  })
})

describe("df_left_join", {
  it("adds columns and preserves left-hand row order", {
    x <- data.frame(label = c("b", "a", "c"))
    y <- data.frame(label = c("a", "b"), value = c(1, 2))
    out <- df_left_join(x, y, by = "label")
    expect_s3_class(out, "tbl_df")
    expect_equal(out$label, c("b", "a", "c"))
    expect_equal(out$value, c(2, 1, NA))
  })

  it("expands rows one-to-many when keys repeat in y", {
    x <- data.frame(label = "a")
    y <- data.frame(label = c("a", "a"), region = c("r1", "r2"))
    out <- df_left_join(x, y, by = "label")
    expect_equal(nrow(out), 2)
    expect_equal(out$region, c("r1", "r2"))
  })
})

describe("df_bind_rows", {
  it("binds rows and adds the id column first", {
    out <- df_bind_rows(
      list(p = data.frame(v = 1), q = data.frame(v = 2)),
      .id = "subject"
    )
    expect_s3_class(out, "tbl_df")
    expect_named(out, c("subject", "v"))
    expect_equal(out$subject, c("p", "q"))
  })

  it("returns an empty tibble for an empty list", {
    expect_equal(nrow(df_bind_rows(list())), 0)
  })
})

describe("df_nest / df_unnest", {
  it("round-trips a flat table through nesting", {
    flat <- data.frame(
      label = c("a", "a", "b"),
      view = c("lat", "med", "lat"),
      x = c(1, 2, 3)
    )
    nested <- df_nest(flat, "label", "geometry")
    expect_s3_class(nested, "tbl_df")
    expect_equal(nrow(nested), 2)
    expect_true(is.list(nested$geometry))
    expect_s3_class(nested$geometry[[1]], "tbl_df")

    back <- df_unnest(nested, "geometry")
    expect_equal(nrow(back), 3)
    expect_setequal(names(back), names(flat))
  })
})
