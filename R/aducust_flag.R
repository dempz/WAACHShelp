#' Custodial data flagging function
#'
#' This function serves to flag whether a custodial record exists when a child is of a certain stage.
#'
#'
#' @param data Input dataset (carer aducust).
#' @param dobmap DOBmap file at the child level.
#' @param carer_map Mapping file with columns "child ID", "carer ID". Can have multiple rows per child (e.g., one per carer 1, carer 2, NEWBMID).
#' @param flag_name Name of flagging variable to return. Default `"carer_aducust"`.
#' @param child_id_var Variable denoting "child ID". Must exist and be called the same thing in `dobmap` and `carer_map`. Default `"rootnum"`.
#' @param carer_id_var Variable denoting "carer ID". Must exist in `carer_map`. Default `"carer_rootnum"`.
#' @param data_start_date Start date to consider in `data`. Corresponds to aducust *start* date. Default `"ReceptionDate"`.
#' @param data_end_date End date to consider in `data`. Corresponds to aducust *end* date. Default `"DischargeDate"`.
#' @param dobmap_dob_var Date of birth (DOB) varible in `dobmap`. Default `"dob"`.
#' @param child_start_age Numeric. Start (minimum) age (years) to consider for flagging (default `0`).
#' @param child_end_age Numeric. End (maximum) age (years) to consider for flagging (default `18`).
#' @param carer_summary Collapse aducust flags *within carer* (i.e., for each `carer_id_var`). Default `FALSE`.
#' @param any_carer_summary Collapse aducust flags *across carers*. Default `FALSE`.
#' @return Flagged dataframe.
#'
#' @note
#' + If `carer_summary` is `TRUE`, then we are flagging whether a specific carer has any aducust record.
#'  + Therefore, we are assessing whether a specific carer has any aducust records.
#' + If `any_carer_summary` is `TRUE`, then we are flagging whether any carer (if multiple) have any aducust records.
#' + If `any_carer_summary` is `TRUE`, `carer_summary` will be ignored.
#'
#' @details For more details, see the \href{https://dempz.github.io/WAACHShelp/articles/aducust_flag.html}{vignette}.
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
                         flag_name = "carer_aducust",
                         child_id_var = "rootnum",
                         carer_id_var = "carer_rootnum",
                         data_start_date = "ReceptionDate",
                         data_end_date = "DischargeDate",
                         dobmap_dob_var = "dob",
                         child_start_age = 0,
                         child_end_age = 18,
                         carer_summary = FALSE,
                         any_carer_summary = FALSE){

  # i) Error: Date variables do not exist in `data`
  if (!all(c(data_start_date, data_end_date) %in% colnames(data))){
    stop(sprintf("Error: Both '%s' and '%s' must be present in '%s' before proceeding.",
                 data_start_date,
                 data_end_date,
                 deparse(substitute(data))))
  }

  # ii) Error: `dob` not in `dobmap`
  if (!dobmap_dob_var %in% colnames(dobmap)){
    stop(sprintf("Error: '%s' is not present in '%s'.",
                 dobmap_dob_var,
                 deparse(substitute(dobmap))))
  }

  ### iii) Check: carer_id_var must be in data
  if (!carer_id_var %in% colnames(data)) {
    stop(sprintf("Error: Variable '%s' not found in '%s'.",
                 carer_id_var,
                 deparse(substitute(data))))
  }

  ### iv) Error: if `child_id_var` or `carer_id_var` not in `carer_map`
  missing_vars <- setdiff(c(child_id_var, carer_id_var), colnames(carer_map))
  if (length(missing_vars) > 0) {
    stop(sprintf("Error: Variable(s) '%s' not found in '%s'.",
                 paste(missing_vars, collapse = "', '"),
                 deparse(substitute(carer_map))))
  }

  ### v) Warning: `date` columns not actually dates
  if (!inherits(data[[data_start_date]], "Date")) {
    warning(sprintf("Warning: '%s' in 'data' is not of class Date. Attempting to coerce to Date.", data_start_date))
    data[[data_start_date]] <- as.Date(data[[data_start_date]])
  }

  if (!inherits(data[[data_end_date]], "Date")) {
    warning(sprintf("Warning: '%s' in 'data' is not of class Date. Attempting to coerce to Date.", data_end_date))
    data[[data_end_date]] <- as.Date(data[[data_end_date]])
  }

  if (!inherits(dobmap[[dobmap_dob_var]], "Date")) {
    warning(sprintf("Warning: '%s' in 'dobmap' is not of class Date. Attempting to coerce to Date.", dobmap_dob_var))
    dobmap[[dobmap_dob_var]] <- as.Date(dobmap[[dobmap_dob_var]])
  }


  ### vi) Combination of `any_carer_summary` and `carer_summary`
  if (any_carer_summary && !carer_summary) {
    warning("'any_carer_summary' is TRUE but 'carer_summary' is FALSE. 'carer_summary' will be ignored, and collapsing will occur across carers.")
  }

  ### vii) Check ages are as expected
  not_numeric <- c(if (!is.numeric(child_start_age)) "child_start_age" else NULL,
                   if (!is.numeric(child_end_age)) "child_end_age" else NULL)

  if (length(not_numeric) > 0) {
    stop(sprintf("Error: %s must be numeric.",
                 paste(shQuote(not_numeric), collapse = " and ")))
  } else if (child_start_age > child_end_age) {
    stop("Error: 'child_start_age' must be less than or equal to 'child_end_age'.")
  }


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
  varname <- paste0(flag_name, "_", child_start_age, "_", child_end_age)
  data_final <- data_final %>%
    dplyr::mutate(!!varname := dplyr::case_when(dplyr::if_any(.cols = c(!!rlang::sym(data_start_date), !!rlang::sym(data_end_date)),
                                                              .fns = ~ . >= start_date & . < end_date) ~ "Yes",
                                                dplyr::if_any(.cols = c(!!rlang::sym(data_start_date), !!rlang::sym(data_end_date)),
                                                .fns = ~ . < start_date | . >= end_date) ~ "No",
                                                is.na(aducust_num) ~ "No record"))
  message(paste0("Flagged aducust records when child is aged ", child_start_age, " to ", child_end_age, "."))

  # 6) Flag whether to collapse in the various ways
  if (any_carer_summary) {
    # Always honour any_carer_summary when TRUE
    group_cols <- c(child_id_var, dobmap_dob_var)

    data_final <- data_final %>%
      dplyr::group_by(dplyr::across(tidyselect::all_of(group_cols))) %>%
      dplyr::summarise(!!varname := dplyr::case_when(any(.data[[varname]] == "Yes") ~ "Yes",
                                                     all(.data[[varname]] == "No") ~ "No",
                                                     all(.data[[varname]] %in% c("No", "No record")) ~ "No",
                                                     all(.data[[varname]] == "No record") ~ "No record"))
  } else if (carer_summary) {
    # Honour carer_summary only if any_carer_summary is FALSE
    group_cols <- join_var

    data_final <- data_final %>%
      dplyr::group_by(dplyr::across(tidyselect::all_of(group_cols))) %>%
      dplyr::summarise(!!varname := dplyr::case_when(any(.data[[varname]] == "Yes") ~ "Yes",
                                                     all(.data[[varname]] == "No") ~ "No",
                                                     all(.data[[varname]] == "No record") ~ "No record"))
  }

  return(data_final)
}
