#' Internal Data List: Broad morbidity column classification
#'
#' @description
#' `colname_classify_broad` is used within functions for specific calculations in the package.
#' This list is not exported and is intended for internal use only.
#'
#' @format A list with elements specific to internal calculations.
#'
#' @keywords internal
#'
#' @name colname_classify_broad
NULL

#' Internal Data List: Specific morbidity column classification
#'
#' @description
#' `colname_classify_specific` provides additional data needed for calculations in the package.
#' This list is also for internal use and is not exported.
#'
#' @format A list with elements specific to internal calculations.
#'
#' @keywords internal
#'
#' @name colname_classify_specific
NULL

actual_colnames <- c("diagnosis", paste0("ediag", 1:20), paste0("ecode", 1:4))

colname_classify_broad <- list("principal diagnosis" = "diagnosis",
                               "additional diagnoses" = "ediag",
                               "external cause of injury" = "ecode")

colname_classify_specific <- list("principal diagnosis" = actual_colnames[str_detect(actual_colnames, "diagnosis")],
                                  "additional diagnoses" = actual_colnames[str_detect(actual_colnames, "ediag")],
                                  "external cause of injury" = actual_colnames[str_detect(actual_colnames, "ecode")])


usethis::use_data(colname_classify_specific,
                  internal = T,
                  overwrite = T)
usethis::use_data(colname_classify_broad,
                  internal = T,
                  overwrite = T)
