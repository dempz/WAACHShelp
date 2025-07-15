#' Summary function reminiscent of Stata's "tabset".
#'
#' Created by PV (2023).
#'
#' @param x Vector from input dataframe to summarise.
#' @param na.rm (Default TRUE) to remove NA (missing) observations from summary.
#' @param ... Any other arguments parsed into component base R functions.
#' @return Summary table with n (length), miss (number of missing observations), mean, sd (standard deviation), med (median), q25 (first quartile), q75 (third quartile), min (minimum value), max (maximum value).
#'
#' @examples
#' sumfun(iris$Sepal.Length)
#' @export

sumfun <- function(x, na.rm = TRUE, ...){
  data.frame(n = length(x),
             miss = sum(is.na(x)),
             mean = mean(x, na.rm = na.rm, ...),
             sd = stats::sd(x, na.rm = na.rm, ...),
             med = stats::median(x, na.rm = na.rm, ...),
             q25 = stats::quantile(x, prob = c(0.25), na.rm = na.rm, names = F, ...),
             q75 = stats::quantile(x, prob = c(0.75), na.rm = na.rm, names = F, ...),
             min = min(x, na.rm = na.rm, ...),
             max = max(x, na.rm = na.rm, ...)
  )
}
