#' Education flagging function
#'
#' This function serves to flag whether an individual is expected to have education data for every year within a "visibility window" based on their date of birth.
#' The fact that "staggered" (June/July) years were introduced in Western Australia in 1997 has been built into the function.
#'
#' @param dob Date of individual. Must be class "Date".
#' @param visibility_min Minimum year in visibility window. Default `2008`.
#' @param visibility_max Maximum year in visibility window. Default `2014`.
#' @param show_expectation Logical. Show flagged dataframe with expected flag per year in visibility window. Default `TRUE`.
#' @return Flagged dataframe.
#'
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#'
#' @examples
#' check_att(dob = as.Date("2000-05-30"))
#' @export

check_att <- function(dob,
                      visibility_min = 2008,
                      visibility_max = 2014,
                      show_expectation = TRUE){

  # Errors/warnings
  if (!inherits(dob, "Date")) {
    stop("Please ensure `dob` is of class 'Date' before proceeding.")
  }

  if (!is.numeric(visibility_min) || !is.numeric(visibility_max) ||
      visibility_min %% 1 != 0 || visibility_max %% 1 != 0) {
    stop("`visibility_min` and `visibility_max` must be integers.")
  }

  if (visibility_min > visibility_max) {
    stop("`visibility_min` must not exceed `visibility_max`.")
  }

  if (!is.logical(show_expectation) || length(show_expectation) != 1) {
    stop("`show_expectation` must be a single logical value (TRUE or FALSE).")
  }

  if (format(dob, "%Y") > visibility_max) {
    warning("Visibility window ends before this date of birth. No overlap expected.")
  }

  # Define visibility window
  visibility_window <- seq(visibility_min, visibility_max,
                           by = 1)

  # Define year & min/max (floor) age a child can be at end of year

  if (dob <= as.Date("1997-06-30")){
    result <- normal_att(a_ref = a_ref,
                         dob = dob,
                         visibility_window = visibility_window)
  }
  else if (dob >= as.Date("1997-07-01")){
    result <- staggered_att(a_ref = a_ref,
                            dob = dob,
                            visibility_window = visibility_window)
  }

  if (show_expectation == TRUE){
    return(result)
  } else if (show_expectation == FALSE){
    return(result$n)
  }
}
