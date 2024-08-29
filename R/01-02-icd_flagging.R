#' Helper Function #3
#'
#' This is an internal helper function.
#'
#' @keywords internal

icd_flagging <- function(data, flag_category, icd_list, flag_other_vals, flag_other_varname){

  if (!"Other" %in% flag_category){
    for (i in flag_category){
      icd_types <- icd_list[[i]]

      data <- data %>%
        mutate(!!rlang::sym(i) := case_when(if_any(.cols = c(diagnosis, ediag1:ediag20),
                                                   .fns = ~.x %in% icd_types$diag_ediag) ~ "Yes",
                                            if_any(.cols = c(ecode1:ecode4),
                                                   .fns = ~.x %in% icd_types$ecode) ~ "Yes",
                                            TRUE ~ "No"))
    }
  } else if ("Other" %in% flag_category){
    data <- data %>%
      mutate(!!rlang::sym(flag_other_varname) := case_when(if_any(.cols = c(diagnosis, ediag1:ediag20),
                                                                  .fns = ~.x %in% flag_other_vals$diag_ediag) ~ "Yes",
                                                           if_any(.cols = c(ecode1:ecode4),
                                                                  .fns = ~.x %in% flag_other_vals$ecode) ~ "Yes",
                                                           TRUE ~ "No"))
  }



  return(data)
}
