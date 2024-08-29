#' Add rows to labelled data set.
#'
#' Almost identical to the original `dplyr::add_row` but also looks for `format.sas` attribute which `haven` provides when loading as SAS dataset.
#'
#' Created by PV (2023).
#'
#' @param id Default NULL
#' @param ... Other parameters to parse to function.
#' @return SAS labelled dataframe
#'
#' @export

add_rows2 <- function (..., id = NULL) {
  suppressMessages(library(dplyr))

  cnames <- purrr::map(list(...), ~colnames(.x)) %>% purrr::flatten_chr()
  if (!is.null(id) && id %in% cnames) {
    id <- make.unique(c(cnames, id))[length(cnames) + 1]
    warning(sprintf("Value of `id` already exists as column name. ID column was renamed to `%s`.",
                    id), call. = FALSE)
  }
  dat <- lapply(list(...), function(d) {
    d[, unique(names(d)), drop = FALSE]
  })
  x <- dplyr::bind_rows(dat, .id = id)
  at <- purrr::map(list(...), function(x) {
    purrr::map(x, ~attributes(.x))
  }) %>% purrr::flatten() %>% purrr::compact()
  if (!sjmisc::is_empty(at)) {
    at <- at[!duplicated(at)]
    for (i in names(at)) {
      attr(x[[i]], "labels") <- at[[i]][["labels"]]
      attr(x[[i]], "label") <- at[[i]][["label"]]
      attr(x[[i]], "na_values") <- at[[i]][["na_values"]]
      attr(x[[i]], "na.values") <- at[[i]][["na.values"]]
      attr(x[[i]], "na_range") <- at[[i]][["na_range"]]
      attr(x[[i]], "na.range") <- at[[i]][["na.range"]]
      attr(x[[i]], "format.sas") <- at[[i]][["format.sas"]] ## Added by Phil
    }
  }
  x
}
