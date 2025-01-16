#' ICD flagging function
#'
#' This function serves to add flags to an input data set (morbidity at this stage) pursuant to ICD codes.
#' Flags can be added for general categories based on pre-established ICD codes (e.g., any mental health contact, any substance-related contact, any alcohol/tobacco-related contact etc.) or add a custom set of ICD codes.
#' The file with these pre-established ICD codes are saved as an .RData file and are trivial to change.
#'
#' @details For more details, see the \href{../doc/icd_morb_flag.html}{vignette}.
#'
#' @param data Input dataset (morbidity).
#' @param dobmap DOBmap file corresponding to input dataset.
#' @param flag_category Type of flag to generate. Takes values from reference file (e.g., MH_morb, Sub_morb, etc.) or "Other" for custom ICD specification and flagging.
#' @param flag_other_varname Flag variable name (specified only When `flag_category == "Other"`). Input as character string.
#' @param diag_type Diagnosis type. Select from "principal diagnosis", (all) "additional diagnoses", "external cause of injury", "custom".
#' @param diag_type_custom_vars Variables to search across when `diag_type == "custom"`.
#' @param diag_type_custom_params Search parameters to search across when `diag_type == "custom"`. Must be a list where the keys are the variable names and values are the inputs to `WAACHShelp::val_filt`. Can also be a list of lists where multiple ICD can be searched across for a single variable. See examples for specification.
#' @param under_age Return additional variables corresponding to when participant was strictly under `age` y.o.. Uses DOBmap DOB and subadm morbidity admission date. Variables have suffix "_under{age}".
#' @param age Integer. Age to consider for the `under_age` variable (default 18).
#' @param person_summary Summarise results at a person-level.
#' @param id_var Joining (ID) variable consistent between `data` and `dobmap`. Default `rootnum`.
#' @param morb_date_var Hospital morbidity date variable in `data`. Default `"subadm"`.
#' @param dobmap_dob_var Date of birth (DOB) variable in `dobmap`. Default `"dob"`.
#' @param dobmap_other_vars Other variables to carry across from DOBmap file when joining to `data`. Default `NULL`. Can be a vector of strings.
#' @return Flagged dataframe.
#' @examples
#' # Example 1: Basic use
#' ## Create any mental health or substance-related morbidity flag, "MH_morb"
#' ## This automatically searches across all "principal diagnosis", "additional diagnoses", "external cause of injury" codes.
#' ## Create additional flag for whether admission occurred when under 18 years of age
#' icd_morb_flag(data = morb,
#'               dobmap = dob,
#'               flag_category = "MH_morb", # Create any MH contact flag
#'               under_age = T, # Return additional set of flags depending on whether participant is under 18 at time of admission.
#'               age = 18,
#'               dobmap_other_vars = c("xyz123", "abc456") # Also select variables `xyz123`, `abc456` from DOBmap and join onto `data` file.
#'               )
#'
#' # Example 2: Basic use
#' ## Create any substance-related morbidity flag, "Sub_morb"
#' icd_morb_flag(data = morb,
#'               flag_category = "Sub_morb" # Create any MH contact flag
#'               )
#'
#' # Example 3: Search only *principal diagnosis* and *first additional diagnosis* for a custom set of ICD codes
#' ## Call this variable "test_var"
#' icd_morb_flag(data = morb,
#'               flag_category = "Other",
#'               diag_type = "custom",
#'               diag_type_custom_vars = c("diagnosis", "ediag20"),
#'               diag_type_custom_params = list("diagnosis" = list("letter" = "F",
#'                                                                 "lower" = 0,
#'                                                                 "upper" = 99.9999),
#'                                              "ediag20" = list("letter" = "",
#'                                                               "lower" = 0,
#'                                                               "upper" = 99.9999)),
#'               flag_other_varname = "test_var"
#'               )
#'
#' # Example 4: Search only across primary diagnosis and (all) additional diagnosis fields for a custom set of ICD codes
#' ## Call this variable "test_var2"
#' icd_morb_flag(data = morb,
#'               flag_category = "Other",
#'               diag_type = c("principal diagnosis", "additional diagnoses"),
#'               diag_type_custom_params = list("principal diagnosis" = list("letter" = "F",
#'                                                                           "lower" = 0,
#'                                                                           "upper" = 99.9999),
#'                                              "additional diagnoses" = list("letter" = "",
#'                                                                            "lower" = 0,
#'                                                                            "upper" = 99.9999)),
#'               flag_other_varname = "test_var2"
#'               )
#'
#' # Example 5: Search across (all) additional diagnosis fields and another random field, `dagger`
#' ## Call this variable "test_var3"
#' icd_morb_flag(data = morb,
#'               flag_category = "Other",
#'               diag_type = c("custom", "additional diagnoses"),
#'               diag_type_custom_vars = "dagger",
#'               diag_type_custom_params = list("dagger" = list("letter" = "F",
#'                                                              "lower" = 0,
#'                                                              "upper" = 99.9999)),
#'               flag_other_varname = "test_var3"
#'               )
#'
#' # Example 6: Searching across multiple ICD code types within a variable
#' ## Call this variable "test_var4" -- replicating MH_morb flag
#' icd_morb_flag(data = morb,
#'               flag_category = "Other",
#'               diag_type = c("additional diagnoses", "additional diagnoses", "external cause of injury"),
#'               flag_other_varname = "test_var3",
#'               diag_type_custom_params =
#'               list("principal diagnosis" = list(list("letter" = "F",
#'                                                      "lower" = 0,
#'                                                      "upper" = 99.9999),
#'                                                 list("letter" = "",
#'                                                      "lower" = 290,
#'                                                      "upper" = 319.9999)),
#                     "additional diagnoses" = list(list("letter" = "F",
#                                                        "lower" = 0,
#                                                        "upper" = 99.9999),
#                                                   list("letter" = "",
#                                                        "lower" = 290,
#                                                        "upper" = 319.9999)),
#                     "external cause of injury" = list(list("letter" = "E",
#                                                            "lower" = 950,
#                                                            "upper" = 959.9999),
#                                                       list("letter" = "X",
#                                                            "lower" = 60,
#                                                            "upper" = 84.9999))))
#' @export

