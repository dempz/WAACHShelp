#' Display dataframe as HTML table
#'
#' Created by PV (2023).
#'
#' @param tt Dataframe intended to display as a html table.
#' @param shading Vector denoting the lines of the table that might want to be shaded. For example, to shade the first, third and fifth rows, supply `shading = c(1, 3, 5)`.
#' @param caption Caption to add to the data set.
#' @param bodysize Text size of the table's content.
#'
#' @importFrom magrittr %>%
#'
#' @return Two-way table
#'
#' @export

ptab <- function(tt, shading = NULL, caption = " ", bodysize = 11) {


  ft <- tt %>%
    flextable::flextable() %>%
    flextable::bg(bg = "wheat", part = "header")
  ft <- flextable::fontsize(ft, size = bodysize, part = "body")
  if(!is.null(shading)){
    ft <- ft %>% flextable::bg(shading, bg = "#EFEFEF", part = "body")
  }

  an_fpar <- officer::fpar(officer::run_linebreak())

  ft <- ft %>%  flextable::set_caption(caption, fp_p = an_fpar)

  ft <- ft %>%
    flextable::border_inner() %>%
    flextable::border_outer() %>%
    flextable::theme_box()

  pdim = flextable::dim_pretty(ft)

  ft <- flextable::width(ft, width = pdim$width)

  ft
}
