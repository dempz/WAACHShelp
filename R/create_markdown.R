#' Create Template for Quarto Markdown
#'
#' This function creates a HTML or Word template in the current working directory
#' using a specified Quarto extension. It copies the template files to the
#' `_extensions/` directory and generates a new Quarto markdown (.qmd) file.
#'
#' Adapted from \link[thekidsbiostats:create_template]{create_template} from \url{https://github.com/The-Kids-Biostats/thekidsbiostats}.
#'
#' @param file_name A string. The name of the new Quarto markdown (.qmd) file. This must be provided.
#' @param directory A string. The name of the directory to plate the files. Default is NULL. Requires user specification
#' @param ext_name A string. The extension type to create. Default "html" (alternatives: "word").
#'
#' @details
#' The function first checks whether a `_extensions/` directory exists in the current working
#' directory. If not, it creates one. It then copies the necessary extension files from the
#' package's internal data to the `_extensions/` directory. Finally, it creates
#' a new Quarto markdown file based on the extension template.
#'
#' By default, the `reports` folder will be selected to house the report.
#'
#' @details For more details, see the \href{../doc/create_markdown.html}{vignette}.
#'
#' @note
#' The function assumes that the package `WAACHShelp` contains the necessary extension files
#' under `ext_qmd/_extensions/`.
#'
#' @examples
#' \dontrun{
#' create_markdown(file_name = "my_doc",
#'                 ext_name = "word")
#' }
#'
#' @export

create_markdown <- function(file_name = NULL,
                            directory = "reports",
                            ext_name = "html") {

  # Ensure valid extension type is selected
  if (is.null(ext_name) || !ext_name %in% c("word", "html")) {
    stop("You must provide a valid ext_name. Please select from 'word' or 'html'")
  }

  # Ensure a valid file name is selected
  if (is.null(file_name)) {
    stop("You must provide a valid file_name.")
  }

  # Check if the "reports" folder exists, otherwise use the current working directory
  default_dir <- ifelse(dir.exists(directory), directory, getwd())

  # Aid user in selecting where to create this template
  directory <- rstudioapi::selectDirectory(caption = "Select a folder to create the QMD template",
                                           path = default_dir)

  if (is.na(directory) || directory == "" || is.null(directory)) {
    stop("No directory selected. Template creation cancelled.")
  }

  # Get the extensions file from the WAACHShelp package
  valid_ext <- list.files(system.file("ext_qmd/_extensions/", package = "WAACHShelp"))

  # check for available extensions
  stopifnot("Extension not in package" = ext_name %in% valid_ext)

  extfolder <- paste0(directory, "/_extensions")

  # Check for existing _extensions directory and create it if necessary
  if (!file.exists(extfolder)) {
    dir.create(extfolder)
    message("Created '_extensions' folder inside the selected directory.")
  }

  # Create the extension-specific subfolder (html or word)
  ext_subfolder <- file.path(extfolder, ext_name)
  if (!file.exists(ext_subfolder)) {
    dir.create(ext_subfolder)
    message(paste0("Created '", ext_name, "' folder inside '_extensions'."))
  }

  # Copy from internals
  file.copy(
    from = system.file(paste0("ext_qmd/_extensions/", ext_name), package = "WAACHShelp"),
    to = extfolder,
    overwrite = TRUE,
    recursive = TRUE,
    copy.mode = TRUE
    )

  # Logic check to make sure extension files were moved
  n_files <- length(dir(paste0(extfolder, "/", ext_name)))

  if(n_files >= 2){
    message(paste("Contents of", ext_name, "have been successfully carried across."))
  } else {
    message("Extension appears not to have been created")
  }

  # Create new qmd report based on skeleton
  file.copy(paste0(extfolder, "/", ext_name, "/template.qmd"),
            paste0(directory, "/", file_name, ".qmd", collapse = ""))

  # remove qmd template in _extensions
  file.remove(paste0(extfolder, "/", ext_name, "/template.qmd"))
}
