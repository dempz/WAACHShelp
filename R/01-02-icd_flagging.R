#' Helper Function #3
#'
#' This is an internal helper function.
#'
#' @keywords internal

icd_flagging <- function(data,
                         flag_category,
                         icd_list, # Output from`01-01-icd_extraction`
                         flag_other_varname){

  if (!"Other" %in% flag_category){
    icd_list_names <- names(icd_list)
    for (i in icd_list_names){
      icd_list_i <- icd_list[[i]] # for `principal_diagnosis`, etc.
      icd_list_i_vars <- colname_classify_specific[[i]]

      data <- data %>%
        mutate(!!rlang::sym(i) := case_when(if_any(.cols = all_of(icd_list_i_vars),
                                                   .fns = ~.x %in% icd_list_i) ~ "Yes",
                                            if_all(.cols = all_of(icd_list_i_vars),
                                                   .fns = ~!.x %in% icd_list_i) ~ "No"))
    }
    data <- data %>%
      mutate(!!rlang::sym(flag_category) := case_when(if_any(.cols = all_of(icd_list_names),
                                                             .fns = ~.x == "Yes") ~ "Yes",
                                                      if_all(.cols = all_of(icd_list_names),
                                                             .fns = ~.x == "No") ~ "No"))

    }
  else if ("Other" %in% flag_category){
      icd_list_names <- names(icd_list)
      flag_varnames <- c() # Initialise list to save flag_varname values to

      for (i in icd_list_names){
        icd_list_i <- icd_list[[i]] # List of the ICD values
        flag_varname <- paste0("flag_", i)
        flag_varnames <- c(flag_varnames, flag_varname)


        if (i %in% names(colname_classify_specific)){ # If "additional diagnoses" etc.
          icd_list_i_vars <- colname_classify_specific[[i]]

          #print(paste0("Variable category=", i, " , variable names=", paste0(icd_list_i_vars, collapse = ", ")))

          data <- data %>%
            mutate(!!rlang::sym(flag_varname) := case_when(if_any(.cols = all_of(icd_list_i_vars),
                                                                  .fns = ~.x %in% icd_list_i) ~ "Yes",
                                                           if_all(.cols = all_of(icd_list_i_vars),
                                                                  .fns = ~!.x %in% icd_list_i) ~ "No"))

        }
        else if (!i %in% names(colname_classify_specific)){
          data <- data %>%
            mutate(!!rlang::sym(flag_varname) := case_when(if_any(.cols = !!rlang::sym(i),
                                                                  .fns = ~.x %in% icd_list_i) ~ "Yes",
                                                           if_all(.cols = !!rlang::sym(i),
                                                                  .fns = ~!.x %in% icd_list_i) ~ "No"))
        }
      }

      data <- data %>%
        mutate(!!rlang::sym(flag_other_varname) := case_when(if_any(.cols = all_of(flag_varnames),
                                                                    .fns = ~.x == "Yes") ~ "Yes",
                                                             if_all(.cols = all_of(flag_varnames),
                                                                    .fns = ~.x == "No") ~ "No")) %>%
        select(-all_of(flag_varnames))
  }

  return(data)
}
