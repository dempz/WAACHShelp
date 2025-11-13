library(testthat)

test_that("proc_contents is deprecated", {
  lifecycle::expect_deprecated(proc_contents(iris))
})

