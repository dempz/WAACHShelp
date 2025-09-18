library(tidyverse)

set.seed(123)

# Create vector of unique rootnums (alphanumeric)
make_rootnum <- function(n) {
  replicate(n, paste0(sample(c(LETTERS, 0:9), 6, replace = TRUE), collapse = ""))
}

n_children <- 10
rootnums <- make_rootnum(n_children)

# dobmap is rootnum & dob
dobmap <- tibble(
  rootnum = rootnums,
  dob = as.Date("2010-01-01") + sample(0:3650, n_children, replace = TRUE) # random dob within 10 years
)

carer_types <- c("carer1id", "carer2id", "NEWBMID")

# For each child, randomly assign 1 to 3 carers
carers_per_child <- sample(1:3, n_children, replace = TRUE)

# Create carer_map rows by repeating rootnum as per carers_per_child
carer_map <- tibble(
  rootnum = rep(rootnums, times = carers_per_child)
) %>%
  mutate(carer_type = sample(carer_types, n(), replace = TRUE)) %>%
  distinct(rootnum, carer_type) %>%
  # Use unique random alphanumeric strings for carer_rootnum (no prefix)
  mutate(carer_rootnum = replicate(n(), paste0(sample(c(LETTERS, 0:9), 8, replace = TRUE), collapse = "")))

# data: multiple aducust records per carer_rootnum with start/end dates
# Initialize empty list to store records
aducust_list <- vector("list", length = nrow(carer_map))

for (i in seq_len(nrow(carer_map))) {
  n_records <- sample(0:20, 1)

  if (n_records == 0) {
    aducust_list[[i]] <- NULL
  } else {
    rec_dates <- as.Date("2020-01-01") + sample(0:1000, n_records, replace = TRUE)
    dis_dates <- rec_dates + sample(1:30, n_records, replace = TRUE)

    aducust_list[[i]] <- tibble(
      rootnum = carer_map$carer_rootnum[i],  # carer_rootnum as requested
      ReceptionDate = rec_dates,
      DischargeDate = dis_dates
    )
  }
  rm(i, n_records, rec_dates, dis_dates)
}

# Combine all rows into one dataframe
aducust <- bind_rows(aducust_list) %>%
  rename(carer_rootnum = rootnum)

rm(aducust_list, carer_types, carers_per_child, n_children, rootnums, make_rootnum)
