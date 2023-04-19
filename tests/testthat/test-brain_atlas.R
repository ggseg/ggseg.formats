test_that("brain_atlas works", {

  k <- brain_atlas("test", "cortical", dk$data)
  expect_equal(class(k), "brain_atlas")

  expect_error(brain_atlas("test", "csortical", dk$data))
  expect_error(brain_atlas(c("test", "test"), "cortical", dk$data))

})


test_that("brain-atlas format", {
  k <- capture.output(dk)
  expect_equal(k[1],
               "# dk cortical brain atlas")
  expect_equal(k[2],
               "  regions: 35 ")

})

test_that("as_brain-atlas", {
  expect_error(as_brain_atlas(~age),
               "Cannot make object")

  expect_error(as_brain_atlas(data.frame()),
               "Cannot make object")

  ka <- data.frame(atlas = NA,
                   type = "cortical",
                   hemi = NA,
                   region = NA,
                   side = NA,
                   label = NA)
  expect_error(as_brain_atlas(ka),
               "Cannot make object to brain_atlas")
})

test_that("brain-atlas changes", {

  expect_equal(class(as.list(dk)),
               "list")

  k <- dk
  k$type <- NA
  k <- as.list(k)
  expect_equal(class(k),
               "list")
  expect_true(inherits(as_brain_atlas(k),
                        "brain_atlas"))
})

