library(testthat)

# 1) Test warnings/errors
test_that("errors on invalid flag_category", {
  expect_error(
    icd_morb_flag(
      data = morb_min,
      dobmap = dob_min,
      flag_category = "InvalidFlag",
      diag_type = "principal diagnosis"
    ),
    "not a valid input"
  )
})

test_that("warns if age is zero or negative", {
  expect_warning(
    icd_morb_flag(
      data = morb_min,
      dobmap = dob_min,
      flag_category = "MH_morb",
      under_age = TRUE,
      age = 0
    ),
    "`age` detected as 0"
  )
  expect_error(
    icd_morb_flag(
      data = morb_min,
      dobmap = dob_min,
      flag_category = "MH_morb",
      under_age = TRUE,
      age = -1
    ),
    "non-negative value for `age`"
  )
})

test_that("warns about ignored args for under_age = FALSE", {
  expect_warning(
    icd_morb_flag(
      data = morb_min,
      dobmap = dob_min,
      flag_category = "MH_morb",
      under_age = FALSE,
      age = 18
    ),
    "arguments are ignored"
  )
})

test_that("errors when dobmap missing but under_age=TRUE", {
  expect_error(
    icd_morb_flag(
      data = morb_min,
      dobmap = NULL,
      flag_category = "MH_morb",
      under_age = TRUE,
      age = 18
    ),
    "`dobmap` but be specified"
  )
})

test_that("errors if dobmap DOB var missing", {
  bad_dobmap <- dob_min %>% select(-dob)
  expect_error(
    icd_morb_flag(
      data = morb_min,
      dobmap = bad_dobmap,
      flag_category = "MH_morb",
      under_age = TRUE
    ),
    "does not contain a column named"
  )
})

test_that("errors if morb_date_var missing from data", {
  bad_data <- morb_min %>% select(-subadm)
  expect_error(
    icd_morb_flag(
      data = bad_data,
      dobmap = dob_min,
      flag_category = "MH_morb",
      under_age = TRUE
    ),
    "does not contain a column named"
  )
})

test_that("warnings if required variables missing for flag_category", {
  bad_data <- morb_min %>% select(-diagnosis)
  expect_error(
    icd_morb_flag(
      data = bad_data,
      flag_category = "MH_morb"
    ),
    "required to calculate"
  )
})

test_that("Warning if extra args used with predefined flag_category", {
  expect_warning(
    icd_morb_flag(
      data = morb_min,
      flag_category = "MH_morb",    # predefined category
      flag_other_varname = "test_var",
      diag_type = "custom",
      diag_type_custom_vars = c("diag"),
      diag_type_custom_params = list("diag" = list(letter = "F", lower = 0, upper = 99)),
      under_age = FALSE
    ),
    regexp = "Because `flag_category = 'MH_morb'` is predefined, the following arguments are ignored"
  )
})

#test_that("Warning if dobmap has duplicate IDs when under_age = TRUE", {
#  # Create a dobmap with duplicate IDs
#  dobmap_dup <- dob_min
#  dobmap_dup <- rbind(dobmap_dup, dobmap_dup[1, ])  # duplicate first row
#
#  expect_warning(
#    icd_morb_flag(data = morb_min,
#                  dobmap = dobmap_dup,
#                  flag_category = "MH_morb",
#                  under_age = TRUE,
#                  age = 18),
#    regexp = "`dobmap` is not uniquely defined. Multiple records exist per `rootnum`"
#    )
#})
test_that("Warning if dobmap has duplicate IDs when under_age = TRUE", {
  dobmap_dup <- rbind(dob_min, dob_min[1, ])  # duplicate first row

  w <- capture_warnings(
    icd_morb_flag(
      data = morb_min,
      dobmap = dobmap_dup,
      flag_category = "MH_morb",
      under_age = TRUE,
      age = 18
    )
  )

  expect_true(any(grepl("`dobmap` is not uniquely defined\\. Multiple records exist per `rootnum`", w)))
})

 test_that("error if diag_type includes 'custom' but diag_type_custom_vars is NULL", {
  expect_error(
    icd_morb_flag(
      data = morb_min,
      flag_category = "Other",
      diag_type = "custom",
      diag_type_custom_vars = NULL,
      diag_type_custom_params = list(),
      flag_other_varname = "test_flag"
    ),
    "Error: If specifying custom diagnosis type \\(`diag_type` = 'custom'\\), then variables to search across \\(`diag_type_custom_vars`\\) must be specified\\."
  )
})

