#' Helper Function #3
#'
#' This is an internal helper function.
#'
#' @keywords internal

icd_flagging <- function(data,
                         flag_category,
                         icd_list, # Output from`01-01-icd_extraction`
                         flag_other_varname,
                         diag_type,
                         diag_type_custom_vars = NULL,
                         diag_type_custom_params){

  if (!"Other" %in% flag_category){
    icd_list_names <- names(icd_list)
    for (i in icd_list_names){
      icd_list_i <- icd_list[[i]] # for `principal_diagnosis`, etc.
      icd_list_i_vars <- colname_classify_specific[[i]]

      data <- data %>%
        mutate(!!rlang::sym(i) := case_when(if_any(.cols = !!icd_list_i_vars,
                                                               .fns = ~.x %in% icd_list_i) ~ "Yes",
                                                        if_all(.cols = !!icd_list_i_vars,
                                                               .fns = ~!.x %in% icd_list_i) ~ "No"))
    }
    data <- data %>%
      mutate(!!rlang::sym(flag_category) := case_when(if_any(.cols = !!icd_list_names,
                                                             .fns = ~.x == "Yes") ~ "Yes",
                                                      if_all(.cols = !!icd_list_names,
                                                             .fns = ~.x == "No") ~ "No"))

    }
  else if ("Other" %in% flag_category){
      icd_list_names <- names(icd_list)
      for (i in icd_list_names){
        icd_list_i <- icd_list[[i]] # extract that particular variable out
        icd_list_i_vars <- if (i %in% names(colname_classify_specific)) colname_classify_specific[[i]] else (i)
        icd_list_i_varname <- paste0(icd_list_i_vars, "_flag")

        data <- data %>%
          mutate(!!rlang::sym(paste0(icd_list_i_varname)) := case_when(if_any(.cols = !!icd_list_i_vars,
                                                                      .fns = ~.x %in% icd_list_i) ~ "Yes",
                                                               if_all(.cols = !!icd_list_i_vars,
                                                                      .fns = ~!.x %in% icd_list_i) ~ "No"))
      }
      data <- data %>%
        mutate(!!rlang::sym(flag_other_varname) := case_when(if_any(.cols = !!icd_list_i_varname,
                                                                    .fns = ~.x == "Yes") ~ "Yes",
                                                             if_all(.cols = !!icd_list_i_varname,
                                                                    .fns = ~.x == "No") ~ "No"))
  }

  return(data)
}


#icd_flagging(data = coh1_morb,
#             flag_category = "Other",
#             flag_other_varname = "test_var",
#             icd_list = test2) %>%
#  select(contains("flag"), test_var)
