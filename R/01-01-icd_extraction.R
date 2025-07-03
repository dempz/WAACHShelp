#' Helper Function #2
#'
#' This is an internal helper function.
#'
#' @keywords internal

icd_extraction <- function(data,
                           flag_category,
                           diag_type,
                           diag_type_custom_vars = NULL,
                           diag_type_custom_params){
  # Error messages!
  if (flag_category == "Other") {
    # Ensure that diag_type and diag_type_custom_vars are properly defined
    reserved_terms <- c("principal diagnosis", "additional diagnoses", "external cause of injury")
    invalid_vars <- intersect(diag_type_custom_vars, reserved_terms)
    if (length(invalid_vars) > 0) {
      stop(paste("Error: The following term(s) should be specified in `diag_type` and not in `diag_type_custom_vars`:",
                 paste(invalid_vars, collapse = ", ")))
    }

    # Make sure the diagnosis type is properly captured
    if (!all(diag_type %in% c("principal diagnosis", "additional diagnoses", "external cause of injury", "custom"))) {
      stop("Error: 'diag_type' must be one of 'principal diagnosis', 'additional diagnoses', 'external cause of injury', or 'custom'.")
    }

    # If `diag_type`=="custom", make sure that variables to search across are specified
    if ("custom" %in% diag_type & is.null(diag_type_custom_vars)) {
      stop("Error: If specifying custom diagnosis type (`diag_type` = 'custom'), then variables to search across (`diag_type_custom_vars`) must be specified.")
    }

    # If `diag_type`=="custom", make sure the variables to search across exist in the dataframe
    if ("custom" %in% diag_type && !is.null(diag_type_custom_vars) && all(diag_type_custom_vars %in% colnames(data)) != TRUE) {
      stop(paste0("Error: ",
                  paste0("'", diag_type_custom_vars, "'", collapse = ", "),
                  " cannot both be found in the column names of ",
                  paste0("'", deparse(substitute(data)), "'")
      )
      )
    }

    # Message to say what variables are being flagged
    for (type in unique(diag_type)) {
      if (type %in% c("principal diagnosis", "additional diagnoses", "external cause of injury")) {
        message(paste0("Flagging across the following ", type, " variable(s):\n",
                       paste0(colname_classify_specific[[type]],
                              collapse = ", "),
                       "\n\n")
        )
      } else if (type %in% "custom") {
        message(paste0("Flagging across the following ", type, " variable(s):\n",
                       paste0(diag_type_custom_vars,
                              collapse = ", "),
                       "\n\n")
        )
      }
    }

    # Check proper specification of `diag_type_custom_params`
    combined_vars <- c(diag_type[diag_type != "custom"], diag_type_custom_vars)
    missing_vars <- setdiff(combined_vars, names(diag_type_custom_params))
    if (length(missing_vars) > 0) {
      stop(paste("Error: The following variable(s) require limits specified in `diag_type_custom_params`:",
                 paste(missing_vars, collapse = ", ")))
    }

    # Adjust error checking for diag_type_custom_params
    for (var_name in names(diag_type_custom_params)) {
      param_value <- diag_type_custom_params[[var_name]]

      if (is.list(param_value) && all(c("letter", "lower", "upper") %in% names(param_value))) {
        # Single parameter set; wrap it in a list
        diag_type_custom_params[[var_name]] <- list(param_value)
      } else if (is.list(param_value) && all(sapply(param_value, function(x) {
        is.list(x) && all(c("letter", "lower", "upper") %in% names(x))
      }))) {
        # Already a list of parameter sets; do nothing
      } else {
        stop(paste("Error: The parameters for variable", var_name, "are not properly specified. Each parameter set must be a list with 'letter', 'lower', and 'upper'."))
      }
    }
  }

  # 1) Extract variable categories
  # 1.1) If `flag_category` != "Other"
  if (flag_category != "Other"){
    diag_ediag_icd_categories <- unique(unlist(data %>% dplyr::select(diagnosis, ediag1:ediag20),
                                               use.names = F))
    ecode_icd_categories      <- unique(unlist(data %>% dplyr::select(ecode1:ecode4),
                                               use.names = F))
  }

  # 1.2) If `flag_category` == "Other"
  if (flag_category == "Other"){
    custom_icd_categories <- list()
    for (i in diag_type){
      if (i %in% c("principal diagnosis", "additional diagnoses", "external cause of injury")){ # The pre-defined cases
        vars <- colname_classify_specific[[i]] # Extract all the salient variables
        observed_icds <- unique(unlist(data %>% dplyr::select(!!vars), use.names = F)) # Extract all the ICD codes observed here

      } else if (i %in% "custom"){
        vars <- diag_type_custom_vars
        observed_icds <- unique(unlist(data %>% dplyr::select(!!vars), use.names = F))
      }

      custom_icd_categories[[i]] <- list(variables = vars,
                                         icd_codes = observed_icds)
    }
  }

  # 2) Create flag sets (derived from flag_category)
  admissible_icd <- list()
  if (flag_category != "Other"){ # If one of "MH_morb", "Sub_morb" etc.
    icd_dat_flag <- icd_dat %>% dplyr::filter(var == flag_category)

    for (i in unique(icd_dat_flag$classification)){
      icd_dat_flag_i <- icd_dat_flag %>% dplyr::filter(classification == i)
      codes_i <- c()

      for (j in icd_dat_flag_i$num){
        icd_dat_flag_ij <- icd_dat_flag_i %>% dplyr::filter(num == j)
        letter <- icd_dat_flag_ij$letter
        lower  <- icd_dat_flag_ij$lower
        upper  <- icd_dat_flag_ij$upper

        message(paste0("Search ", i, ": letter=", letter, ", lower=", lower, " upper=", upper))

        if (i %in% c("principal diagnosis", "additional diagnoses")){ # diagnosis, ediag
          codes_ij <- val_filt(diag_ediag_icd_categories,
                               letter = letter,
                               lower  = lower,
                               upper  = upper)
        } else if (i == "external cause of injury"){ # ecode
          codes_ij <- val_filt(ecode_icd_categories,
                               letter = letter,
                               lower  = lower,
                               upper  = upper)
        }
        codes_ij <- sort(codes_ij)
        #print(codes_ij)
        codes_ij <- sort(codes_ij)

        codes_i <- c(codes_i, codes_ij)
        codes_i <- unique(codes_i)
        admissible_icd[[i]] <- codes_i
      }
    }
  }
  else if (flag_category == "Other") {
    for (i in names(custom_icd_categories)){
      custom_icd_categories_i <- custom_icd_categories[[i]] # "custom" vs other (pre-established)
      all_icd_categories <- custom_icd_categories_i[["icd_codes"]]

      if (i == "custom"){
        custom_vars <- custom_icd_categories_i[["variables"]]
        for (j in custom_vars){
          param_list <- diag_type_custom_params[[j]]
          admissible_icd[[j]] <- c()  # Initialize as empty vector

          for (k in param_list){
            letter <- k[["letter"]]
            lower <- k[["lower"]]
            upper <- k[["upper"]]

            message(paste0("Search ", j, ": letter=", letter, ", lower=", lower, " upper=", upper))

            filtered_icd_categories <- val_filt(all_icd_categories,
                                                letter = letter,
                                                lower  = lower,
                                                upper  = upper)
            admissible_icd[[j]] <- unique(c(admissible_icd[[j]], filtered_icd_categories))
          }
          admissible_icd[[j]] <- sort(admissible_icd[[j]])
        }
      }
      else {
        param_list <- diag_type_custom_params[[i]]
        admissible_icd[[i]] <- c()  # Initialize as empty vector

        for (k in param_list){
          letter <- k[["letter"]]
          lower <- k[["lower"]]
          upper <- k[["upper"]]

          message(paste0("Search ", i, ": letter=", letter, ", lower=", lower, ", upper=", upper))

          filtered_icd_categories <- val_filt(all_icd_categories,
                                              letter = letter,
                                              lower  = lower,
                                              upper  = upper)
          admissible_icd[[i]] <- unique(c(admissible_icd[[i]], filtered_icd_categories))
        }
        admissible_icd[[i]] <- sort(admissible_icd[[i]])
      }
    }
  }
  return(admissible_icd)
}
