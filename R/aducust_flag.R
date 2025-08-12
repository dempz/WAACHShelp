library(WAACHShelp)

# Variables
#
# `carer_map`
#     + Mapping file containing
#       + 1 column for child ID variable
#       + 1 column for carer ID variable
#     + 1 row per carer type (in case of carer1, carer2, NEWBMID, etc.)
# `data`
#     + Aducust data
# `dobmap`
#     + DOBmap for child (to calculate ages)
# `child_id_var`
#     + Child ID variable
# `carer_id_var`
#     + Carer ID variable (must be unique)
# `data_start_date`
# `data_end_date`

child_aducust <- function(data,
                          dobmap,
                          carer_map,
                          child_id_var = "rootnum",
                          carer_id_var = "carer_rootnum",
                          data_start_date = "ReceptionDate",
                          data_end_date = "DischargeDate",
                          dobmap_dob_var = "dob",
                          child_start_age = 0,
                          child_end_age = 18,
                          carer_summary = F,
                          any_carer_summary = F){


  # 1) Join `dobmap` to `carer_map`
  carer_map <- carer_map %>%
    left_join(dobmap %>% select(!!!rlang::syms(c(child_id_var, dobmap_dob_var))),
              by = child_id_var)

  join_var <- colnames(carer_map) # Save these for later

  # 2) Calculate start and end dates
  carer_map <- carer_map %>%
    mutate(start_date = !!rlang::sym(dobmap_dob_var) + years(child_start_age),
           end_date   = !!rlang::sym(dobmap_dob_var) + years(child_end_age))

  # 3) Process aducust data
  data <- data %>%
    group_by(!!rlang::sym(carer_id_var)) %>%
    mutate(aducust_num = row_number()) %>%
    ungroup %>%
    select(aducust_num, !!!rlang::syms(c(carer_id_var, data_start_date, data_end_date)))

  # 4) Join aducust data to `carer_map`
  data_final <- carer_map %>%
    left_join(data,
              by = carer_id_var,
              relationship = "many-to-many")

  # 5) Do the flagging
  varname <- paste0("carer_aducust_", child_start_age, "_", child_end_age)
  data_final <- data_final %>%
    mutate(!!varname := case_when(if_any(.cols = c(!!rlang::sym(data_start_date), !!rlang::sym(data_end_date)),
                                            .fns = ~ . >= start_date & . < end_date) ~ "Yes",
                                     if_any(.cols = c(!!rlang::sym(data_start_date), !!rlang::sym(data_end_date)),
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
      group_by(across(all_of(group_cols))) %>%
      summarise(
        !!varname := case_when(
          any(.data[[varname]] == "Yes") ~ "Yes",
          all(.data[[varname]] == "No") ~ "No",
          all(.data[[varname]] == "No record") ~ "No record"
        ),
        .groups = "drop"
      )
  }

  return(data_final)
}

child_aducust(data = carer_aducust %>% rename(carer_rootnum = root),
              dobmap = dobs,
              carer_map = mini_link,
              child_id_var = "NEWUID",
              carer_id_var = "carer_rootnum",
              carer_summary = FALSE,
              any_carer_summary = TRUE
              )
