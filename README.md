# WAACHShelp

![R-CMD-check](https://github.com/dempz/WAACHShelp/actions/workflows/R-CMD-check.yaml/badge.svg)
[![Codecov test coverage](https://codecov.io/gh/dempz/WAACHShelp/graph/badge.svg)](https://app.codecov.io/gh/dempz/WAACHShelp)


General helper functions for the WAACHS linked data project.

## Installation instructions
`remotes::install_github(repo = "dempz/WAACHShelp", build_vignettes = TRUE)` or `devtools::install_github(repo = "dempz/WAACHShelp", build_vignettes = TRUE)`

## Accessing vignettes

Vignettes have been built for some of the functions. These can be opened (using R, for now). The vignettes have the same name as the function.

At the moment, vignettes exist for:

+ `icd_morb_flag`
+ `create_project`
+ `create_markdown`

Accessing these vignettes can be done two ways:

1) Using `utils::browseVignettes(package = "WAACHShelp")`
     + Opens vignette via web browser.
3) Using `vignette(x, package = "WAACHShelp")` where x is the function name
     + Opens the vignette in the "Help" tab of RStudio.
