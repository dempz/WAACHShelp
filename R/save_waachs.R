#' Save dataframe
#'
#' General function to save a dataset in usable formats across different platforms. Specifically, will return .csv, .sas7bdat, and .RDS files.
#'
#' @param dataframe Input dataset to save.
#' @param path Path to save file to.
#' @param filename Name of the file to save.
#' @return Saved object
#'
#' @export


save_waachs <- function(dataframe, path, filename){

  if (!dir.exists(path)) {
    stop("The path provided does not exist.")
  }

  if (is.null(filename) || !nzchar(filename)) {
    stop("`filename` must be provided and non-empty")
  }

  utils::write.csv(x = dataframe,
                   file = file.path(path, paste0(filename,".csv")), row.names = FALSE)

  haven::write_sas(data = dataframe,
                   path = file.path(path, paste0(filename,".sas7bdat")))

  readr::write_rds(x = dataframe,
                   file = file.path(path, paste0(filename, ".RDS")))
}
