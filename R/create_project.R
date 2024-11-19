#' Create a new project structure with extensions
#'
#' Adapted from \link[thekidsbiostats:create_project]{create_project} from \url{https://github.com/The-Kids-Biostats/thekidsbiostats}.
#'
#' This function creates a directory structure for a new project based on a specified extension.
#' It can also create additional folders such as `data`, `reports`, `output` and `docs`.
#' The function copies specific files and folders from the chosen extension to the project directory.
#'
#' @param project_name String. Default `"standard"`. Name of R Project object to be created.
#' @param data Logical. If `TRUE`, a `data` directory will be created in the project. Defaults to `TRUE`.
#' @param reports Logical. If `TRUE`, a `reports` directory will be created in the project. Defaults to `TRUE`.
#' @param output Logical. If `TRUE`, an `output` direction will be created for the project. Defaults to `TRUE`.
#' @param docs Logical. If `TRUE`, a `docs` directory will be created in the project. Defaults to `TRUE`.
#'
#' @note
#' An interactive window will appear prompting the user to select the folder where the project structure should be created.
#' The default is the current working directory.
#'
#' @details For more details, see the \href{../doc/create_project.html}{vignette}.
#'
#' @examples
#' create_project(project_name = "investigation_x" # Folder where RProject is called "investigation_x"
#'                )
#'
#' @export

create_project <- function(project_name = "standard",
                           data = TRUE,
                           reports = TRUE,
                           output = TRUE,
                           docs = TRUE) {

  base_dir <- tcltk::tk_choose.dir(default = getwd(),
                                   caption = "Select a folder for the new project structure")

  if (is.na(base_dir) || base_dir == "") {
    stop("Please select a directory. Project creation cancelled.")
  }

  project_dir <- base_dir

  # Add necessary directories
  if (data) {
    if (!file.exists(file.path(project_dir, "data"))) dir.create(file.path(project_dir, "data"))
  }
  if (reports) {
    if (!file.exists(file.path(project_dir, "reports"))) dir.create(file.path(project_dir, "reports"))
  }
  if (docs) {
    if (!file.exists(file.path(project_dir, "docs"))) dir.create(file.path(project_dir, "docs"))
  }
  if (output) {
    if (!file.exists(file.path(project_dir, "output"))) dir.create(file.path(project_dir, "output"))
  }

  # Create the R Project file in the selected directory
  rproj_file <- file.path(project_dir, paste0(project_name, ".Rproj"))
  rproj_contents <- c("Version: 1.0") # Required

  writeLines(rproj_contents, rproj_file)

  message("Project structure and RProject file created at: ", project_dir)
}
