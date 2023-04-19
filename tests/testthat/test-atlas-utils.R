test_that("brain_regions works", {
  regs <- unique(dk$data$region)
  regs <- regs[!is.na(regs)]
  regs <- regs[order(regs)]
  expect_equal(brain_regions(dk), regs)

  regs <- unique(aseg$data$region)
  regs <- regs[!is.na(regs)]
  regs <- regs[order(regs)]
  expect_equal(brain_regions(aseg), regs)
})

test_that("brain_labels works", {
  regs <- unique(dk$data$label)
  regs <- regs[!is.na(regs)]
  regs <- regs[order(regs)]
  expect_equal(brain_labels(dk), regs)

  regs <- unique(aseg$data$label)
  regs <- regs[!is.na(regs)]
  regs <- regs[order(regs)]
  expect_equal(brain_labels(aseg), regs)
})

test_that("atlas_type works", {
  expect_equal(atlas_type(dk), dk$type)
  expect_equal(atlas_type(aseg), aseg$type)

  aseg$type <- NA
  expect_warning(k <- atlas_type(aseg), "atlas type not set")
  expect_equal(k, "subcortical")
})
