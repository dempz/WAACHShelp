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

  write.csv(x = dataframe,
            file = paste0(path,filename,".csv"), row.names = F)

  haven::write_sas(data = dataframe,
                   path = paste0(path, filename,".sas7bdat"))

  readr::write_rds(x = dataframe,
                   file = paste0(path, filename, ".RDS"))
}
