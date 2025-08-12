set.seed(123)

# --- dob_min: 100 unique individuals ---
dob_min <- data.frame(
  rootnum = 1:100,
  dob = as.Date("1950-01-01") + sample(0:25000, 100, replace = TRUE)
)

# Helper function to create a random alphanumeric code
rand_code <- function(n) {
  letters_part <- sample(LETTERS, n, replace = TRUE)
  numbers_part <- sprintf("%.1f", sample(seq(0, 500, by = 0.1), n, replace = TRUE))
  paste0(letters_part, numbers_part)
}

# --- morb_min: variable number of rows per individual ---
morb_list <- lapply(dob_min$rootnum, function(id) {
  n_rec <- sample(0:5, 1)  # 0 to 5 records
  if (n_rec == 0) return(NULL)

  data.frame(
    rootnum = id,
    diagnosis = rand_code(n_rec),
    replicate(20, rand_code(n_rec), simplify = FALSE) |> setNames(paste0("ediag", 1:20)),
    replicate(4, rand_code(n_rec), simplify = FALSE)  |> setNames(paste0("ecode", 1:4)),
    dagger = rand_code(n_rec),
    test_var = rand_code(n_rec),
    subadm = as.Date("2015-01-01") + sample(0:365*10, n_rec, replace = TRUE)
  )
})

morb_min <- do.call(rbind, morb_list) %>% as_tibble()

rm(morb_list, n_records, rootnum_expanded, rand_code, random_icd)
