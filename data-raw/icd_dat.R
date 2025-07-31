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

### 1.2.1) Poisoning
Poison_morb_diag <-
  list(list(letter = "X", lower = 60.0,   upper = 64.9  ),
       list(letter = "E", lower = 950.0,  upper = 950.9 ),
       list(letter = "T", lower = 40.0,   upper = 40.9  ),
       list(letter =  "", lower = 965.00, upper = 965.02),
       list(letter =  "", lower = 965.09, upper = 965.09),
       list(letter =  "", lower = 969.6,  upper = 969.6 ),
       list(letter =  "", lower = 970.81, upper = 970.81),
       list(letter = "T", lower = 43.6,   upper = 43.6  ),
       list(letter =  "", lower = 969.7,  upper = 969.7 ),
       list(letter = "T", lower = 42.3,   upper = 42.3  ),
       list(letter =  "", lower = 967.0,  upper = 967.0 ),
       list(letter = "T", lower = 42.4,   upper = 42.4  ),
       list(letter =  "", lower = 969.4,  upper = 969.4 ),
       list(letter = "T", lower = 41.2,   upper = 41.2  ),
       list(letter =  "", lower = 968.4,  upper = 968.4 ),
       list(letter = "T", lower = 52.0,   upper = 52.0  ),
       list(letter =  "", lower = 981,    upper = 981   ),
       list(letter = "T", lower = 52.1,   upper = 52.2  ),
       list(letter =  "", lower = 982.0,  upper = 982.0 ),
       list(letter = "T", lower = 59.0,   upper = 59.0  ),
       list(letter =  "", lower = 987.2,  upper = 987.2 )) %>%
  dplyr::bind_rows() %>%
  as.data.frame() %>%
  dplyr::mutate(num = dplyr::row_number(),
                var = "Poison_morb",
                broad_type = "diagnosis",
                .before = 1) %>%
  {. ->> tmp} %>%
  dplyr::bind_rows(tmp %>% dplyr::mutate(broad_type = "ediag")) %>%
  dplyr::bind_rows(tmp %>% dplyr::mutate(broad_type = "ecode")) %>%
  dplyr::bind_rows(tmp %>% dplyr::mutate(broad_type = "dagger"))
### Must update data-raw/colname_classify_list.R to include "dagger"

### 1.2.2) Any poisoning or substance
Sub_poison_morb_diag <- Poison_morb_diag %>%
  dplyr::mutate(var = "Sub_poison_morb") %>%
  dplyr::bind_rows(Sub_morb_diag %>% dplyr::mutate(var = "Sub_poison_morb")) %>%
  dplyr::bind_rows(Sub_morb_ediag %>% dplyr::mutate(var = "Sub_poison_morb")) %>%
  dplyr::group_by(var, broad_type) %>%
  dplyr::arrange(broad_type, num) %>%
  dplyr::mutate(num = dplyr::row_number()) %>%
  dplyr::ungroup() %>%
  as.data.frame()


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

                            Poison_morb_diag, # New poisoning only flag

                            Sub_poison_morb_diag, # New poisoning or substance flag

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

# Referencing the `colname_classify_broad` calculated in colname_classify_list.R
icd_dat <- icd_dat %>%
  dplyr::mutate(classification = find_key(broad_type, colname_classify_broad),
         .after = broad_type)


# Save our data set
usethis::use_data(icd_dat, overwrite = TRUE)


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
   SH_morb,
   Poison_morb_diag, tmp)


