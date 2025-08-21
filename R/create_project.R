#' Create a new project structure with extensions
#'
#' Adapted from \link[thekidsbiostats:create_project]{create_project} from \url{https://github.com/The-Kids-Biostats/thekidsbiostats}.
#'
#' This function creates a directory structure for a new project based on a specified extension.
#' It can also create additional folders such as `data`, `reports`, `output` and `documentation`.
#' The function copies specific files and folders from the chosen extension to the project directory.
#'
#' @param project_name String. Default `"standard"`. Name of R Project object to be created.
#' @param data Logical. If `TRUE`, a `data` directory will be created in the selected folder. Defaults to `TRUE`.
#' @param reports Logical. If `TRUE`, a `reports` directory will be created in the selected folder. Defaults to `TRUE`.
#' @param output Logical. If `TRUE`, an `output` direction will be created in the selected folder. Defaults to `TRUE`.
#' @param documentation Logical. If `TRUE`, a `documentation` directory will be created in the selected folder. Defaults to `TRUE`.
#' @param R Logical. If `TRUE`, an `R` directory will be created in the selected folder. Defaults to `TRUE`.
#' @param other_folders Vector of strings that contain any other folders that should also be created. Elements should be unique. Default `NULL`.
#'
#' @note
#' An interactive window will appear prompting the user to select the folder where the project structure should be created.
#' The default is the current working directory.
#'
#' @details For more details, see the \href{https://dempz.github.io/WAACHShelp/articles/create_project.html}{vignette}.
#'
#' @examples
#' \dontrun{
#' create_project(project_name = "investigation_x", other_folders = c("folder1", "folder2"))
#' }
#'
#' @export

create_project <- function(project_name = "standard",
                           data = TRUE,
                           reports = TRUE,
                           output = TRUE,
                           documentation = TRUE,
                           other_folders = NULL,
                           R = TRUE) {

  if (length(unique(other_folders)) != length(other_folders)) {
    stop("The `other_folder` values specified are not unique! Project creation cancelled.")
  }

  base_dir <- rstudioapi::selectDirectory(caption = "Select a folder for the new project structure")

  if (is.na(base_dir) || base_dir == "") {
    stop("Please select a directory. Project creation cancelled.")
  }

  project_dir <- base_dir

  # add home directory
  dir.create(file.path(project_dir, project_name))

  # Add necessary directories
  if (data) {
    if (!file.exists(file.path(project_dir, project_name, "data"))) dir.create(file.path(project_dir, project_name, "data"))
  }
  if (reports) {
    if (!file.exists(file.path(project_dir, project_name, "reports"))) dir.create(file.path(project_dir, project_name, "reports"))
  }
  if (documentation) {
    if (!file.exists(file.path(project_dir, project_name, "documentation"))) dir.create(file.path(project_dir, project_name, "documentation"))
  }
  if (output) {
    if (!file.exists(file.path(project_dir, project_name, "output"))) dir.create(file.path(project_dir, project_name, "output"))
  }
  if (R) {
    if (!file.exists(file.path(project_dir, project_name, "R"))) dir.create(file.path(project_dir, project_name, "R"))
  }
  if (!is.null(other_folders)){
    for (i in other_folders){
      if (!file.exists(file.path(project_dir, project_name, i))) dir.create(file.path(project_dir, project_name, i))
    }
  }

  # Create the R Project file in the selected directory
  rproj_file <- file.path(project_dir, project_name, paste0(project_name, ".Rproj"))
  rproj_contents <- c("Version: 1.0") # Required

  writeLines(rproj_contents, rproj_file)

  message("Project structure and RProject file created at: ", project_dir)
}