icd_morb_flag <- function(data,
                          dobmap = NULL,
                          flag_category,
                          flag_other_varname,
                          diag_type,
                          diag_type_custom_vars = NULL,
                          diag_type_custom_params,
                          under_age = FALSE,
                          age = 18,
                          person_summary = FALSE,
                          id_var = "rootnum",
                          morb_date_var = "subadm",
                          dobmap_dob_var = "dob",
                          dobmap_other_vars = NULL){

  data("icd_dat", package = "WAACHShelp")

  if (!(flag_category %in% c(unique(icd_dat$var), "Other"))) {
    stop(sprintf("Error: '%s' is not a valid input. Please choose from %s. If variable not contained in this list, please specify `flag_category == \"Other\"` and use the `flag_other_varname` and `flag_other_vals` arguments.",
                 flag_category, paste(c(unique(icd_dat$var)), collapse = ", ")))
  }

  # 1) Calculate age at record
  ## 1.1) For morbidity data sets -> relative to `subadm`
  ## Only applicable if under_age == TRUE
  if (under_age == TRUE){
    age_test <- age - 1
    data <- data %>%
      left_join(dobmap %>% select(!!rlang::sym(id_var), !!rlang::sym(dobmap_dob_var), !!!rlang::syms(dobmap_other_vars)),
                by = dobmap_joining_id) %>%
      mutate(age_adm = lubridate::time_length(lubridate::interval(!!rlang::sym(dobmap_dob_var), !!rlang::sym(morb_date_var)), unit = "years"),
             adm_under_age = case_when(floor(age_adm) <= age_test ~ "Yes",
                                       floor(age_adm) > age_test  ~ "No")) # Calculate ages
  }


  # 2) Extract admissible ICD codes for the selected `flag_category`
  ## Uses the `icd_extraction` function
  icds <- icd_extraction(data = data,
                         flag_category = flag_category,
                         diag_type = diag_type,
                         diag_type_custom_vars = diag_type_custom_vars,
                         diag_type_custom_params = diag_type_custom_params)


  # 3) Create flagging variables
  ## Uses `icd_flagging` function
  icd_flags <- icd_flagging(data = data,
                            flag_category = flag_category,
                            icd_list = icds,
                            flag_other_varname = flag_other_varname#,
                            #diag_type = diag_type#,
                            #diag_type_custom_vars = diag_type_custom_vars,
                            #diag_type_custom_params = diag_type_custom_params
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
        data <- person_level(data = data,
                             flag_category = flag_category,
                             joining_var = id_var)

      } else if (under_age == TRUE) {
        data <- person_level(data = data,
                             flag_category = paste0(flag_category, "_under", age),
                             joining_var = id_var
                             )

      }
    } else if ("Other" %in% flag_category){
      if (under_age == FALSE){
        data <- person_level(data = data,
                             flag_category = flag_other_varname,
                             joining_var = id_var)

      } else if (under_age == TRUE){
        data <- person_level(data = data,
                             flag_category = paste0(flag_other_varname, "_under", age),
                             joining_var = id_var)

      }
    }
  }

  return(data)
}
