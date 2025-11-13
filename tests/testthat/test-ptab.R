library(testthat)

test_that("ptab is deprecated", {
  lifecycle::expect_deprecated(ptab(mtcars))
})
