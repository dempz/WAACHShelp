#' Custodial data flagging function
#'
#' This function serves to flag whether a custodial record exists when a child is of a certain stage.
#'
#' @param data Input dataset (carer aducust).
#' @param dobmap DOBmap file at the child level.
#' @param carer_map Mapping file with columns "child ID", "carer ID". Can have multiple rows per child, to correspond to each carer type (e.g., carer 1, carer 2, NEWBMID).
#' @param child_id_var Variable denoting "child ID". Must exist and be called the same thing in `dobmap` and `carer_map`. Default `"rootnum"`.
#' @param carer_id_var Variable denoting "carer ID". Must exist in `carer_map`. Default `"carer_rootnum"`.
#' @param data_start_date Start date to consider in `data`. Corresponds to aducust *start* date. Default `"ReceptionDate"`.
#' @param data_end_date End date to consider in `data`. Corresponds to aducust *end* date. Default `"DischargeDate"`.
#' @param dobmap_dob_var Date of birth (DOB) varible in `dobmap`. Default `"dob"`.
#' @param child_start_age Numeric. Start (minimum) age (years) to consider for flagging (default `0`).
#' @param child_end_date Numeric. End (maximum) age (years) to consider for flagging (default `18`).
#' @param carer_summary Collapse aducust flags *within carer* (i.e., for each `carer_id_var`). Default `FALSE`.
#' @param any_carer_summary Collapse aducust flags *across carers*. Default `FALSE`.
#' @return Flagged dataframe.
#'
#' @importFrom magrittr %>%
#'
#' @examples
#' \dontrun{
#' # Example 1: Basic use
#' aducust_flag(data = carer_aducust %>% rename(carer_rootnum = root),
#'              dobmap = dobmap,
#'              carer_map = child_carer_map,
#'              child_id_var = "NEWUID",
#'              carer_id_var = "carer_rootnum",
#'              carer_summary = FALSE,
#'              any_carer_summary = TRUE
#' )
#' }
#' @export

aducust_flag <- function(data,
                         dobmap,
                         carer_map,
                         child_id_var = "rootnum",
                         carer_id_var = "carer_rootnum",
                         data_start_date = "ReceptionDate",
                         data_end_date = "DischargeDate",
                         dobmap_dob_var = "dob",
                         child_start_age = 0,
                         child_end_age = 18,
                         carer_summary = FALSE,
                         any_carer_summary = FALSE){


  # 1) Join `dobmap` to `carer_map`
  carer_map <- carer_map %>%
    dplyr::left_join(dobmap %>% dplyr::select(!!!rlang::syms(c(child_id_var, dobmap_dob_var))),
                     by = child_id_var)

  join_var <- colnames(carer_map) # Save these for later

  # 2) Calculate start and end dates
  carer_map <- carer_map %>%
    dplyr::mutate(start_date = !!rlang::sym(dobmap_dob_var) + lubridate::years(child_start_age),
           end_date   = !!rlang::sym(dobmap_dob_var) + lubridate::years(child_end_age))

  # 3) Process aducust data
  data <- data %>%
    dplyr::group_by(!!rlang::sym(carer_id_var)) %>%
    dplyr::mutate(aducust_num = dplyr::row_number()) %>%
    dplyr::ungroup() %>%
    dplyr::select(aducust_num, !!!rlang::syms(c(carer_id_var, data_start_date, data_end_date)))

  # 4) Join aducust data to `carer_map`
  data_final <- carer_map %>%
    dplyr::left_join(data,
                     by = carer_id_var,
                     relationship = "many-to-many")

  # 5) Do the flagging
  varname <- paste0("carer_aducust_", child_start_age, "_", child_end_age)
  data_final <- data_final %>%
    dplyr::mutate(!!varname := dplyr::case_when(dplyr::if_any(.cols = c(!!rlang::sym(data_start_date), !!rlang::sym(data_end_date)),
                                                              .fns = ~ . >= start_date & . < end_date) ~ "Yes",
                                                dplyr::if_any(.cols = c(!!rlang::sym(data_start_date), !!rlang::sym(data_end_date)),
                                                .fns = ~ . < start_date | . >= end_date) ~ "No",
                                                is.na(aducust_num) ~ "No record"))

  # 6) Flag whether to collapse in the various ways
  if (carer_summary) {
    group_cols <- if (any_carer_summary) {
      c(child_id_var, dobmap_dob_var)
    } else {
      join_var
    }

    data_final <- data_final %>%
      dplyr::group_by(dplyr::across(tidyselect::all_of(group_cols))) %>%
      dplyr::summarise(!!varname := dplyr::case_when(any(.data[[varname]] == "Yes") ~ "Yes",
                                                     all(.data[[varname]] == "No") ~ "No",
                                                     all(.data[[varname]] == "No record") ~ "No record"))
  }

  return(data_final)
}
