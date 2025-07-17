#' ICD Classification Data set
#'
#' Data set specifying the ICD (9 & 10) codes for different events in the morbidity data set.
#'
#' @name icd_dat
#' @docType data
#' @keywords dataset
#' @usage data(icd_dat)
#'
#' @format A data frame where rows correspond to an event and columns correspond to the variable name, morbidity search parameters (diagnosis/ediag, ecode) and ICD code breakdown
#' \describe{
#'   \item{num}{Counter variable representing the number of rows associated with any given var}
#'   \item{classification}{Classification type}
#'   \item{var}{Variable name}
#'   \item{broad_type}{Type of diagnosis field this ICD code corresponds to (diagnosis & ediag = "diag_ediag", ecode = "ecode")}
#'   \item{letter}{Letter of ICD code (purely numeric is empty string "")}
#'   \item{lower}{Lower bound of numeric element of ICD code}
#'   \item{upper}{Upper bound of numeric element of ICD code}
#'   ...
#' }
#' @source Generated internally by package
"icd_dat"
