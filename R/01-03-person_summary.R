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
    dplyr::group_by(!!rlang::sym(joining_var)) %>%
    dplyr::mutate(!!rlang::sym(flag_category) := dplyr::case_when(any(!!rlang::sym(flag_category) == "Yes") ~ "Yes",
                                                                  TRUE ~ "No")) %>%
    dplyr::distinct(!!rlang::sym(joining_var), !!rlang::sym(flag_category)) %>%
    dplyr::ungroup()

  return(data)
}
