#' Apply WAACHS theme to ggplot2 plots
#'
#' This function applies a custom theme to ggplot2 plots, incorporating colors to align with the project's visual identity.
#'
#' @details The function determines the operating system and selects appropriate font names for Windows or other systems. It also adjusts color scales.
#'
#' @return A list of ggplot2 theme elements and scale adjustments.
#'
#' @examples
#' library(ggplot2)
#'
#' ggplot(mtcars,
#'        aes(x = mpg, y = wt, col = factor(cyl))) +
#'   geom_point() +
#'   theme_waachs()
#'
#' @export


theme_waachs <- function(base_size = 11,
                         base_line_size = base_size/22,
                         base_rect_size = base_size/22){

  waachs_palette <- c("#D58957", "#FCD16B", "#89A1AD", "#FEF0D8")

  list(
    theme_minimal(base_size = base_size,
                  base_line_size = base_line_size,
                  base_rect_size = base_rect_size) +
    theme(#text = element_text(family = font_family),
          panel.grid.minor = element_blank(),
          plot.title = element_text(#family = font_family
                                    ),
          axis.title = element_text(#family = font_family
                                    ),
          strip.text = element_text(#family = font_family,
                                    size = rel(1), hjust = 0
                                    ),
          plot.background = element_rect(fill = "white", colour = "white"),
          strip.background = element_rect(fill = "grey80", colour = NA)),
    scale_colour_manual(values = waachs_palette)
    )
}