test_that("error if diag_type contains invalid values", {
  expect_error(
    icd_morb_flag(
      data = morb_min,
      flag_category = "Other",
      diag_type = c("invalid_type"),
      diag_type_custom_vars = "dagger",
      diag_type_custom_params = list("dagger" = list(letter = "Z", lower = 0, upper = 7)),
      flag_other_varname = "test_flag"
    ),
    "Error: 'diag_type' must be one of 'principal diagnosis', 'additional diagnoses', 'external cause of injury', 'co-diagnosis', or 'custom'."
  )
})

test_that("error if reserved terms are in diag_type_custom_vars when flag_category == 'Other'", {
  expect_error(
    icd_morb_flag(
      data = morb_min,
      flag_category = "Other",
      flag_other_varname = "test_flag",
      diag_type = "custom",
      diag_type_custom_vars = c("principal diagnosis", "dagger"),  # reserved term included
      diag_type_custom_params = list(
        "principal diagnosis" = list(letter = "F", lower = 0, upper = 99),
        "dagger" = list(letter = "Z", lower = 0, upper = 7)
      )
    ),
    "Error: The following term\\(s\\) should be specified in `diag_type` and not in `diag_type_custom_vars`: principal diagnosis"
  )
})

test_that("error if diag_type_custom_vars are not all columns in data", {
  expect_error(
    icd_morb_flag(
      data = morb_min,
      flag_category = "Other",
      flag_other_varname = "test_flag",
      diag_type = c("custom"),
      diag_type_custom_vars = c("dagger", "nonexistent_var"),
      diag_type_custom_params = list(
        "dagger" = list(letter = "Z", lower = 0, upper = 7),
        "nonexistent_var" = list(letter = "X", lower = 0, upper = 10)
      )
    ),
    "Error: 'dagger', 'nonexistent_var' cannot both be found in the column names of 'data'"
  )
})

test_that("error if variables in diag_type or diag_type_custom_vars are missing from diag_type_custom_params", {
  expect_error(
    icd_morb_flag(
      data = morb_min,
      flag_category = "Other",
      flag_other_varname = "test_flag",
      diag_type = c("principal diagnosis", "custom"),
      diag_type_custom_vars = c("dagger"),
      diag_type_custom_params = list(
        # Missing limits for "principal diagnosis"
        dagger = list(letter = "Z", lower = 0, upper = 7)
      )
    ),
    "Error: The following variable\\(s\\) require limits specified in `diag_type_custom_params`: principal diagnosis"
  )
})

test_that("error if diag_type_custom_params parameters are improperly specified", {
  # Incorrect param structure: missing 'letter', 'lower', or 'upper'
  bad_params <- list(
    dagger = list("invalid" = 123)
  )

  expect_error(
    icd_morb_flag(
      data = morb_min,
      flag_category = "Other",
      flag_other_varname = "test_flag",
      diag_type = "custom",
      diag_type_custom_vars = "dagger",
      diag_type_custom_params = bad_params
    ),
    "Error: The parameters for variable dagger are not properly specified. Each parameter set must be a list with 'letter', 'lower', and 'upper'."
  )
})


# 2) Test things work
test_that("returns data with expected new flag variables", {
  result <- icd_morb_flag(
    data = morb_min,
    dobmap = dob_min,
    flag_category = "MH_morb",
    under_age = TRUE,
    age = 18,
    person_summary = FALSE
  )
  expect_true("MH_morb" %in% colnames(result))
  expect_true(any(grepl("_under18$", colnames(result))))
})


test_that("person_summary = TRUE aggregates correctly", {
  result <- icd_morb_flag(
    data = morb_min,
    flag_category = "MH_morb",
    person_summary = TRUE
  )
  expect_true(all(duplicated(result$rootnum) == FALSE)) # one row per person
})

test_that("works with flag_category == 'Other' and custom args", {
  expect_message(
    icd_morb_flag(
      data = morb_min,
      flag_category = "Other",
      flag_other_varname = "test_var",
      diag_type = "custom",
      diag_type_custom_vars = c("diagnosis", "ediag1"),
      diag_type_custom_params = list(
        "diagnosis" = list("letter" = "F", "lower" = 0, "upper" = 99.9999),
        "ediag1" = list("letter" = "", "lower" = 0, "upper" = 99.9999)))
  )
})

