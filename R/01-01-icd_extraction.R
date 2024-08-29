#' Helper Function #2
#'
#' This is an internal helper function.
#'
#' @keywords internal

icd_extraction <- function(data,
                           flag_category,
                           flag_other_varname,
                           flag_other_vals){

  # 1) Extract variable categories
  ## 1.1) Morbidity data
  morb_diag_ediag <- unique(unlist(data %>% select(diagnosis, ediag1:ediag20),
                                   use.names = F))
  morb_ecode      <- unique(unlist(data %>% select(ecode1:ecode4),
                                   use.names = F))
  #print(morb_ecode)


  # 2) Create flag sets (derived from flag_category)
  admissible_icd <- list()

  if (!"Other" %in% flag_category){

    for (i in flag_category){
      icd_dat_i <- icd_dat %>% filter(var == i)

      for (j in unique(icd_dat_i$type)){
        icd_dat_ij <- icd_dat_i %>% filter(type == j)
        codes_ij <- c()

        for (k in icd_dat_ij$num){
          icd_dat_ijk <- icd_dat_ij %>% filter(num == k)
          letter <- icd_dat_ijk$letter
          lower  <- icd_dat_ijk$lower
          upper  <- icd_dat_ijk$upper

          if (j == "diag_ediag"){
            codes_ijk <- val_filt(morb_diag_ediag,
                                  letter = letter,
                                  lower  = lower,
                                  upper  = upper)

          } else if (j == "ecode"){
            codes_ijk <- val_filt(morb_ecode,
                                  letter = letter,
                                  lower  = lower,
                                  upper  = upper)
          }

          codes_ij <- c(codes_ij, codes_ijk)
          codes_ij <- unique(codes_ij)
          admissible_icd[[i]][[j]] <- codes_ij

        }
      }
    }}

  else if ("Other" %in% flag_category) {
    admissible_icd[[flag_other_varname]] <- flag_other_vals
  }

  return(admissible_icd)
}
