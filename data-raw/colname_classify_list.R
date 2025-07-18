actual_colnames <- c("diagnosis", paste0("ediag", 1:20), paste0("ecode", 1:4))

colname_classify_broad <- list("principal diagnosis" = "diagnosis",
                               "additional diagnoses" = "ediag",
                               "external cause of injury" = "ecode")

colname_classify_specific <- list("principal diagnosis" = actual_colnames[str_detect(actual_colnames, "diagnosis")],
                                  "additional diagnoses" = actual_colnames[str_detect(actual_colnames, "ediag")],
                                  "external cause of injury" = actual_colnames[str_detect(actual_colnames, "ecode")])


usethis::use_data(colname_classify_specific,
                  colname_classify_broad,
                  internal = T,
                  overwrite = T)
