#' ICD Classification Data set
#'
#' Data set specifying the ICD (9 & 10) codes for different events in the morbidity data set.
#'
#' @format A data frame where rows correspond to an event and columns correspond to the variable name, morbidity search parameters (diagnosis/ediag, ecode) and ICD code breakdown
#' \describe{
#'   \item{num}{Counter variable representing the number of rows associated with any given var}
#'   \item{var}{Variable name}
#'   \item{broad_type}{Type of diagnosis field this ICD code corresponds to (diagnosis & ediag = "diag_ediag", ecode = "ecode")}
#'   \item{letter}{Letter of ICD code (purely numeric is empty string "")}
#'   \item{lower}{Lower bound of numeric element of ICD code}
#'   \item{upper}{Upper bound of numeric element of ICD code}
#'   ...
#' }
#' @source Generated internally by package
"icd_dat"

# 1) Morbidity ICD Code Categories

## 1.1) Any mental health-related morbiditiy
MH_morb_diag <- data.frame(num    = 1:2,
                           var    = c(rep("MH_morb", 2)),
                           broad_type   = c(rep("diagnosis", 2)),
                           letter = c("F", ""),
                           lower  = c(0,       290),
                           upper  = c(99.9999, 319.9999))
MH_morb_ediag <- data.frame(num    = 1:2,
                            var    = c(rep("MH_morb", 2)),
                            broad_type   = c(rep("ediag", 2)),
                            letter = c("F", ""),
                            lower  = c(0,       290),
                            upper  = c(99.9999, 319.9999))

MH_morb_sh <- data.frame(num    = 1:2,
                         var    = c(rep("MH_morb", 2)),
                         broad_type   = c(rep("ecode", 2)),
                         letter = c("E", "X"),
                         lower  = c(950,      60),
                         upper  = c(959.9999, 84.9999))

## 1.2) Any substance-related morbidity

Sub_morb_diag <- data.frame(num    = 1:5,
                            var    = c(rep("Sub_morb", 5)),
                            broad_type   = c(rep("diagnosis", 5)),
                            letter = c(rep("", 3), rep("F", 2)),
                            lower  = c(291,      292, 303, 10, 55),
                            upper  = c(291.9999, 292.9999, 305.9999, 19.9999, 55.9999))
Sub_morb_ediag <- data.frame(num    = 1:5,
                             var    = c(rep("Sub_morb", 5)),
                             broad_type   = c(rep("ediag", 5)),
                             letter = c(rep("", 3), rep("F", 2)),
                             lower  = c(291,      292, 303, 10, 55),
                             upper  = c(291.9999, 292.9999, 305.9999, 19.9999, 55.9999))

## 1.5) Substance-specific

### 1.5.1) Alcohol
Alc_morb_diag <- data.frame(num    = 1:4,
                       var    = c(rep("Alc_morb", 4)),
                       broad_type   = c(rep("diagnosis", 4)),
                       letter = c(rep("", 3), "F"),
                       lower  = c(291,      303, 305, 10),
                       upper  = c(291.9999, 303.9999, 305, 10.9999))
Alc_morb_ediag <- data.frame(num    = 1:4,
                            var    = c(rep("Alc_morb", 4)),
                            broad_type   = c(rep("ediag", 4)),
                            letter = c(rep("", 3), "F"),
                            lower  = c(291,      303, 305, 10),
                            upper  = c(291.9999, 303.9999, 305, 10.9999))

### 1.5.2) Tobacco
Tob_morb_diag <- data.frame(num    = 1:2,
                       var    = c(rep("Tob_morb", 2)),
                       broad_type   = c(rep("diagnosis", 2)),
                       letter = c("", "F"),
                       lower  = c(305.1,     17),
                       upper  = c(305.19999, 17.9999))
Tob_morb_ediag <- data.frame(num    = 1:2,
                             var    = c(rep("Tob_morb", 2)),
                             broad_type   = c(rep("ediag", 2)),
                             letter = c("", "F"),
                             lower  = c(305.1,     17),
                             upper  = c(305.19999, 17.9999))

### 1.5.3) Opioid
Opioid_morb_diag <- data.frame(num    = 1:4,
                          var    = c(rep("Opioid_morb", 4)),
                          broad_type   = c(rep("diagnosis", 4)),
                          letter = c(rep("", 3), "F"),
                          lower  = c(304, 304.7, 305.5, 11),
                          upper  = c(304, 304.7, 305.5, 11.9999))
