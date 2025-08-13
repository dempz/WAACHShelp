library(testthat)

test_that("Errors if data missing start/end date columns", {
  expect_error(
    aducust_flag(data = aducust %>% select(-ReceptionDate),
                 dobmap = dobmap,
                 carer_map = carer_map),
    "Both 'ReceptionDate' and 'DischargeDate' must be present"
  )

  expect_error(
    aducust_flag(data = aducust %>% select(-DischargeDate),
                 dobmap = dobmap,
                 carer_map = carer_map),
    "Both 'ReceptionDate' and 'DischargeDate' must be present"
  )
})

test_that("Error if `dobmap_dob_var` not in `dobmap`", {
  expect_error(
    aducust_flag(data = aducust,
                 dobmap = dobmap %>% select(-dob),
                 carer_map = carer_map,
                 dobmap_dob_var = "dob"),
    "'dob' is not present"
  )

  expect_error(
    aducust_flag(data = aducust,
                 dobmap = dobmap,
                 carer_map = carer_map,
                 dobmap_dob_var = "dob_variable"),
    "'dob_variable' is not present"
  )
})

test_that("Error if `carer_id_var` or `child_id_var` missing in carer_map", {
  expect_error(
    aducust_flag(data = aducust,
                 dobmap = dobmap,
                 carer_map = carer_map %>% select(-carer_rootnum),
                 carer_id_var = "carer_rootnum"),
    "Variable\\(s\\) 'carer_rootnum' not found in"
  )

  expect_error(
    aducust_flag(data = aducust,
                 dobmap = dobmap,
                 carer_map = carer_map %>% select(-rootnum),
                 child_id_var = "rootnum"),
    "Variable\\(s\\) 'rootnum' not found in"
  )
})

test_that("Error if carer_id_var missing in data", {
  expect_error(
    aducust_flag(data = aducust %>% select(-carer_rootnum),
                 dobmap = dobmap,
                 carer_map = carer_map,
                 carer_id_var = "carer_rootnum"),
    "Variable 'carer_rootnum' not found"
  )
})

test_that("Error if ages are non-numeric or child_start_age > child_end_age", {
  expect_error(
    aducust_flag(data = aducust,
                 dobmap = dobmap,
                 carer_map = carer_map,
                 child_start_age = "zero",
                 child_end_age = 5),
    "must be numeric"
  )
  expect_error(
    aducust_flag(data = aducust,
                 dobmap = dobmap,
                 carer_map = carer_map,
                 child_start_age = 5,
                 child_end_age = "five"),
    "must be numeric"
  )
  expect_error(
    aducust_flag(data = aducust,
                 dobmap = dobmap,
                 carer_map = carer_map,
                 child_start_age = 10,
                 child_end_age = 5),
    "must be less than or equal to"
  )
})

test_that("Collapsing works with carer_summary = TRUE", {
  res <- aducust_flag(data = aducust,
                      dobmap = dobmap,
                      carer_map = carer_map,
                      carer_summary = TRUE,
                      any_carer_summary = FALSE)
  expect_true("carer_aducust_0_18" %in% colnames(res))
})


test_that("Collapsing works with any_carer_summary = TRUE (warning + message)", {
  expect_warning(
    expect_message(
      res <- aducust_flag(data = aducust,
                          dobmap = dobmap,
                          carer_map = carer_map,
                          carer_summary = FALSE,
                          any_carer_summary = TRUE),
      regexp = "Flagged aducust records when child is aged"
    ),
    regexp = "'any_carer_summary' is TRUE but 'carer_summary' is FALSE"
  )

  expect_true("carer_aducust_0_18" %in% colnames(res))
})

test_that("Function returns expected columns and flag variable", {
  res <- aducust_flag(data = aducust,
                      dobmap = dobmap,
                      carer_map = carer_map,
                      child_start_age = 0,
                      child_end_age = 18,
                      carer_summary = FALSE,
                      any_carer_summary = FALSE)

  expect_true("carer_aducust_0_18" %in% colnames(res))
  expect_true(all(c("rootnum", "carer_rootnum", "dob") %in% colnames(res)))
  expect_true(all(res[[paste0("carer_aducust_0_18")]] %in% c("Yes", "No", "No record")))
})

test_that("Empty data returns carer_map with 'No record'", {
  empty_data <- aducust[0, ]
  res <- aducust_flag(data = empty_data,
                      dobmap = dobmap,
                      carer_map = carer_map)
  expect_true(all(res$carer_aducust_0_18 == "No record"))
})

test_that("Function works with non-default variable names", {
  res <- aducust_flag(data = aducust,
                      dobmap = dobmap,
                      carer_map = carer_map,
                      child_id_var = "rootnum",
                      carer_id_var = "carer_rootnum",
                      dobmap_dob_var = "dob")
  expect_true("carer_aducust_0_18" %in% colnames(res))
})

test_that("Return is a tibble", {
  res <- aducust_flag(data = aducust,
                      dobmap = dobmap,
                      carer_map = carer_map)
  expect_s3_class(res, "tbl_df")
})


test_that("Warning issued when date columns are not Date class and coercion attempted", {
  # Convert date columns to character to trigger warnings
  aducust_chr <- aducust %>%
    dplyr::mutate(ReceptionDate = as.character(ReceptionDate),
                  DischargeDate = as.character(DischargeDate))

  dobmap_chr <- dobmap %>%
    dplyr::mutate(dob = as.character(dob))

  warnings <- capture_warnings(
    aducust_flag(
      data = aducust_chr,
      dobmap = dobmap_chr,
      carer_map = carer_map
    )
  )

  expect_true(any(grepl("ReceptionDate.*not of class Date", warnings)))
  expect_true(any(grepl("DischargeDate.*not of class Date", warnings)))
  expect_true(any(grepl("dob.*not of class Date", warnings)))
})
