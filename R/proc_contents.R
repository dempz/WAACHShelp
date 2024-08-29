#' Compile metadata from dataframe
#'
#' This little function pulls out the labels and formats from a dataframe and compiles this metadata as a dataframe.
#'
#' Imitates the "proc contents" function of SAS.
#'
#' Created by PV (2023).
#'
#' @param df Dataframe to input.
#' @return Dataframe
#'
#' @examples
#' proc_contents(iris)
#'
#' @export

proc_contents = function(df){
  dplyr::bind_cols(var_name = names(df),
                   class = purrr::map_chr(df, function(x) ifelse(is.null(attr(x, "class")),
                                                                 "",
                                                                 attr(x, "class"))),
                   format.sas = purrr::map_chr(df, function(x) ifelse(is.null(attr(x, "format.sas")),
                                                                      "",
                                                                      attr(x, "format.sas"))),
                   num_labels = purrr::map_chr(df, function(x) ifelse(is.null(attr(x, "labels")),
                                                                      "null",
                                                                      length(attr(x, "labels")))),
                   label = purrr::map_chr(df, function(x) ifelse(is.null(attr(x, "label")),
                                                                 "",
                                                                 attr(x, "label"))))
}
