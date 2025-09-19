# WAACHShelp

[![name status badge](https://dempz.r-universe.dev/badges/:name)](https://dempz.r-universe.dev/)
[![WAACHShelp status badge](https://dempz.r-universe.dev/WAACHShelp/badges/version)](https://dempz.r-universe.dev/WAACHShelp)
![R-CMD-check](https://github.com/dempz/WAACHShelp/actions/workflows/R-CMD-check.yaml/badge.svg)
[![Codecov test coverage](https://codecov.io/gh/dempz/WAACHShelp/graph/badge.svg)](https://app.codecov.io/gh/dempz/WAACHShelp)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)


General helper functions for the WAACHS linked data project.

## Installation instructions

The package can be installed from the R-universe, by:
```
install.packages("WAACHShelp", repos = "https://dempz.r-universe.dev")
```

ALternatively, the package can be installed using `remotes`:
```
remotes::install_github(repo = "dempz/WAACHShelp", build_vignettes = TRUE)
```

## Accessing vignettes

Vignettes have been built for some of the functions. These can be opened (using R, for now). The vignettes have the same name as the function.

At the moment, vignettes exist for:

+ `icd_morb_flag`
+ `create_project`
+ `create_markdown`
+ `aducust_flag`

Accessing these vignettes can be done two ways:

1) Using `utils::browseVignettes(package = "WAACHShelp")`
     + Opens vignette via web browser.
3) Using `vignette(x, package = "WAACHShelp")` where x is the function name
     + Opens the vignette in the "Help" tab of RStudio.
