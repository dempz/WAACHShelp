library(testthat)

test_that("check_att errors on invalid inputs", {
  expect_error(
    check_att("2000-01-01"),
    "Please ensure `dob` is of class 'Date'"
  )

  expect_error(
    check_att(as.Date("2000-01-01"), visibility_min = 2008.5),
    "`visibility_min` and `visibility_max` must be integers"
  )

  expect_error(
    check_att(as.Date("2000-01-01"), visibility_min = 2015, visibility_max = 2014),
    "`visibility_min` must not exceed `visibility_max`"
  )

  expect_error(
    check_att(as.Date("2000-01-01"), show_expectation = "yes"),
    "`show_expectation` must be a single logical value"
  )
})

test_that("check_att warns when visibility window ends before dob", {
  expect_warning(
    check_att(as.Date("2020-01-01"), visibility_min = 2000, visibility_max = 2010),
    "Visibility window ends before this date of birth"
  )
})

test_that("check_att returns correct structure (normal_att branch)", {
  out <- check_att(as.Date("1990-05-01"), visibility_min = 2000, visibility_max = 2005)
  expect_type(out, "list")
  expect_named(out, c("results", "n"))
  expect_s3_class(out$results, "data.frame")
  expect_true(is.numeric(out$n))
})

test_that("check_att returns correct structure (staggered_att branch)", {
  out <- check_att(as.Date("2000-05-01"), visibility_min = 2008, visibility_max = 2010)
  expect_type(out, "list")
  expect_named(out, c("results", "n"))
  expect_s3_class(out$results, "data.frame")
  expect_true(is.numeric(out$n))
})

test_that("check_att returns numeric n when show_expectation = FALSE", {
  out <- check_att(as.Date("2000-05-01"),
                   visibility_min = 2008, visibility_max = 2010,
                   show_expectation = FALSE)
  expect_type(out, "integer")
  expect_length(out, 1)
})


test_that("check_att works for first half DOB (staggered)", {
  dob <- as.Date("2000-05-30") # First half of year
  visibility_min <- 2008
  visibility_max <- 2014
  visibility <- seq(visibility_min, visibility_max, by = 1)

  out <- check_att(dob,
                   visibility_min = visibility_min,
                   visibility_max = visibility_max)

  expect_type(out, "list")
  expect_named(out, c("results", "n"))
  expect_equal(nrow(out$results), length(visibility))
  expect_true(all(out$results$year == visibility))
  expect_true(out$n <= length(visibility))
})

test_that("check_att works for second half DOB (staggered)", {
  dob <- as.Date("2000-07-15") # Second half of year
  visibility_min <- 2008
  visibility_max <- 2014
  visibility <- seq(visibility_min, visibility_max)

  out <- check_att(dob,
                   visibility_min = visibility_min,
                   visibility_max = visibility_max)

  expect_type(out, "list")
  expect_named(out, c("results", "n"))
  expect_equal(nrow(out$results), length(visibility))
})

test_that("check_att handles ages outside reference range", {
  dob <- as.Date("2015-01-01") # Too young
  visibility_min <- 2008
  visibility_max <- 2014

  expect_warning(
    check_att(dob,
              visibility_min = visibility_min,
              visibility_max = visibility_max),
    "Visibility window ends before this date of birth"
  )
})

test_that("check_att works for pre-1997 DOB (normal year)", {
  dob <- as.Date("1995-03-01") # Pre-1997, Jan-Jun
  visibility_min <- 2008
  visibility_max <- 2014
  visibility <- seq(visibility_min, visibility_max)

  out <- check_att(dob,
                   visibility_min = visibility_min,
                   visibility_max = visibility_max)

  expect_type(out, "list")
  expect_named(out, c("results", "n"))
  expect_equal(nrow(out$results), length(visibility))
})

test_that("check_att works for pre-1997 DOB second half year", {
  dob <- as.Date("1995-08-01") # Pre-1997, Jul-Dec
  visibility_min <- 2008
  visibility_max <- 2014
  visibility <- seq(visibility_min, visibility_max)

  out <- check_att(dob,
                   visibility_min = visibility_min,
                   visibility_max = visibility_max)

  expect_type(out, "list")
  expect_named(out, c("results", "n"))
  expect_equal(nrow(out$results), length(visibility))
})

test_that("check_att correctly counts n for mixed NA and non-NA levels", {
  dob <- as.Date("2000-05-30") # First half of year (staggered)
  visibility_min <- 2008
  visibility_max <- 2014

  # Regular case
  out <- check_att(dob,
                   visibility_min = visibility_min,
                   visibility_max = visibility_max)
  expect_true(any(!is.na(out$results$level)))
  expect_equal(out$n, sum(!is.na(out$results$level)))

  # DOB completely outside reference
  dob_out <- as.Date("2020-01-01")
  expect_warning(
    out_na <- check_att(dob_out,
                        visibility_min = visibility_min,
                        visibility_max = visibility_max),
    "Visibility window ends before this date of birth"
  )
  expect_true(all(is.na(out_na$results$level)))
  expect_equal(out_na$n, 0)
})

test_that("check_att assigns NA for second-half DOB outside reference ages", {
  # Pick a DOB in second half of the year
  dob <- as.Date("2000-07-15")

  # Visibility window years that are BEFORE this child's schooling ages
  visibility_min <- 2000
  visibility_max <- 2004

  out <- check_att(dob,
                   visibility_min = visibility_min,
                   visibility_max = visibility_max)

  # The second-half-of-year branch is executed, all levels should be NA
  expect_true(all(is.na(out$results$level)))
  expect_equal(out$n, 0)
})

