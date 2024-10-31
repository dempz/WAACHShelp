#' Helper Function #4
#'
#' This is an internal helper function.
#'
#' @keywords internal

person_level <- function(data,
                         flag_category,
                         joining_var) {

  # Process the morbidity data
  data <- data %>%
    group_by(!!rlang::sym(joining_var)) %>%
    mutate(!!rlang::sym(flag_category) := case_when(any(!!rlang::sym(flag_category) == "Yes") ~ "Yes",
                                                    TRUE ~ "No")) %>%
    distinct(!!rlang::sym(joining_var), !!rlang::sym(flag_category)) %>%
    ungroup

  return(data)
}
