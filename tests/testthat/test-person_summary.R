library(testthat)

test_that("person_summary collapses long dataframe correctly", {
  df <- data.frame(
    id = c(1,1,2,2,3,3,3),
    flag = c("Yes", "No", "No", "No", "Yes", "Yes", "No")
  )

  res <- person_summary(data = df,
                        flag_category = "flag",
                        flag_category_val = "Yes",
                        grouping_var = "id")

  # Expect one row per participant
  expect_equal(nrow(res), 3)

  # Participant 1 has at least one Yes -> Yes
  expect_equal(res$flag[res$id==1], "Yes")

  # Participant 2 has no Yes -> No
  expect_equal(res$flag[res$id==2], "No")

  # Participant 3 has at least one Yes -> Yes
  expect_equal(res$flag[res$id==3], "Yes")
})

test_that("person_summary works with different flag_category_val", {
  df <- data.frame(
    id = c(1,1,2,2),
    status = c("A", "B", "B", "B")
  )

  res <- person_summary(data = df,
                        flag_category = "status",
                        flag_category_val = "A",
                        grouping_var = "id")

  expect_equal(res$status[res$id==1], "Yes")
  expect_equal(res$status[res$id==2], "No")
})

test_that("person_summary returns correct columns", {
  df <- data.frame(
    pid = c(1,2),
    flag = c("Yes", "No")
  )

  res <- person_summary(data = df,
                        flag_category = "flag",
                        grouping_var = "pid")

  expect_true(all(c("pid", "flag") %in% colnames(res)))
})

test_that("person_summary works when all rows are flag_category_val", {
  df <- data.frame(
    id = c(1,1,2,2),
    flag = c("Yes", "Yes", "Yes", "Yes")
  )

  res <- person_summary(data = df,
                        flag_category = "flag",
                        grouping_var = "id")

  expect_true(all(res$flag == "Yes"))
})

test_that("person_summary works when no rows are flag_category_val", {
  df <- data.frame(
    id = c(1,1,2,2),
    flag = c("No", "No", "No", "No")
  )

  res <- person_summary(data = df,
                        flag_category = "flag",
                        grouping_var = "id")

  expect_true(all(res$flag == "No"))
})
