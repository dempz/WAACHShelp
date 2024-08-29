#' HTML summary table
#'
#' Two-way table similar to the "proc freq" function of SAS with two variables
#'
#' Created by PV (2023).
#' @param var1 Vector of first variable.
#' @param data Vector of second variable
#' @param data Dataset containing `var1` and `var2`
#' @param var2lab Label for `var2`.
#' @return Two-way table
#'
#' @export

twoway <- function(var1, var2, data = NULL, var2lab = NULL){

  # Pick up the arguments:
  arg <- match.call()
  v1  <- as.character(arg$var1)
  v2  <- as.character(arg$var2)
  dd  <- select(data, all_of(c(v1, v2)))
  dd[,v2] <- as_factor(dd[, v2, drop = T])

  # Sort out the labels:
  ll = attr(dd[,v2, drop = T], "label")
  if(is.null(ll)) lab = v2 else lab = ll
  if(!is.null(var2lab)) lab = var2lab

  ## Create a constant columns which we use in the formula:
  dd$tt <- lab
  ff = as.formula(paste0("~ " , v1, " | tt*", v2))

  # Output the table.
  table1::table1(ff, data = dd, overall = F)
}
