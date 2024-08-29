#' ICD flagging function
#'
#' This function serves to add flags to an input data set (morbidity at this stage) pursuant to ICD codes.
#' Flags can be added for general categories based on pre-established ICD codes (e.g., any mental health contact, any substance-related contact, any alcohol/tobacco-related contact etc.) or add a custom set of ICD codes.
#' The file with these pre-established ICD codes are saved as an .RData file and are trivial to change.
#'
#' @param data Input dataset (morbidity).
#' @param dobmap DOBMap file corresponding to input dataset.
#' @param flag_category Type of flag to generate. Takes values from reference file (e.g., MH_morb, Sub_morb, etc.) or "Other" for custom ICD specification and flagging.
#' @param flag_other_varname Flag variable name (specified only When `flag_category == "Other"`). Input as character string.
#' @param flag_other_vals Flag variable ICD values (specified only when `flag_category == "Other"`). Input as list with keys "diag_ediag" (for searching across diagnosis, ediag variables) and "ecode" (for searching across ecode variables).
#' @param under_age Return additional variables corresponding to when participant was strictly under `age` y.o.. Uses DOBMap DOB and subadm morbidity admission date. Variables have suffix "_under{age}".
#' @param age Integer. Age to consider for the `under_age` variable (default 18).
#' @param person_summary Summarise results at a person-level.
#' @return Flagged dataframe.
#' @examples
#' # Example 1: Basic use
#' icd_morb_flag(data = morb,
#'               dobmap = dob,
#'               flag_category = "MH_morb" # Create any MH contact flag
#'               under_age = T, # Return additional set of flags depending on whether participant is under 18 at time of admission.
#'               age = 18
#'               )
#'
#' # Example 2: Specify custom set of ICD codes to base flags on
#' icd_morb_flag(data = morb,
#'               dobmap = dob,
#'               flag_category = "Other",
#'               flag_other_varname = "testing_var",                                # Create new flagging variable called "testing_var"
#'               flag_other_vals = list("diag_ediag" = c("abc24.21", "xyz4231.2")), # Base flag on searching across the "diagnosis" and "ediag" variables (vector corresponds to ICD codes)
#'               under_age = T,
#'               age = 25,                                                          # Return additional set of flags depending on whether participant is under 25 at time of admission.
#'               person_level = F
#'               )
#' @export

icd_morb_flag <- function(data,
                          dobmap,
                          flag_category,
                          flag_other_vals,
                          flag_other_varname,
                          under_age = FALSE,
                          age = 18,
                          person_summary = FALSE){

  data("icd_dat", package = "WAACHShelp")

  if (!(flag_category %in% c(unique(icd_dat$var), "Other"))) {
    stop(sprintf("Error: '%s' is not a valid input. Please choose from %s. If variable not contained in this list, please specify `flag_category == \"Other\"` and use the `flag_other_varname` and `flag_other_vals` arguments.",
                 flag_category, paste(c(unique(icd_dat$var)), collapse = ", ")))
  }

  # 1) Calculate age at record
  ## 1.1) For morbidity data sets -> relative to `subadm`
  age_test <- age - 1
  #print(age_test)
  data <- data %>%
    left_join(dobmap %>% select(rootnum, dob), by = "rootnum") %>%
    mutate(age_adm = lubridate::time_length(lubridate::interval(dob, subadm), unit = "years"),
           adm_under_age = case_when(floor(age_adm) <= age_test ~ "Yes",
                                     floor(age_adm) > age_test  ~ "No")) # Calculate ages


  # 2) Extract admissible ICD codes for the selected `flag_category`
  ## Uses the `icd_extraction` function
  icds <- icd_extraction(data = data,
                         flag_category = flag_category,
                         flag_other_varname = flag_other_varname,
                         flag_other_vals = flag_other_vals)


  # 3) Create flagging variables
  ## Uses `icd_flagging` function
  icd_flags <- icd_flagging(data = data,
                            flag_category = flag_category,
                            icd_list = icds,
                            flag_other_vals = flag_other_vals,
                            flag_other_varname = flag_other_varname
  )

  data <- suppressMessages(left_join(data, icd_flags)) # Join by ALL variables to avoid double-ups



  # 4) Add functionality for under age flagging
  if (under_age == TRUE){
    if (!"Other" %in% flag_category){
      data <- data %>%
        mutate(across(!!flag_category, ~case_when(adm_under_age == "Yes" ~ .,
                                                  adm_under_age == "No" ~ "No"),
                      .names = "{.col}_under_temp")
               ) %>%
        rename_with(~ sub("_under_temp$", paste0("_under", age), .x), ends_with("_under_temp"))

    } else if ("Other" %in% flag_category){
      data <- data %>%
        mutate(across(!!flag_other_varname, ~case_when(adm_under_age == "Yes" ~ .,
                                                       adm_under_age == "No" ~ "No"),
                      .names = "{.col}_under_temp")
               ) %>%
        rename_with(~ sub("_under_temp$", paste0("_under", age), .x), ends_with("_under_temp"))
    }
  } else if (under_age == FALSE){
    data <- data
  }


  # 5) Add functionality for person-level summary
  ## Use `person_level` function
  if (person_summary == FALSE){
    data <- data

  } else if (person_summary == TRUE){
    if (!"Other" %in% flag_category){
      if (under_age == FALSE){
        data <- person_level(data, flag_category)

      } else if (under_age == TRUE) {
        data <- person_level(data, paste0(flag_category, "_under", age))

      }
    } else if ("Other" %in% flag_category){
      if (under_age == FALSE){
        data <- person_level(data, flag_other_varname)

      } else if (under_age == TRUE){
        data <- person_level(data, paste0(flag_other_varname, "_under", age))

      }
    }
  }

  return(data)
}
