library(testthat)
library(haven)
library(readr)

test_that("save_waachs saves all three file types", {
  df <- data.frame(
    id = 1:3,
    value = c("A", "B", "C")
  )

  temp_dir <- tempdir()
  fname <- "testfile"

  suppressWarnings(save_waachs(df, path = temp_dir, filename = fname))

  # CSV
  expect_true(file.exists(file.path(temp_dir, paste0(fname, ".csv"))))
  csv_df <- read.csv(file.path(temp_dir, paste0(fname, ".csv")), stringsAsFactors = FALSE)
  expect_equal(csv_df, df, ignore_attr = TRUE)

  # SAS
  expect_true(file.exists(file.path(temp_dir, paste0(fname, ".sas7bdat"))))
  sas_df <- haven::read_sas(file.path(temp_dir, paste0(fname, ".sas7bdat")))
  expect_equal(sas_df, df, ignore_attr = TRUE)

  # RDS
  expect_true(file.exists(file.path(temp_dir, paste0(fname, ".RDS"))))
  rds_df <- readr::read_rds(file.path(temp_dir, paste0(fname, ".RDS")))
  expect_equal(rds_df, df, ignore_attr = TRUE)
})

test_that("save_waachs fails if invalid path", {
  df <- data.frame(x = 1:3)
  expect_error(
    save_waachs(df, path = "invalid_path_$$$", filename = "file"),
    "does not exist"
  )
})

test_that("save_waachs fails if filename missing", {
  df <- data.frame(x = 1:3)
  temp_dir <- tempdir()
  expect_error(save_waachs(df, path = temp_dir, filename = NULL))
})
