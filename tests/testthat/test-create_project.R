library(testthat)
library(mockery)


test_that("create_project creates project directories and Rproj file", {
  temp_dir <- tempdir()
  proj_name <- paste0("testproj_", sample(1e6, 1))

  stub(create_project, "rstudioapi::selectDirectory", function(...) temp_dir)

  create_project(project_name = proj_name, other_folders = c("extra1", "extra2"))

  proj_path <- file.path(temp_dir, proj_name)

  # Main project folder
  expect_true(dir.exists(proj_path))

  # Default subfolders
  expect_true(dir.exists(file.path(proj_path, "data")))
  expect_true(dir.exists(file.path(proj_path, "reports")))
  expect_true(dir.exists(file.path(proj_path, "documentation")))
  expect_true(dir.exists(file.path(proj_path, "output")))
  expect_true(dir.exists(file.path(proj_path, "R")))

  # Additional folders
  expect_true(dir.exists(file.path(proj_path, "extra1")))
  expect_true(dir.exists(file.path(proj_path, "extra2")))

  # Rproj file
  expect_true(file.exists(file.path(proj_path, paste0(proj_name, ".Rproj"))))
})

test_that("create_project errors if other_folders are not unique", {
  temp_dir <- tempdir()
  proj_name <- paste0("dupfolders_", sample(1e6, 1))

  stub(create_project, "rstudioapi::selectDirectory", function(...) temp_dir)

  expect_error(
    create_project(project_name = proj_name, other_folders = c("a", "a")),
    "not unique"
  )
})

test_that("create_project errors if directory selection cancelled", {
  temp_dir <- tempdir()
  proj_name <- paste0("cancelproj_", sample(1e6, 1))

  stub(create_project, "rstudioapi::selectDirectory", function(...) NA)

  expect_error(
    create_project(project_name = proj_name),
    "Please select a directory"
  )
})

test_that("create_project respects FALSE flags for subfolders", {
  temp_dir <- tempdir()
  proj_name <- paste0("noreports_", sample(1e6, 1))

  stub(create_project, "rstudioapi::selectDirectory", function(...) temp_dir)

  create_project(
    project_name = proj_name,
    data = FALSE,
    reports = FALSE,
    output = FALSE,
    documentation = FALSE,
    R = FALSE
  )

  proj_path <- file.path(temp_dir, proj_name)

  # These folders should NOT exist
  expect_false(dir.exists(file.path(proj_path, "data")))
  expect_false(dir.exists(file.path(proj_path, "reports")))
  expect_false(dir.exists(file.path(proj_path, "documentation")))
  expect_false(dir.exists(file.path(proj_path, "output")))
  expect_false(dir.exists(file.path(proj_path, "R")))

  # Rproj file should still exist
  expect_true(file.exists(file.path(proj_path, paste0(proj_name, ".Rproj"))))
})

test_that("create_project works with no other_folders specified", {
  temp_dir <- tempdir()
  proj_name <- paste0("standard_", sample(1e6, 1))

  stub(create_project, "rstudioapi::selectDirectory", function(...) temp_dir)

  create_project(project_name = proj_name)

  proj_path <- file.path(temp_dir, proj_name)

  # Only default folders should exist
  expect_true(dir.exists(file.path(proj_path, "data")))
  expect_true(dir.exists(file.path(proj_path, "reports")))
  expect_true(dir.exists(file.path(proj_path, "documentation")))
  expect_true(dir.exists(file.path(proj_path, "output")))
  expect_true(dir.exists(file.path(proj_path, "R")))
})
