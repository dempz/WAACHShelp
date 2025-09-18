source(file = "data-raw/check_att_n_a_ref.R")
source(file = "data-raw/colname_classify_list.R")

usethis::use_data(colname_classify_specific,
                  colname_classify_broad,
                  a_ref,
                  internal = TRUE,
                  overwrite = TRUE)
