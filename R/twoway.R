#' HTML summary table
#'
#' Two-way table similar to the "proc freq" function of SAS with two variables
#'
#' Created by PV (2023).
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' This function was deprecated because it was no longer required by analysts.
#'
#' @param var1 Vector of first variable
#' @param var2 Vector of second variable
#' @param data Vector of second variable
#' @param data Dataset containing `var1` and `var2`
#' @param var2lab Label for `var2`.
#' @return Two-way table
#'
#' @export

twoway <- function(var1, var2, data = NULL, var2lab = NULL){
  lifecycle::deprecate_warn(when = "1.4.2",
                            what = "twoway()",
                            details = "Function is no required by analysts.")

  # Pick up the arguments:
  arg <- match.call()
  v1  <- as.character(arg$var1)
  v2  <- as.character(arg$var2)
  dd  <- dplyr::select(data, dplyr::all_of(c(v1, v2)))

  # Convert all character columns to factor
  dd <- dd %>% dplyr::mutate(dplyr::across(dplyr::where(is.character), as.factor))

  # Sort out the labels:
  ll <- attr(dd[[v2]], "label")
  lab <- if(is.null(ll)) v2 else ll
  if(!is.null(var2lab)) lab <- var2lab

  # Create a constant column for table1
  dd$tt <- lab
  ff <- stats::as.formula(paste0("~ ", v1, " | tt * ", v2))

  # Output the table
  table1::table1(ff, data = dd, overall = FALSE)
}
