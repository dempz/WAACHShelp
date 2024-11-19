## ----include = FALSE, echo = F------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup, echo = T, message=F, warning=FALSE--------------------------------
# Load the package
library(WAACHShelp)

## ----echo = T-----------------------------------------------------------------
data(icd_dat, package = "WAACHShelp")

head(icd_dat)

## -----------------------------------------------------------------------------
unique(icd_dat$var)

## ----echo = T, eval=FALSE-----------------------------------------------------
# icd_morb_flag(data = morb_dat,
#               flag_category = "MH_morb")

## ----eval=FALSE, echo=TRUE----------------------------------------------------
# icd_morb_flag(data = morb_dat,
#               flag_category = "Other",
#               diag_type = c("principal diagnosis", "additional diagnoses", "external cause of injury"),
#               diag_type_custom_params = list("principal diagnosis" = list(list(letter = "F",
#                                                                                lower = 0,
#                                                                                upper = 99.9999),
#                                                                           list(letter = "" ,
#                                                                                lower = 290,
#                                                                                upper = 319.9999)),
#                                              "additional diagnoses" = list(list(letter = "F",
#                                                                                 lower = 0,
#                                                                                 upper = 99.9999),
#                                                                            list(letter = "",
#                                                                                 lower = 290,
#                                                                                 upper = 319.9999)),
#                                              "external cause of injury" = list(list(letter = "E",
#                                                                                     lower = 950,
#                                                                                     upper = 959.9999),
#                                                                                list(letter = "X",
#                                                                                     lower = 60,
#                                                                                     upper = 84.9999))),
#               flag_other_varname = "MH_morb_custom")

## ----eval=FALSE, echo=TRUE----------------------------------------------------
# # Set search parameters for principal, additional diagnoses
# diag_ediag_params <- list(list(letter = "F",
#                                lower = 0,
#                                upper = 99.9999),
#                           list(letter = "" ,
#                                lower = 290,
#                                upper = 319.9999))
# 
# # Set search parameters for ecode variables
# ecode_params <- list(list(letter = "E",
#                           lower = 950,
#                           upper = 959.9999),
#                      list(letter = "X",
#                           lower = 60,
#                           upper = 84.9999))
# 
# 
# icd_morb_flag(data = morb_dat,
#               flag_category = "Other",
#               diag_type = "custom",
#               diag_type_custom_vars = c("diag",                # Principal diagnosis variables
#                                         paste0("ediag", 1:20), # Additional diagnosis variables
#                                         paste0("ecode", 1:4)   # External cause of injury variables
#                                         ),
#               diag_type_custom_params = list("diag" = diag_ediag_params,
#                                              setNames(rep(list(diag_ediag_params), 20), paste0("ediag", 1:20)),
#                                              setNames(rep(list(ecode_params), 20), paste0("ecode", 1:4))),
#               flag_other_varname = "MH_morb_custom")

## ----eval=FALSE, echo=TRUE----------------------------------------------------
# icd_morb_flag(data = morb_dat,
#               flag_category = "Other",
#               diag_type = c("additional diagnoses", "custom"),
#               diag_type_custom_vars = "dagger",
#               diag_type_custom_params = list("additional diagnoses" = diag_ediag_params,
#                                              "dagger" = diag_ediag_params),
#               flag_other_varname = "MH_morb_custom")

## ----eval = F, echo = T-------------------------------------------------------
# icd_morb_flag(data = morb_dat,
#               flag_category = "MH_morb",
#               person_summary = TRUE)

## ----eval=FALSE, echo=TRUE----------------------------------------------------
# # Creates variables `MH_morb`, `MH_morb_under18`
# icd_morb_flag(data = morb_dat,
#               dobmap = dobmap_dat,
#               flag_category = "MH_morb",
#               under_age = TRUE,
#               age = 25)

## ----eval=FALSE, echo=TRUE----------------------------------------------------
# # Creates variable `MH_morb_under18`
# icd_morb_flag(data = morb_dat,
#               dobmap = dobmap_dat,
#               flag_category = "MH_morb",
#               under_age = TRUE,
#               age = 25,
#               person_summary = TRUE)

