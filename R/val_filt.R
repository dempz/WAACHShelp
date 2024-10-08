#' Basic ICD code function
#'
#' This function is already used by the team, and filters alphanumeric ICD-9 and ICD-10 codes pursuant to requirements.
#'
#' @param input_vec Vector of all admissible ICD codes to filter on.
#' @param letter Letter to base filtration on (if purely numeric use empty string "")
#' @param lower Lower bound on the numeric element of the ICD code (includes numerics >=lower).
#' @param upper Upper bound on the numeric element of the ICD code (includes numerics <=upper).
#' @return Vector with filtered ICD codes.
#' @examples
#' val_filt(val3, "F", 10.0, 10.9) # Filter ICD codes in val3 to those between F10 and F10.9 (inclusive).
#'
#' @export

val_filt <- function(input_vec, letter, lower, upper){

  regex_pattern <- sprintf("^%s(\\d+\\.?\\d*)$", letter)
  filt <- input_vec[grep(regex_pattern, input_vec)]
  filt <- filt[as.numeric(gsub(paste0("^", letter), "", filt)) %>% between(lower, upper)]
  return(filt)
  }
