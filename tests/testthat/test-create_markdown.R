library(testthat)
library(mockery)

test_that("create_markdown fails with invalid ext_name", {
  expect_error(create_markdown("test", ext_name = "pdf"),
               "valid ext_name")
})

test_that("create_markdown fails with missing file_name", {
  expect_error(create_markdown(NULL, ext_name = "html"),
               "file_name")
})

test_that("create_markdown fails when no directory selected", {
  tmp <- withr::local_tempdir()

  mockery::stub(create_markdown, "rstudioapi::selectDirectory", function(...) NA)
  mockery::stub(create_markdown, "system.file", function(...) file.path(tmp, "fakepkg"))

  expect_error(
    create_markdown("test", directory = tmp, ext_name = "html"),
    "Template creation cancelled"
  )
})

test_that("create_markdown creates expected structure for html", {
  tmp <- withr::local_tempdir()

  # fake extension skeleton in a temp package structure
  fake_pkg <- file.path(tmp, "fakepkg")
  dir.create(file.path(fake_pkg, "ext_qmd/_extensions/html"), recursive = TRUE)
  writeLines("template content", file.path(fake_pkg, "ext_qmd/_extensions/html/template.qmd"))
  writeLines("style.css", file.path(fake_pkg, "ext_qmd/_extensions/html/style.css"))

  # stub namespaced functions
  mockery::stub(create_markdown, "rstudioapi::selectDirectory", function(...) tmp)
  mockery::stub(create_markdown, "system.file", function(..., package) file.path(fake_pkg, ...))

  create_markdown("my_doc", directory = tmp, ext_name = "html")

  expect_true(dir.exists(file.path(tmp, "_extensions")))
  expect_true(dir.exists(file.path(tmp, "_extensions/html")))
  expect_true(file.exists(file.path(tmp, "my_doc.qmd")))
  expect_false(file.exists(file.path(tmp, "_extensions/html/template.qmd")))
})

test_that("create_markdown creates expected structure for word", {
  tmp <- withr::local_tempdir()

  fake_pkg <- file.path(tmp, "fakepkg")
  dir.create(file.path(fake_pkg, "ext_qmd/_extensions/word"), recursive = TRUE)
  writeLines("template content", file.path(fake_pkg, "ext_qmd/_extensions/word/template.qmd"))
  writeLines("style.docx", file.path(fake_pkg, "ext_qmd/_extensions/word/style.docx"))

  # stub namespaced functions
  mockery::stub(create_markdown, "rstudioapi::selectDirectory", function(...) tmp)
  mockery::stub(create_markdown, "system.file", function(..., package) file.path(fake_pkg, ...))

  create_markdown("word_doc", directory = tmp, ext_name = "word")

  expect_true(dir.exists(file.path(tmp, "_extensions/word")))
  expect_true(file.exists(file.path(tmp, "word_doc.qmd")))
  expect_false(file.exists(file.path(tmp, "_extensions/word/template.qmd")))
})

test_that("create_markdown messages when extension has too few files", {
  tmp <- withr::local_tempdir()

  # create fake extension folder with only 1 file
  fake_pkg <- file.path(tmp, "fakepkg")
  dir.create(file.path(fake_pkg, "ext_qmd/_extensions/html"), recursive = TRUE)
  writeLines("template content", file.path(fake_pkg, "ext_qmd/_extensions/html/template.qmd"))
  # NOTE: only 1 file, so n_files < 2

  # stub namespaced functions
  mockery::stub(create_markdown, "rstudioapi::selectDirectory", function(...) tmp)
  mockery::stub(create_markdown, "system.file", function(..., package) file.path(fake_pkg, ...))

  # capture the message
  expect_message(
    create_markdown("my_doc", directory = tmp, ext_name = "html"),
    "Extension appears not to have been created"
  )
})
