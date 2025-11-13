# Create a new project structure with extensions

Adapted from create_project from
<https://github.com/The-Kids-Biostats/thekidsbiostats>.

## Usage

``` r
create_project(
  project_name = "standard",
  data = TRUE,
  reports = TRUE,
  output = TRUE,
  documentation = TRUE,
  other_folders = NULL,
  R = TRUE
)
```

## Arguments

- project_name:

  String. Default `"standard"`. Name of R Project object to be created.

- data:

  Logical. If `TRUE`, a `data` directory will be created in the selected
  folder. Defaults to `TRUE`.

- reports:

  Logical. If `TRUE`, a `reports` directory will be created in the
  selected folder. Defaults to `TRUE`.

- output:

  Logical. If `TRUE`, an `output` direction will be created in the
  selected folder. Defaults to `TRUE`.

- documentation:

  Logical. If `TRUE`, a `documentation` directory will be created in the
  selected folder. Defaults to `TRUE`.

- other_folders:

  Vector of strings that contain any other folders that should also be
  created. Elements should be unique. Default `NULL`.

- R:

  Logical. If `TRUE`, an `R` directory will be created in the selected
  folder. Defaults to `TRUE`.

## Details

This function creates a directory structure for a new project based on a
specified extension. It can also create additional folders such as
`data`, `reports`, `output` and `documentation`. The function copies
specific files and folders from the chosen extension to the project
directory.

For more details, see the
[vignette](https://dempz.github.io/WAACHShelp/articles/create_project.html).

## Note

An interactive window will appear prompting the user to select the
folder where the project structure should be created. The default is the
current working directory.

## Examples

``` r
if (FALSE) { # \dontrun{
create_project(project_name = "investigation_x", other_folders = c("folder1", "folder2"))
} # }
```