test_that("automatic flagging works with predefined flag_category", {
  res <- icd_morb_flag(
    data = morb_min,
    flag_category = "MH_morb",
    under_age = FALSE,
    person_summary = FALSE
  )
  expect_true("MH_morb" %in% colnames(res))
  expect_equal(nrow(res), nrow(morb_min))
})

test_that("manual flagging with list-of-lists params (non-custom diag_type) works", {
  diag_params <- list(
    "principal diagnosis" = list(
      list(letter = "F", lower = 0, upper = 99.9999),
      list(letter = "", lower = 290, upper = 319.9999)
    ),
    "additional diagnoses" = list(
      list(letter = "F", lower = 0, upper = 99.9999),
      list(letter = "", lower = 290, upper = 319.9999)
    ),
    "external cause of injury" = list(
      list(letter = "E", lower = 950, upper = 959.9999),
      list(letter = "X", lower = 60, upper = 84.9999)
    )
  )

  res <- icd_morb_flag(
    data = morb_min,
    flag_category = "Other",
    diag_type = c("principal diagnosis", "additional diagnoses", "external cause of injury"),
    diag_type_custom_params = diag_params,
    flag_other_varname = "MH_morb_custom"
  )

  expect_true("MH_morb_custom" %in% colnames(res))
})

test_that("combining diag_type with 'additional diagnoses' and custom vars works", {
  diag_ediag_params <- list(
    list(letter = "F", lower = 0, upper = 99.9999),
    list(letter = "", lower = 290, upper = 319.9999)
  )

  res <- icd_morb_flag(
    data = morb_min,
    flag_category = "Other",
    diag_type = c("additional diagnoses", "custom"),
    diag_type_custom_vars = "dagger",
    diag_type_custom_params = list(
      "additional diagnoses" = diag_ediag_params,
      "dagger" = diag_ediag_params
    ),
    flag_other_varname = "MH_morb_custom"
  )

  expect_true("MH_morb_custom" %in% colnames(res))
})

test_that("under_age TRUE with person_summary TRUE returns only under_age flag", {
  res <- icd_morb_flag(
    data = morb_min,
    dobmap = dob_min,
    flag_category = "MH_morb",
    under_age = TRUE,
    age = 18,
    person_summary = TRUE
  )

  expect_true(any(grepl("_under18$", colnames(res))))
  expect_false("MH_morb" %in% colnames(res))
})

test_that("person_summary works correctly for flag_category = 'Other', under_age = FALSE", {
  result <- icd_morb_flag(
    data = morb_min,
    flag_category = "Other",
    flag_other_varname = "test_flag",
    diag_type = "custom",
    diag_type_custom_vars = c("diagnosis"),
    diag_type_custom_params = list("diagnosis" = list(letter = "F", lower = 0, upper = 99.9999)),
    person_summary = TRUE,
    under_age = FALSE
  )

  # Expect the output to have one row per unique rootnum
  expect_equal(nrow(result), length(unique(morb_min$rootnum)))

  # Expect the flag variable to exist
  expect_true("test_flag" %in% colnames(result))
})

test_that("person_summary works correctly for flag_category = 'Other', under_age = TRUE", {
  result <- icd_morb_flag(
    data = morb_min,
    dobmap = dob_min,
    flag_category = "Other",
    flag_other_varname = "test_flag",
    diag_type = "custom",
    diag_type_custom_vars = c("diagnosis"),
    diag_type_custom_params = list("diagnosis" = list(letter = "F", lower = 0, upper = 99.9999)),
    person_summary = TRUE,
    under_age = TRUE,
    age = 18
  )

  # Expect one row per unique rootnum
  expect_equal(nrow(result), length(unique(morb_min$rootnum)))

  # Expect the flag variable with suffix _under18 exists
  expect_true(paste0("test_flag", "_under", 18) %in% colnames(result))
})

test_that("can specify 'co-diagnosis' in `diag_type`", {
  expect_message(icd_morb_flag(
    data = morb_min,
    flag_category = "Other",
    flag_other_varname = "test_var",
    diag_type = "co-diagnosis",
    diag_type_custom_params = list("co-diagnosis" = list("letter" = "Z", "lower" = 0, "upper" = 7))
  ))
})

test_that("Actually searches across dagger when `flag_category!='Other'", {
  expect_message(icd_morb_flag(
    data = morb_min,
    flag_category = "Sub_poison_morb"
  ))
})

