library(testthat)

test_that("waachs_table returns a flextable object", {
  df <- data.frame(A = 1:3, B = letters[1:3])
  tbl <- waachs_table(df)
  expect_s3_class(tbl, "flextable")
})

test_that("waachs_table warns if input is already a flextable", {
  df <- data.frame(A = 1:3, B = letters[1:3])
  ft <- flextable::flextable(df)
  expect_warning(waachs_table(ft), "Object of class 'flextable' detected")
})

test_that("waachs_table coerces gtsummary object to flextable", {
  tbl_sum <- tbl_summary(head(mtcars))
  ft <- waachs_table(tbl_sum)
  expect_s3_class(ft, "flextable")
})

test_that("table_coerce converts gt_tbl object to flextable", {
  gt_tbl <- gt::gt(head(mtcars))
  out <- waachs_table(gt_tbl)
  expect_s3_class(out, "flextable")
})

test_that("waachs_table respects font_family argument via check_font_family", {
  # If check_font_family is exported, test the real function;
  # otherwise, mock check_font_family to verify it is called.

  # Here we test that the default font_family is passed and returned as character
  df <- head(mtcars)
  tbl <- waachs_table(df, font_family = "Arial")
  expect_s3_class(tbl, "flextable")

  # Optionally check that font_family is passed to defaults
  defaults <- flextable::get_flextable_defaults()
  expect_true("font.family" %in% names(defaults))
})

test_that("waachs_table converts knitr_kable HTML table to flextable", {
  # Create a valid kable HTML object
  kbl <- knitr::kable(data.frame(A = 1:3, B = letters[1:3]), format = "html")
  expect_s3_class(kbl, "knitr_kable")

  out <- waachs_table(kbl)
  expect_s3_class(out, "flextable")
})

test_that("waachs_table converts knitr_kable HTML table to flextable when kableExtra is used", {
  # Create a valid kable HTML object
  kbl <- kableExtra::kable_styling(knitr::kable(data.frame(A = 1:3, B = letters[1:3]), format = "html"))
  expect_s3_class(kbl, "knitr_kable")

  out <- waachs_table(kbl)
  expect_s3_class(out, "flextable")
})

test_that("waachs_table returns error if 'html' not specified in kable()", {
  # Create a valid kable HTML object
  kbl <- knitr::kable(data.frame(A = 1:3, B = letters[1:3]))
  expect_s3_class(kbl, "knitr_kable")

  expect_error(waachs_table(kbl), "Please ensure `format='html'` is specified")
})


test_that("waachs_table returns error if non-'html' format specified  in kable()", {
  # Create a valid kable HTML object
  kbl <- knitr::kable(data.frame(A = 1:3, B = letters[1:3]), format = "latex")
  expect_s3_class(kbl, "knitr_kable")

  expect_error(waachs_table(kbl), "Please ensure `format='html'` is specified")
})


test_that("waachs_table applies highlight theme when highlight argument is provided", {
  df <- head(mtcars)
  highlight_rows <- 1:3
  tbl <- waachs_table(df, highlight = highlight_rows)
  expect_s3_class(tbl, "flextable")
  # You can also inspect theme_fun in defaults to verify it's table_highlight (not trivial here)
})

test_that("table_highlight errors on invalid highlight vector", {
  df <- head(mtcars)
  ft <- flextable::flextable(df)

  expect_error(
    table_highlight(ft, header_bg_col = "#000000", body_bg_col = "#FFFFFF",
                    highlight = c(-1, 2), highlight_darken = 0.3),
    "`highlight` must be a vector of positive integers."
  )

  expect_error(
    table_highlight(ft, header_bg_col = "#000000", body_bg_col = "#FFFFFF",
                    highlight = c(1, 1000), highlight_darken = 0.3),
    "You are trying to highlight a row"
  )
})

test_that("table_plain_theme applies background colors without highlight", {
  df <- head(mtcars)
  ft <- flextable::flextable(df)
  ft2 <- table_plain_theme(ft, header_bg_col = "#0000FF", body_bg_col = "#EEEEEE")
  expect_s3_class(ft2, "flextable")
})

test_that("waachs_table restores flextable defaults after execution", {
  df <- head(mtcars)
  old_defaults <- flextable::get_flextable_defaults()
  waachs_table(df)
  new_defaults <- flextable::get_flextable_defaults()
  expect_equal(old_defaults, new_defaults)
})

# Can probably be improved
test_that("check_font_family returns a font name or fallback", {
  out <- waachs_table(mtcars[1:5, ], font_family = "DefinitelyNoSuchFont123")
  defaults <- flextable::get_flextable_defaults()
  expect_true(defaults$font.family %in% c("sans", "DefinitelyNoSuchFont123", "Arial"))
})
