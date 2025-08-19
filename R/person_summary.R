#' Summarise a dataframe to a person level
#'
#' In cases where we have a *long* data frame (i.e., multiple rows of data per participant) with a flag against each record (e.g., variable `x` = "Yes"/"No"), this function will collapse this dataframe to a participant level.
#'
#' The collapsing is based on the value of `flag_category_val` and a grouping variable (participant ID) `grouping_var`.
#'
#' Specifically, records will be collapsed such that:
#'    + If *any* record(s) for a participant is equal to `flag_category_val`, then return "Yes".
#'    + If *all* record(s) for a participant are not equal to `flag_category_val`, then return "No".
#'
#' @param data Input dataframe.
#' @param flag_category Name of the variable to perform classification on.
#' @param flag_category_val String value of the `flag_category` variable the flag will be judged against. Defaults to "Yes".
#' @param grouping_var Grouping ID variable that identifies potentially multiple records per participant.
#'
#' @importFrom magrittr %>%
#' @importFrom data.table :=
#'
#' @examples
#' \dontrun{
#' person_summary(data = dat,
#'                flag_category = "variable_x",
#'                flag_category_val = "Yes",
#'                grouping_var = "record_id"
#'                )
#' }
#'
#' @export

person_summary <- function(data,
                           flag_category,
                           flag_category_val = "Yes",
                           grouping_var){

  data <- data %>%
    dplyr::group_by(!!rlang::sym(grouping_var)) %>%
    dplyr::mutate(!!rlang::sym(flag_category) := dplyr::case_when(any(!!rlang::sym(flag_category) == flag_category_val) ~ "Yes",
                                                    TRUE ~ "No")) %>%
    dplyr::distinct(!!rlang::sym(grouping_var), !!rlang::sym(flag_category)) %>%
    dplyr::ungroup()

  return(data)
}
