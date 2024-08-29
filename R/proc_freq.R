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
#' @examples
#' test = iris
#' proc_freq(Species, test)
#' test[1:4, "Species"] <- NA
#' proc_freq(Species, test)
#'
#' @export

proc_freq <- function(var1, data = NULL, sort = NULL, min.frq = 0){

  suppressMessages(library(haven))
  suppressMessages(library(table1))
  suppressMessages(library(flextable))

  # Pick up the arguments and
  arg <- match.call()
  cc  <- as.character(arg$var1)
  dd  <- select(data, arg$var1)
  ll <-  attr(dd[,cc, drop = T], "label")
  ff <-  attr(dd[,cc, drop = T], "labels")

  # Try to pick up some labels:
  if(is.null(ll)) lab = cc else lab = ll
  if(!is.null(ff))  dd[,cc] <- haven::as_factor(dd[,cc, drop = T])
  dd.na <- na.omit(dd)

  # Start with the basic table:
  ft <- dd.na %>% group_by_at(cc) %>%
    summarise(Frequency = n())


  if(is.numeric(min.frq) & min.frq > 0){

    ft[,1] <- ifelse(ft[,2, drop = T] < min.frq, paste("n <", min.frq), ft[,1, drop = T])
    ft <- ft %>% group_by_at(cc) %>% summarise(Frequency = sum(Frequency))

  }

  ft <- ft %>% mutate(Percent = 100*Frequency/nrow(dd.na))

  # sort it as required:
  if(!is.null(sort)){
    if(sort == "asc")  {ft <- ft %>% arrange( Frequency)}
    if(sort == "desc") {ft <- ft %>% arrange(-Frequency)}
  }

  ## If min.frq is used, place that category at the end:
  if(is.numeric(min.frq) & min.frq > 0){
    tord <- 1:nrow(ft)
    tord[ft[,1, drop = T] == paste("n <", min.frq)] <- 1e6
    ft <- ft[order(tord),]
  }

  # Add the cumulative columns:
  ft <- mutate(ft,
               "Cumulative Frequency" = round(cumsum(Frequency), 1),
               "Cumulative Percent" = round(cumsum(Percent), 1),
               Percent = round(Percent, 1))

  an_fpar <- officer::fpar(officer::run_linebreak())

  # Taransform it into an html table
  ft <- ft %>% flextable() %>%
    border_inner() %>%
    border_outer() %>%
    add_header_row(values = lab,  colwidths = 5) %>%
    add_footer_row(values = paste("Frequency Missing =",
                                  sum(is.na(dd[,cc, drop = T]))),
                   colwidths = 5) %>%
    #set_table_properties(width = 1, layout = "autofit") %>%
    theme_box %>%
    set_caption(caption = " ", fp_p = an_fpar)

  pdim = dim_pretty(ft)

  ft <- width(ft, width = pdim$width)

  #ft <- height(ft, height = pdim$height)
  ft
}
