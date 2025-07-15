#' Apply WAACHS theme to ggplot2 plots
#'
#' This function applies a custom theme to ggplot2 plots, incorporating colors to align with the project's visual identity.
#'
#' @param base_size Base font size
#' @param base_line_size Base line size (default `base_size/22`)
#' @param base_rect_size Base rectangle size (default `base_size/22`)
#'
#' @details The function determines the operating system and selects appropriate font names for Windows or other systems. It also adjusts color scales.
#'
#' @return A list of ggplot2 theme elements and scale adjustments.
#'
#' @importFrom ggplot2 ggplot
#'
#' @examples
#'
#' ggplot(mtcars,
#'        aes(x = mpg, y = wt, col = factor(cyl))) +
#'   geom_point() +
#'   theme_waachs()
#'
#' @export


theme_waachs <- function(base_size = 12,
                         base_line_size = base_size/22,
                         base_rect_size = base_size/22){

  waachs_palette <- c("#D58957", "#FCD16B", "#89A1AD", "#FEF0D8")

  list(
    ggplot2::theme_minimal(base_size = base_size,
                  base_line_size = base_line_size,
                  base_rect_size = base_rect_size) +
      ggplot2::theme(panel.grid.minor = ggplot2::element_blank(),
                     plot.title = ggplot2::element_text(),
                     axis.title = ggplot2::element_text(),
                     strip.text = ggplot2::element_text(size = ggplot2::rel(1),
                                                        hjust = 0),
                     plot.background = ggplot2::element_rect(fill = "white",
                                                             colour = "white"),
                     strip.background = ggplot2::element_rect(fill = "grey80",
                                                              colour = NA)),
    ggplot2::scale_colour_manual(values = waachs_palette)
    )
}
