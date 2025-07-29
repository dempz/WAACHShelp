child_aducust <- function(carer_map,
                          carer_aducust,
                          child_id_var = "rootnum",
                          carer_id_var = "rootnum",
                          carer_vars,
                          child_dob,
                          start_age = 0,
                          end_age = 18,
                          collapse_any_record = F,
                          collapse_any_carer = F){

  # Pivot child_carer_map longer
  ## One record per person per carer id type
  carer_map <- carer_map %>%
    pivot_longer(cols = !!(carer_vars),
                 names_to = "carer_type",
                 values_to = "carer_id")

  # Join dobmap
  carer_map <- carer_map %>%
    left_join(child_dob,
              by = child_id_var)

  # Calculate start and end dates
  carer_map <- carer_map %>%
    mutate(start_date = dob + years(start_age),
           end_date = dob + years(end_age))

  # Calculate number of stints per person in aducust data
  carer_aducust <- carer_aducust %>%
    group_by(!!carer_id_var) %>%
    mutate(aducust_num = n()) %>%
    ungroup

  # Join on aducust data
  carer_map <- carer_map %>%
    left_join(carer_aducust,
              by = c("carer_id" = carer_id_var))

  return(carer_map)
}

child_aducust(carer_map = mini_link,
              carer_aducust = carer_auducst_clean,
              child_dob = dobs %>% select(NEWUID, dob),
              child_id_var = "NEWUID",
              carer_id_var = "rootnum",
              carer_vars = c("carer1id", "carer2id", "NEWBMID"))
