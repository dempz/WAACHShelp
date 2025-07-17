#' HTML summary table
#'
#' Renders a HTML table ready for plonking into a HTML or word document.
#'
#' Renders output similar to the "proc freq" function of SAS.
#'
#' Created by PV (2023).
#' @param var1 Name of the variable
#' @param data Dataset that contains `var1`
#' @param sort Optional argument which can take on "asc" or "desc" to indicate the type of sort required.
#' @param min.frq Minimum frequency
#' @return Dataframe
#'
#' @importFrom magrittr %>%
#' @importFrom data.table :=
#'
#' @examples
#' test = iris
#' proc_freq(Species, test)
#' test[1:4, "Species"] <- NA
#' proc_freq(Species, test)
#'
#' @export

proc_freq <- function(var1, data = NULL, sort = NULL, min.frq = 0){

  # Avoid "no visible binding" notes for R CMD check
  Frequency <- Percent <- NULL

  # Pick up the arguments and
  arg <- match.call()
  cc  <- as.character(arg$var1)
  dd  <- dplyr::select(data, dplyr::all_of(cc))
  ll <-  attr(dd[[1]], "label")
  ff <-  attr(dd[[1]], "labels")

  # Try to pick up some labels:
  if(is.null(ll)) lab <- cc else lab <- ll
  if(!is.null(ff))  dd[[1]] <- haven::as_factor(dd[[1]])
  dd.na <- stats::na.omit(dd)

  # Start with the basic table:
  ft <- dd.na %>%
    dplyr::group_by_at(cc) %>%
    dplyr::summarise(Frequency = dplyr::n())

  if(is.numeric(min.frq) & min.frq > 0){

    ft[[1]] <- ifelse(ft$Frequency < min.frq, paste("n <", min.frq), ft[[1]])
    ft <- ft %>%
      dplyr::group_by_at(cc) %>%
      dplyr::summarise(Frequency = sum(Frequency))

  }

  ft <- ft %>%
    dplyr::mutate(Percent = 100 * Frequency / nrow(dd.na))

  # sort it as required:
  if(!is.null(sort)){
    if(sort == "asc")  {ft <- ft %>% dplyr::arrange(Frequency)}
    if(sort == "desc") {ft <- ft %>% dplyr::arrange(dplyr::desc(Frequency))}
  }

  ## If min.frq is used, place that category at the end:
  if(is.numeric(min.frq) & min.frq > 0){
    tord <- 1:nrow(ft)
    tord[ft[[1]] == paste("n <", min.frq)] <- 1e6
    ft <- ft[order(tord),]
  }

  # Add the cumulative columns:
  ft <- dplyr::mutate(ft,
                      "Cumulative Frequency" = round(cumsum(Frequency), 1),
                      "Cumulative Percent" = round(cumsum(Percent), 1),
                      Percent = round(Percent, 1))

  an_fpar <- officer::fpar(officer::run_linebreak())

  # Transform it into an html table
  ft <- ft %>%
    flextable::flextable() %>%
    flextable::border_inner() %>%
    flextable::border_outer() %>%
    flextable::add_header_row(values = lab,  colwidths = 5) %>%
    flextable::add_footer_row(values = paste("Frequency Missing =", sum(is.na(dd[[1]]))),
                              colwidths = 5) %>%
    # set_table_properties(width = 1, layout = "autofit") %>%
    flextable::theme_box() %>%
    flextable::set_caption(caption = " ", fp_p = an_fpar)

  pdim <- flextable::dim_pretty(ft)

  ft <- flextable::width(ft, width = pdim$width)

  # ft <- height(ft, height = pdim$height)
  ft
}

