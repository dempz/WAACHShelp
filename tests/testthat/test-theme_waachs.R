library(testthat)

test_that("theme_waachs returns a list with theme and scale_colour_manual", {
  out <- theme_waachs()
  expect_type(out, "list")
  expect_length(out, 2)

  # The first element should be a ggplot theme object
  expect_s3_class(out[[1]], "theme")

  # The second element should be a discrete scale (manual color scale)
  expect_s3_class(out[[2]], "ScaleDiscrete")

  # Check the manual scale values are the expected palette
  pal <- c("#D58957", "#FCD16B", "#89A1AD", "#FEF0D8")
  expect_equal(out[[2]]$palette(4), pal)
})

test_that("theme_waachs can be added to a ggplot without errors", {
  p <- ggplot(mtcars, aes(mpg, wt, colour = factor(cyl))) +
    geom_point() +
    theme_waachs()

  expect_s3_class(p, "ggplot")
  # Plot builds without error
  expect_silent(ggplot_build(p))
})

test_that("theme_waachs palette contains correct colors", {
  pal <- c("#D58957", "#FCD16B", "#89A1AD", "#FEF0D8")
  scale <- theme_waachs()[[2]]
  expect_equal(scale$palette(length(pal)), pal)
})

test_that("theme_waachs respects base_size argument", {
  out_default <- theme_waachs()
  out_custom <- theme_waachs(base_size = 20)

  # The base_size controls the default text size in theme
  expect_equal(out_default[[1]]$text$size, 12)
  expect_equal(out_custom[[1]]$text$size, 20)
})
