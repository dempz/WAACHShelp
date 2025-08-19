test_that("sumfun returns a data.frame with correct columns", {
  x <- c(1, 2, 3, 4, 5)
  res <- sumfun(x)

  expect_s3_class(res, "data.frame")
  expect_named(res, c("n", "miss", "mean", "sd", "med", "q25", "q75", "min", "max"))
})

test_that("sumfun calculates correct basic statistics", {
  x <- c(1, 2, 3, 4, 5)
  res <- sumfun(x)

  expect_equal(res$n, length(x))
  expect_equal(res$miss, 0)
  expect_equal(res$mean, mean(x))
  expect_equal(res$sd, sd(x))
  expect_equal(res$med, median(x))
  expect_equal(res$q25, quantile(x, 0.25, names = FALSE))
  expect_equal(res$q75, quantile(x, 0.75, names = FALSE))
  expect_equal(res$min, min(x))
  expect_equal(res$max, max(x))
})

test_that("sumfun handles missing values correctly with na.rm = TRUE", {
  x <- c(1, 2, NA, 4)
  res <- sumfun(x)

  expect_equal(res$miss, 1)
  expect_equal(res$n, length(x))
  expect_equal(res$mean, mean(x, na.rm = TRUE))
})

test_that("sumfun errors with NAs if na.rm = FALSE", {
  x <- c(1, 2, NA, 4)
  expect_error(sumfun(x, na.rm = FALSE), "missing values and NaN's not allowed")
})
