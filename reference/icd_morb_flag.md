# ICD flagging function

This function serves to add flags to an input data set (morbidity at
this stage) pursuant to ICD codes. Flags can be added for general
categories based on pre-established ICD codes (e.g., any mental health
contact, any substance-related contact, any alcohol/tobacco-related
contact etc.) or add a custom set of ICD codes. The file with these
pre-established ICD codes are saved as an .RData file and are trivial to
change.

## Usage

``` r
icd_morb_flag(
  data,
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
  dobmap_other_vars = NULL
)
```

## Arguments

- data:

  Input dataset (morbidity).

- dobmap:

  DOBmap file corresponding to input dataset.

- flag_category:

  Type of flag to generate. Takes values from reference file (e.g.,
  MH_morb, Sub_morb, etc.) or "Other" for custom ICD specification and
  flagging.

- flag_other_varname:

  Flag variable name (specified only When `flag_category == "Other"`).
  Input as character string.

- diag_type:

  Diagnosis type. Select from "principal diagnosis", (all) "additional
  diagnoses", "external cause of injury", "custom".

- diag_type_custom_vars:

  Variables to search across when `diag_type == "custom"`.

- diag_type_custom_params:

  Search parameters to search across when `diag_type == "custom"`. Must
  be a list where the keys are the variable names and values are the
  inputs to
  [`WAACHShelp::val_filt`](https://dempz.github.io/WAACHShelp/reference/val_filt.md).
  Can also be a list of lists where multiple ICD can be searched across
  for a single variable. See examples for specification.

- under_age:

  Return additional variables corresponding to when participant was
  strictly under `age` y.o.. Uses DOBmap DOB and subadm morbidity
  admission date. Variables have suffix "\_under{age}".

- age:

  Numeric. Age (years) to consider for the `under_age` variable (default
  18).

- person_summary:

  Summarise results at a person-level.

- id_var:

  Joining (ID) variable consistent between `data` and `dobmap`. Default
  `rootnum`.

- morb_date_var:

  Hospital morbidity date variable in `data`. Default `"subadm"`.

- dobmap_dob_var:

  Date of birth (DOB) variable in `dobmap`. Default `"dob"`.

- dobmap_other_vars:

  Other variables to carry across from DOBmap file when joining to
  `data`. Default `NULL`. Can be a vector of strings.

## Value

Flagged dataframe.

## Details

For more details, see the
[vignette](https://dempz.github.io/WAACHShelp/articles/icd_morb_flag.html).

## Examples

``` r
if (FALSE) { # \dontrun{
# Example 1: Basic use
## Create any mental health or substance-related morbidity flag, "MH_morb"
## Searches "principal diagnosis", "additional diagnoses", "external cause of injury".
## Create additional flag for whether admission occurred when under 18 years of age
icd_morb_flag(
  data = morb,
  dobmap = dob,
  flag_category = "MH_morb",
  under_age = T,
  age = 18,
  dobmap_other_vars = c("xyz123", "abc456") # Also join `xyz123`, `abc456` from DOBmap
  )

# Example 2: Basic use
## Create any substance-related morbidity flag, "Sub_morb"
icd_morb_flag(data = morb,
              flag_category = "Sub_morb" # Create any MH contact flag
              )

# Example 3: Search  *principal diagnosis* and *first additional diagnosis*
# for a custom set of ICD codes
## Call this variable "test_var"
icd_morb_flag(data = morb,
              flag_category = "Other",
              diag_type = "custom",
              diag_type_custom_vars = c("diagnosis", "ediag20"),
              diag_type_custom_params = list("diagnosis" = list("letter" = "F",
                                                                "lower" = 0,
                                                                "upper" = 99.9999),
                                             "ediag20" = list("letter" = "",
                                                              "lower" = 0,
                                                              "upper" = 99.9999)),
              flag_other_varname = "test_var"
              )

# Example 4:
# Search only across primary diagnosis and
# (all) additional diagnosis fields for a custom set of ICD codes.
## Call this variable "test_var2"
icd_morb_flag(data = morb,
              flag_category = "Other",
              diag_type = c("principal diagnosis", "additional diagnoses"),
              diag_type_custom_params = list("principal diagnosis" = list("letter" = "F",
                                                                          "lower" = 0,
                                                                          "upper" = 99.9999),
                                             "additional diagnoses" = list("letter" = "",
                                                                           "lower" = 0,
                                                                           "upper" = 99.9999)),
              flag_other_varname = "test_var2"
              )

# Example 5: Search across (all) additional diagnosis fields and another random field, `dagger`
## Call this variable "test_var3"
icd_morb_flag(data = morb,
              flag_category = "Other",
              diag_type = c("custom", "additional diagnoses"),
              diag_type_custom_vars = "dagger",
              diag_type_custom_params = list("dagger" = list("letter" = "F",
                                                             "lower" = 0,
                                                             "upper" = 99.9999)),
              flag_other_varname = "test_var3"
              )

# Example 6: Searching across multiple ICD code types within a variable
## Call this variable "test_var4" -- replicating MH_morb flag
icd_morb_flag(data = morb,
              flag_category = "Other",
              diag_type = c("additional diagnoses",
                            "additional diagnoses",
                            "external cause of injury"),
              flag_other_varname = "test_var3",
              diag_type_custom_params =
              list("principal diagnosis" = list(list("letter" = "F",
                                                     "lower" = 0,
                                                     "upper" = 99.9999),
                                                list("letter" = "",
                                                     "lower" = 290,
                                                     "upper" = 319.9999)),
                    "additional diagnoses" = list(list("letter" = "F",
                                                       "lower" = 0,
                                                       "upper" = 99.9999),
                                                  list("letter" = "",
                                                       "lower" = 290,
                                                       "upper" = 319.9999)),
                    "external cause of injury" = list(list("letter" = "E",
                                                           "lower" = 950,
                                                           "upper" = 959.9999),
                                                      list("letter" = "X",
                                                           "lower" = 60,
                                                           "upper" = 84.9999))))
} # }
```
