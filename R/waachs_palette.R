#' WAACHS colour palette
#'
#' Function to return discrete or continuous colour palette based on WAACHS logo colours.
#'
#' @param type Type of colour palette to render (values "discrete", "continuous").
#' @param n Number of colours to generate in palette (if `type == "continuous"`).
#' @param visualisation (Default `TRUE`). Return visualisation of the colour spectrum to aid in decision making.
#' @param ... Miscellaneous arguments to parse to `grDevices::colorRampPalette`.
#'
#' @return Vector with colour hex codes. If `type == "continuous"` returns vector of length `n`. If `visualisation == TRUE` returns a list containing colour palette vector and `ggplot2` visualisation of colour spectrum.
#'
#' @examples
#' colours <- waachs_palette(type = "continuous", n = 100, visualisation = TRUE) # Render colour palette
#' print(colours$palette) # Print colour palette
#' print(colours$plot)    # Print plot
#'
#' @export

waachs_palette <- function(type = "discrete",
                           n,
                           visualisation = F,
                           bias = 2,
                           interpolate = "spline",
                           ...){
  waachs_palette <- c("#D58957", "#FCD16B", "#89A1AD", "#FEF0D8")

  if (type == "discrete"){
    palette <- waachs_palette

  } else if (type == "continuous"){
    spectrum <- grDevices::colorRampPalette(waachs_palette, ...)
    palette <- spectrum(n)

  } else {
    stop(sprintf("Error: Please select from colour categories 'continuous' or 'discrete'."))

  }

  if (visualisation == TRUE){

    viz_dat <- data.frame(x = rep(1:ceiling(sqrt(n)), each = ceiling(sqrt(n)))[1:n],
                          y = rep(1:ceiling(sqrt(n)), times = ceiling(sqrt(n)))[1:n],
                          colours = palette
                          )

    plot <- ggplot2::ggplot(viz_dat, aes(x = x, y = y, fill = colours)) +
      ggplot2::geom_tile() +
      ggplot2::scale_fill_identity() +
      ggplot2::theme_void() +
      ggplot2::theme(legend.position = "none") +
      ggplot2::labs(title = "Continuous Palette Visualization")

    return(list(palette = palette,
                plot = plot))

  } else if (visualisation == FALSE){
    return(palette)

  }

}