Opioid_morb_ediag <- data.frame(num    = 1:4,
                          var    = c(rep("Opioid_morb", 4)),
                          broad_type   = c(rep("ediag", 4)),
                          letter = c(rep("", 3), "F"),
                          lower  = c(304, 304.7, 305.5, 11),
                          upper  = c(304, 304.7, 305.5, 11.9999))

### 1.5.4) Cannabinoids
Cann_morb_diag <- data.frame(num    = 1:3,
                        var    = c(rep("Cann_morb", 3)),
                        broad_type   = c(rep("diagnosis", 3)),
                        letter = c(rep("", 2), "F"),
                        lower  = c(304.3, 305.2, 12),
                        upper  = c(304.3, 305.2, 12.9999))
Cann_morb_ediag <- data.frame(num    = 1:3,
                        var    = c(rep("Cann_morb", 3)),
                        broad_type   = c(rep("ediag", 3)),
                        letter = c(rep("", 2), "F"),
                        lower  = c(304.3, 305.2, 12),
                        upper  = c(304.3, 305.2, 12.9999))


### 1.5.5) Sedatives
Sed_morb_diag <- data.frame(num    = 1:3,
                       var    = c(rep("Sed_morb", 3)),
                       broad_type   = c(rep("diagnosis", 3)),
                       letter = c(rep("", 2), "F"),
                       lower  = c(304.1, 305.4, 13),
                       upper  = c(304.1, 305.4, 13.9999))
Sed_morb_ediag <- data.frame(num    = 1:3,
                       var    = c(rep("Sed_morb", 3)),
                       broad_type   = c(rep("ediag", 3)),
                       letter = c(rep("", 2), "F"),
                       lower  = c(304.1, 305.4, 13),
                       upper  = c(304.1, 305.4, 13.9999))

### 1.5.6) Cocaine
Coc_morb_diag <- data.frame(num    = 1:3,
                       var    = c(rep("Coc_morb", 3)),
                       broad_type   = c(rep("diagnosis", 3)),
                       letter = c(rep("", 2), "F"),
                       lower  = c(304.2, 305.6, 14),
                       upper  = c(304.2, 305.6, 14.9999))
Coc_morb_ediag <- data.frame(num    = 1:3,
                            var    = c(rep("Coc_morb", 3)),
                            broad_type   = c(rep("ediag", 3)),
                            letter = c(rep("", 2), "F"),
                            lower  = c(304.2, 305.6, 14),
                            upper  = c(304.2, 305.6, 14.9999))


### 1.5.7) Stimulants
Stim_morb_diag <- data.frame(num    = 1:3,
                        var    = c(rep("Stim_morb", 3)),
                        broad_type   = c(rep("diagnosis", 3)),
                        letter = c(rep("", 2), "F"),
                        lower  = c(304.4, 305.7, 15),
                        upper  = c(304.4, 305.7, 15.9999))
Stim_morb_ediag <- data.frame(num    = 1:3,
                             var    = c(rep("Stim_morb", 3)),
                             broad_type   = c(rep("ediag", 3)),
                             letter = c(rep("", 2), "F"),
                             lower  = c(304.4, 305.7, 15),
                             upper  = c(304.4, 305.7, 15.9999))


### 1.5.8) Hallucinogen
Hall_morb_diag <- data.frame(num    = 1:3,
                        var    = c(rep("Hall_morb", 3)),
                        broad_type   = c(rep("diagnosis", 3)),
                        letter = c(rep("", 2), "F"),
                        lower  = c(304.5, 305.3, 16),
                        upper  = c(304.5, 305.3, 16.9999))
Hall_morb_ediag <- data.frame(num    = 1:3,
                             var    = c(rep("Hall_morb", 3)),
                             broad_type   = c(rep("ediag", 3)),
                             letter = c(rep("", 2), "F"),
                             lower  = c(304.5, 305.3, 16),
                             upper  = c(304.5, 305.3, 16.9999))

### 1.5.9) Solvents
Solv_morb_diag <- data.frame(num    = 1:2,
                        var    = c(rep("Solv_morb", 2)),
                        broad_type   = c(rep("diagnosis", 2)),
                        letter = c("", "F"),
                        lower  = c(304.6, 18),
                        upper  = c(304.6, 18.9999))
