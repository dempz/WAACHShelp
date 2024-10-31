#' Helper Function #4
#'
#' This is an internal helper function.
#'
#' @keywords internal

find_key <- function(value,
                     colname_list) {
  sapply(value, function(v) {
    keys <- names(colname_list)[sapply(colname_list, function(x) v %in% x)]
    if (length(keys) == 0) {
      return(NA)  # Return NA if the value is not found
    }
    return(keys[1])  # Return the first match if there are multiple
  })
}
