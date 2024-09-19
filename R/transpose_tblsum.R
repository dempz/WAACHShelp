#' WAACHS transpose `gtsummary::tbl_summary` table
#'
#' Quick helper function to easily transpose `gtsummary::tbl_summary` tables. Best used in conjunction with `WAACHShelp::waachs_table`.
#'
#' @param tbl tbl_summary input (of class `c("tbl_summary", "gtsummary")`).
#' @param ... Other parameters (not currently in use).
#'
#' @return data.frame with transposed summary table.
#'
#' @examples
#' mtcars %>%
#'   mutate(cyl = as_factor(cyl)) %>%
#'   select(cyl, mpg, disp, hp, wt, am) %>%
#'   tbl_summary(by = cyl) %>%
#'   modify_header(label ~ "cyl") %>% # Re-label "Characteristic" by stratification variable ("cy")
#'   transpose_tblsum() %>%
#'   waachs_table()
#'
#' @export

transpose_tblsum <- function(tbl,
                             ...){

  new_tab <- tbl %>%
    as.data.frame() %>%
    t() %>%
    as.data.frame() %>%
    rownames_to_column() %>%
    mutate(rowname = gsub("\\*\\*(.*?)\\*\\*", "\\1", rowname),
           rowname = str_replace(rowname, "\n", ""),
           rowname = gsub("(N = [0-9,]+)", "(\\1)", rowname))

  new_tab <- new_tab %>%
    rename_with(~unlist(new_tab[1,])) %>%
    slice(-1)

  return(new_tab)
}