Solv_morb_ediag <- data.frame(num    = 1:2,
                             var    = c(rep("Solv_morb", 2)),
                             broad_type   = c(rep("ediag", 2)),
                             letter = c("", "F"),
                             lower  = c(304.6, 18),
                             upper  = c(304.6, 18.9999))

### 1.5.10) Multi-drug
Multdrug_morb_diag <- data.frame(num    = 1:5,
                            var    = c(rep("Multdrug_morb", 5)),
                            broad_type   = c(rep("diagnosis", 5)),
                            letter = c(rep("", 4), "F"),
                            lower  = c(292,      304.8, 304.9, 305.9, 19),
                            upper  = c(292.9999, 304.8, 304.9, 305.9, 19.9999))
Multdrug_morb_ediag <- data.frame(num    = 1:5,
                                 var    = c(rep("Multdrug_morb", 5)),
                                 broad_type   = c(rep("ediag", 5)),
                                 letter = c(rep("", 4), "F"),
                                 lower  = c(292,      304.8, 304.9, 305.9, 19),
                                 upper  = c(292.9999, 304.8, 304.9, 305.9, 19.9999))


### 1.5.11) **Other drug

#### When *any substance-related morbidity* is "Yes" and all 1.5.3 - 1.5.10 (note exclusion of alcohol and tobacco) are "No"

## 1.6) Self harm-related morbidity

SH_morb <- data.frame(num    = 1:2,
                      var    = c(rep("SH_morb", 2)),
                      broad_type   = c(rep("ecode", 2)),
                      letter = c("E", "X"),
                      lower  = c(950, 60),
                      upper  = c(959.9999, 84.9999))

icd_dat <- dplyr::bind_rows(MH_morb_diag,
                            MH_morb_ediag,

                            MH_morb_sh,

                            Sub_morb_diag,
                            Sub_morb_ediag,

                            Alc_morb_diag,
                            Alc_morb_ediag,

                            Tob_morb_diag,
                            Tob_morb_ediag,

                            Opioid_morb_diag,
                            Opioid_morb_ediag,

                            Cann_morb_diag,
                            Cann_morb_ediag,

                            Sed_morb_diag,
                            Sed_morb_ediag,

                            Coc_morb_diag,
                            Coc_morb_ediag,

                            Stim_morb_diag,
                            Stim_morb_ediag,

                            Hall_morb_diag,
                            Hall_morb_ediag,

                            Solv_morb_diag,
                            Solv_morb_ediag,

                            Multdrug_morb_diag,
                            Multdrug_morb_ediag,

                            SH_morb)

# Now we can add some classifications to our file
actual_colnames <- c("diagnosis", paste0("ediag", 1:20), paste0("ecode", 1:4))

colname_classify_broad <- list("principal diagnosis" = "diagnosis",
                               "additional diagnoses" = "ediag",
                               "external cause of injury" = "ecode")

colname_classify_specific <- list("principal diagnosis" = actual_colnames[str_detect(actual_colnames, "diagnosis")],
                                  "additional diagnoses" = actual_colnames[str_detect(actual_colnames, "ediag")],
                                  "external cause of injury" = actual_colnames[str_detect(actual_colnames, "ecode")])

# Make an extra useful list



icd_dat <- icd_dat %>%
  mutate(classification = find_key(broad_type, colname_classify_broad),
         .after = broad_type)



# Save our data set
save(icd_dat, file = "data/icd_dat.RData")
save(colname_classify_specific, file = "data/colname_classify_specific.RData")
save(colname_classify_broad, file = "data/colname_classify_broad.RData")


# Clean up some stuff
rm(MH_morb_diag,
   MH_morb_ediag,
   MH_morb_sh,
   Sub_morb_diag,
   Sub_morb_ediag,
   Alc_morb_diag,
   Alc_morb_ediag,
   Tob_morb_diag,
   Tob_morb_ediag,
   Opioid_morb_diag,
   Opioid_morb_ediag,
   Cann_morb_diag,
   Cann_morb_ediag,
   Sed_morb_diag,
   Sed_morb_ediag,
   Coc_morb_diag,
   Coc_morb_ediag,
   Stim_morb_diag,
   Stim_morb_ediag,
   Hall_morb_diag,
   Hall_morb_ediag,
   Solv_morb_diag,
   Solv_morb_ediag,
   Multdrug_morb_diag,
   Multdrug_morb_ediag,
   SH_morb)


