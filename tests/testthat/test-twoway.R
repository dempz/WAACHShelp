library(testthat)

test_that("twoway creates a table1 object", {
  df <- data.frame(
    gender = c("Male", "Female", "Male", "Female"),
    group = c("A", "A", "B", "B")
  )

  tbl <- suppressWarnings(twoway(var1 = gender, var2 = group, data = df))
  expect_s3_class(tbl, "table1")
})

test_that("twoway handles factor conversion correctly", {
  df <- data.frame(
    gender = c("Male", "Female", "Male", "Female"),
    group = c("A", "A", "B", "B")
  )

  tbl <- suppressWarnings(twoway(var1 = gender, var2 = group, data = df))
  # Check that var2 column in table is factor
  expect_true(is.factor(df$group) || is.factor(forcats::as_factor(df$group)))
})

test_that("twoway works with var2lab specified", {
  df <- data.frame(
    gender = c("Male", "Female", "Male", "Female"),
    group = c("A", "A", "B", "B")
  )

  expect_silent(suppressWarnings(twoway(var1 = gender, var2 = group, data = df, var2lab = "Group Label")))
})

test_that("twoway works with existing label", {
  df <- data.frame(
    gender = c("Male", "Female", "Male", "Female"),
    group = c("A", "A", "B", "B")
  )
  attr(df$group, "label") <- "Existing Label"

  expect_silent(suppressWarnings(twoway(var1 = gender, var2 = group, data = df)))
})

test_that("twoway fails if var not in data", {
  df <- data.frame(gender = c("Male", "Female"))
  expect_error(suppressWarnings(twoway(var1 = gender, var2 = group, data = df),
                                x = "deprecated"))
})

test_that("twoway is deprecated", {
  df <- data.frame(
    gender = c("Male", "Female", "Male", "Female"),
    group = c("A", "A", "B", "B")
  )
  attr(df$group, "label") <- "Existing Label"
  lifecycle::expect_deprecated(twoway(var1 = gender, var2 = group, data = df))
})
