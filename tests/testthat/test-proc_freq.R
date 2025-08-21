library(testthat)


test_that("proc_freq returns a flextable with expected columns and totals", {
  skip_if_not_installed("flextable")

  ft <- proc_freq(Species, iris)
  expect_s3_class(ft, "flextable")

  # column keys and body dataset
  expect_equal(
    ft$col_keys,
    c("Species", "Frequency", "Percent", "Cumulative Frequency", "Cumulative Percent")
  )

  df <- ft$body$dataset
  expect_true(all(c("Frequency", "Percent", "Cumulative Frequency", "Cumulative Percent") %in% names(df)))

  # Frequencies sum to non-missing count
  expect_equal(sum(df$Frequency), sum(!is.na(iris$Species)))

  # Cumulative percent ends at ~100.0
  expect_equal(round(max(df$`Cumulative Percent`), 1), 100)
})

test_that("proc_freq handles missing values by excluding from body and reporting correct total", {
  skip_if_not_installed("flextable")

  dat <- iris
  dat$Species[1:7] <- NA_integer_
  ft <- proc_freq(Species, dat)

  df <- ft$body$dataset
  expect_equal(sum(df$Frequency), nrow(na.omit(dat["Species"])))
})

test_that("proc_freq groups low-frequency categories with min.frq and places group last", {
  skip_if_not_installed("flextable")

  dat <- data.frame(x = c(rep("A", 5), rep("B", 2), rep("C", 1)))
  ft <- proc_freq(x, dat, min.frq = 3)
  df <- ft$body$dataset

  # last row label is "n < 3"
  expect_identical(df[[1]][nrow(df)], "n < 3")

  # grouped frequency equals sum of freqs < 3 in original data
  tab <- table(dat$x)
  expect_equal(df$Frequency[nrow(df)], sum(tab[tab < 3]))

  # totals unchanged
  expect_equal(sum(df$Frequency), nrow(dat))
})

test_that("proc_freq sorts ascending and descending on Frequency", {
  skip_if_not_installed("flextable")

  dat <- data.frame(x = c(rep("A", 5), rep("B", 3), rep("C", 1)))

  df_asc  <- proc_freq(x, dat, sort = "asc")$body$dataset
  df_desc <- proc_freq(x, dat, sort = "desc")$body$dataset

  # non-decreasing / non-increasing Frequency
  expect_true(all(diff(df_asc$Frequency)  >= 0))
  expect_true(all(diff(df_desc$Frequency) <= 0))
})

test_that("proc_freq ignores invalid sort values without error", {
  skip_if_not_installed("flextable")

  dat <- data.frame(x = c("A","B","C","A","B","A"))
  expect_silent(proc_freq(x, dat, sort = "random"))
})

test_that("proc_freq creates cumulative columns with correct endpoints", {
  skip_if_not_installed("flextable")

  dat <- data.frame(x = c("A","A","B","C"))
  df <- proc_freq(x, dat)$body$dataset

  expect_true("Cumulative Frequency" %in% names(df))
  expect_true("Cumulative Percent" %in% names(df))
  expect_equal(max(df$`Cumulative Frequency`), sum(!is.na(dat$x)))
  expect_equal(round(max(df$`Cumulative Percent`), 1), 100)
})
