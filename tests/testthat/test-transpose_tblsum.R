library(testthat)

test_that("transpose_tblsum returns a data.frame", {
  df <- mtcars %>%
    mutate(cyl = as_factor(cyl)) %>%
    select(cyl, mpg, disp, hp, wt, am)

  tbl <- tbl_summary(df, by = cyl)
  transposed <- transpose_tblsum(tbl)

  expect_s3_class(transposed, "data.frame")
})

test_that("transpose_tblsum removes markdown from rowname", {
  df <- mtcars %>%
    mutate(cyl = as_factor(cyl)) %>%
    select(cyl, mpg, disp)

  tbl <- tbl_summary(df, by = cyl)
  transposed <- transpose_tblsum(tbl)

  expect_false(any(grepl("\\*\\*", transposed$rowname)))
  expect_false(any(grepl("\n", transposed$rowname)))
})
