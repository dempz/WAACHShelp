#' Display dataframe as HTML table
#'
#' Created by PV (2023).
#'
#' @param tt Dataframe intended to display as a html table.
#' @param shading Vector denoting the lines of the table that might want to be shaded. For example, to shade the first, third and fifth rows, supply `shading = c(1, 3, 5)`.
#' @param caption Caption to add to the data set.
#' @param bodysize Text size of the table's content.
#' @return Two-way table
#'
#' @export

ptab <- function(tt, shading = NULL, caption = " ", bodysize = 11) {

  suppressMessages(library(officer))
  suppressMessages(library(flextable))


  ft <- tt %>% flextable() %>%
    bg(bg = "wheat", part = "header")
  ft <- fontsize(ft, size = bodysize, part = "body")
  if(!is.null(shading)){
    ft <- ft %>% bg(shading, bg = "#EFEFEF", part = "body")
  }

  an_fpar <- fpar(run_linebreak())

  ft <- ft %>%  set_caption(caption, fp_p = an_fpar)

  ft <- ft %>% border_inner() %>%
    border_outer() %>% theme_box()

  #set_table_properties(width = 1, layout = "autofit") %>%
  #theme_box

  pdim = dim_pretty(ft)

  ft <- width(ft, width = pdim$width)

  #ft <- height(ft, height = pdim$height)
  ft
}
