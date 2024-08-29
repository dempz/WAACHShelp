#' Summary tabling function
#'
#' General tabling function to standardise output and formatting across analysts and projects.
#' Based on gtsummary::tbl_summary
#'
#' @param data Input dataset.
#' @param ... Any other argument relevant to `gtsummary::tbl_summary`.
#' @return Summary table.
#' @export

sum_tab <- function(data, ...){
  suppressMessages(library(dplyr))

  my_compact_theme <- list(
      # for gt in render
      "as_gt-lst:addl_cmds" = list(tab_spanner = rlang::expr(gt::tab_options(
        table.font.size = 14, data_row.padding = 4)))
      )

  gtsummary::set_gtsummary_theme(my_compact_theme)

  data %>%
    gtsummary::tbl_summary(digits = list(gtsummary::all_continuous() ~ 2,
                                         gtsummary::all_categorical() ~ c(0, 1)),
                           ...) %>%
    gtsummary::italicize_labels()
}
