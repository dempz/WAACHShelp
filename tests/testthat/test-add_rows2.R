library(testthat)

test_that("add_rows2 is deprecated", {
  lifecycle::expect_deprecated(add_rows2(mtcars))
})
