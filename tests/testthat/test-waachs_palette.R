library(testthat)

test_that("waachs_palette returns discrete palette correctly", {
  pal <- waachs_palette(type = "discrete")

  # Should be character vector with 4 colors (the base palette)
  expect_type(pal, "character")
  expect_length(pal, 4)
  expect_true(all(grepl("^#", pal)))  # Hex colors
})

test_that("waachs_palette returns continuous palette of correct length", {
  n_colors <- 10
  pal <- waachs_palette(type = "continuous", n = n_colors)

  expect_type(pal, "character")
  expect_length(pal, n_colors)
  expect_true(all(grepl("^#", pal)))  # Hex colors
})

test_that("waachs_palette errors on invalid type", {
  expect_error(
    waachs_palette(type = "invalid_type", n = 5),
    "Please select from colour categories 'continuous' or 'discrete'"
  )
})

test_that("waachs_palette visualisation returns list with palette and plot", {
  n_colors <- 9
  out <- waachs_palette(type = "continuous", n = n_colors, visualisation = TRUE)

  expect_type(out, "list")
  expect_named(out, c("palette", "plot"))

  expect_type(out$palette, "character")
  expect_length(out$palette, n_colors)
  expect_s3_class(out$plot, "ggplot")

  # Basic check the plot contains a geom_tile layer
  layers <- sapply(out$plot$layers, function(l) class(l$geom)[1])
  expect_true("GeomTile" %in% layers)
})

test_that("waachs_palette visualisation with discrete returns correct output", {
  out <- waachs_palette(type = "discrete", n = 4, visualisation = TRUE)

  expect_type(out, "list")
  expect_named(out, c("palette", "plot"))

  expect_type(out$palette, "character")
  expect_length(out$palette, 4)
  expect_s3_class(out$plot, "ggplot")
})

test_that("waachs_palette respects additional arguments to colorRampPalette", {
  # Example: use bias argument to make sure it runs without error
  pal <- waachs_palette(type = "continuous", n = 5, bias = 1)
  expect_length(pal, 5)
  expect_type(pal, "character")
})
