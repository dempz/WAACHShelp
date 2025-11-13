# Flagging aducust records using \`aducust_flag\`

## Forward

[`WAACHShelp::aducust_flag()`](https://dempz.github.io/WAACHShelp/reference/aducust_flag.md)
automates the flagging of this `aducust` data (custodial record(s) for a
set of individuals).

- Often, we would like to flag whether a record exists between two
  dates.
- Of particular interest is the case of carer `aducust` data, where we
  might want to flag whether a record exists when a child is between 0
  and 18, or otherwise.

This vignette steps through how data should be structured to use the
function, and general use. **The examples presented flag, at a child
level, whether any associated carer has an aducust record when the child
is between age *x* and *y***. The function can certainly be adapted to
suit other applications.

To do this, data sets will be simulated to mimic the required structure.

``` r
# Load the package
library(WAACHShelp)

# Set seed for reproducibility
set.seed(123)
```

## Simulate Data

- The function requires the following data sets as inputs:
  - `data` — aducust data set.
    - Will be at the carer level.
  - `dobmap` — dobmap file.
    - In this instance, at the child level.
    - In reality, only two columns are required: an ID variable, and a
      DOB for the unit of interest.
  - `carer_map`
    - A mapping file which dictates how carer(s) are related to
      children.
    - Can generally be formulated using a linkage/family connections
      file.

### 1) Formulate `dobmap`

- Variables
  - `rootnum` — child ID variable
  - `dob` — A randomly selected set of DOBs **of class Date**.
- Note
  - 100 children will be simulated

``` r
# Function to create unique random rootnums
make_rootnum <- function(n){
  replicate(n, paste0(sample(c(LETTERS, 0:9), 6, replace = TRUE), collapse = ""))
  }

# Formulate rootnums
n_children <- 100 
rootnums <- make_rootnum(n_children)

# dobmap: rootnum + dob
dobmap <- tibble(rootnum = rootnums,
                 dob = as.Date('2010-01-01') + sample(0:3650, n_children, replace = TRUE))
```

Now previewing the first few rows:

``` r
head(dobmap, n = 10) %>%
  waachs_table()
```

| rootnum | dob        |
|---------|------------|
| 4ONCNY  | 2017-01-26 |
| Z0E01I  | 2019-12-05 |
| 28HZGI  | 2014-09-29 |
| S9NQLO  | 2016-02-20 |
| 5GIJW0  | 2016-11-12 |
| G05Y72  | 2015-01-28 |
| EHLMR6  | 2017-03-08 |
| 0YUOZ4  | 2018-08-15 |
| P3FHVV  | 2012-09-24 |
| 4Q7DME  | 2014-08-09 |

### 2) Formulate `carer_map`

- Variables
  - `rootnum` — child ID variable.
  - `carer_type` — variable denoting “type” of carer.
    - Necessary if multiple carers per child.
  - `carer_rootnum` — carer ID variable.
    - Must be called something different to the child ID variable (i.e.,
      cannot be called `rootnum`).
- Note
  - Any individual can have any number of carers associated with them.

``` r
carer_types <- c("carer1id", "carer2id", "NEWBMID")

# For each child, randomly assign 1 to 3 carers
carers_per_child <- sample(1:3, n_children, replace = TRUE)

# Create carer_map rows by repeating rootnum as per carers_per_child
carer_map <- tibble(rootnum = rep(rootnums, times = carers_per_child)) %>%
  mutate(carer_type = sample(carer_types, n(), replace = TRUE)) %>%
  distinct(rootnum, carer_type) %>%
  # Use unique random alphanumeric strings for carer_rootnum (no prefix)
  mutate(carer_rootnum = replicate(n(), paste0(sample(c(LETTERS, 0:9), 8, replace = TRUE), collapse = "")))
```

Now previewing the first few rows:

``` r
head(carer_map, n = 10) %>%
  waachs_table()
```

| rootnum | carer_type | carer_rootnum |
|---------|------------|---------------|
| 4ONCNY  | NEWBMID    | 23ANG7JO      |
| 4ONCNY  | carer2id   | SRVRCRAO      |
| Z0E01I  | carer2id   | F6J7ZRE8      |
| 28HZGI  | NEWBMID    | F2IVT3N2      |
| 28HZGI  | carer1id   | KTQXYMLF      |
| S9NQLO  | carer1id   | C1KSK9VK      |
| 5GIJW0  | NEWBMID    | 0BF912DE      |
| 5GIJW0  | carer1id   | 4IS1OK2Q      |
| G05Y72  | carer2id   | YLSGKOIX      |
| G05Y72  | NEWBMID    | SK6IWQJH      |

### 3) Formulate `aducust`

- Variables
  - `carer_rootnum` — carer ID variable.
    - Carer ID variable name must be equivalent between `carer_map` and
      `aducust`.
  - `ReceptionDate` — aducust start date.
  - `DischargeDate` — aducust end date.
- Note
  - Any carer can have any number of aducust records (range 0-10).
  - Discharge date must be after reception date.

``` r
# data: multiple aducust records per carer_rootnum with start/end dates
# Initialize empty list to store records
aducust_list <- vector("list", length = nrow(carer_map))

for (i in seq_len(nrow(carer_map))) {
  n_records <- sample(0:10, 1)

  if (n_records == 0) {
    aducust_list[[i]] <- NULL
  } else {
    rec_dates <- as.Date('2020-01-01') + sample(0:1000, n_records, replace = TRUE)
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
```

Now previewing the first few rows:

``` r
head(aducust, n = 10) %>%
  waachs_table()
```

| carer_rootnum | ReceptionDate | DischargeDate |
|---------------|---------------|---------------|
| 23ANG7JO      | 2020-04-20    | 2020-05-01    |
| 23ANG7JO      | 2020-11-20    | 2020-12-19    |
| 23ANG7JO      | 2020-01-18    | 2020-01-21    |
| 23ANG7JO      | 2022-09-10    | 2022-09-21    |
| 23ANG7JO      | 2020-05-21    | 2020-06-08    |
| 23ANG7JO      | 2022-08-26    | 2022-09-25    |
| 23ANG7JO      | 2022-01-03    | 2022-01-23    |
| 23ANG7JO      | 2022-06-06    | 2022-06-12    |
| 23ANG7JO      | 2022-01-02    | 2022-01-03    |
| 23ANG7JO      | 2021-11-26    | 2021-12-02    |

## Examples

Now that we have our data, we can apply this to an example:

### Example 1: Default use

Applying the function using all defaults:

- Flags aducust records when child is between 0 and 18.
- Does not collapse records in any way.
- Resulting “many-to-many” join between `carer_map` and `aducust`.

``` r
eg1 <- aducust_flag(data = aducust,
                    dobmap = dobmap,
                    carer_map = carer_map)
#> Flagged aducust records when child is aged 0 to 18.
```

Previewing this:

| rootnum | carer_type | carer_rootnum | dob        | start_date | end_date   | aducust_num | ReceptionDate | DischargeDate | carer_aducust_0_18 |
|---------|------------|---------------|------------|------------|------------|-------------|---------------|---------------|--------------------|
| 4ONCNY  | NEWBMID    | 23ANG7JO      | 2017‑01‑26 | 2017‑01‑26 | 2035‑01‑26 | 1           | 2020‑04‑20    | 2020‑05‑01    | Yes                |
| 4ONCNY  | NEWBMID    | 23ANG7JO      | 2017‑01‑26 | 2017‑01‑26 | 2035‑01‑26 | 2           | 2020‑11‑20    | 2020‑12‑19    | Yes                |
| 4ONCNY  | NEWBMID    | 23ANG7JO      | 2017‑01‑26 | 2017‑01‑26 | 2035‑01‑26 | 3           | 2020‑01‑18    | 2020‑01‑21    | Yes                |
| 4ONCNY  | NEWBMID    | 23ANG7JO      | 2017‑01‑26 | 2017‑01‑26 | 2035‑01‑26 | 4           | 2022‑09‑10    | 2022‑09‑21    | Yes                |
| 4ONCNY  | NEWBMID    | 23ANG7JO      | 2017‑01‑26 | 2017‑01‑26 | 2035‑01‑26 | 5           | 2020‑05‑21    | 2020‑06‑08    | Yes                |
| 4ONCNY  | NEWBMID    | 23ANG7JO      | 2017‑01‑26 | 2017‑01‑26 | 2035‑01‑26 | 6           | 2022‑08‑26    | 2022‑09‑25    | Yes                |

### Example 2: Changing default age

#### Example 2.1: Different ages

- Flag record when child is between 10 and 14:

``` r
eg2.1 <- aducust_flag(data = aducust,
                      dobmap = dobmap,
                      carer_map = carer_map, 
                      child_start_age = 10, 
                      child_end_age = 14)
#> Flagged aducust records when child is aged 10 to 14.
```

Previewing this:

| rootnum | carer_type | carer_rootnum | dob        | start_date | end_date   | aducust_num | ReceptionDate | DischargeDate | carer_aducust_10_14 |
|---------|------------|---------------|------------|------------|------------|-------------|---------------|---------------|---------------------|
| 4ONCNY  | NEWBMID    | 23ANG7JO      | 2017‑01‑26 | 2027‑01‑26 | 2031‑01‑26 | 1           | 2020‑04‑20    | 2020‑05‑01    | No                  |
| 4ONCNY  | NEWBMID    | 23ANG7JO      | 2017‑01‑26 | 2027‑01‑26 | 2031‑01‑26 | 2           | 2020‑11‑20    | 2020‑12‑19    | No                  |
| 4ONCNY  | NEWBMID    | 23ANG7JO      | 2017‑01‑26 | 2027‑01‑26 | 2031‑01‑26 | 3           | 2020‑01‑18    | 2020‑01‑21    | No                  |
| 4ONCNY  | NEWBMID    | 23ANG7JO      | 2017‑01‑26 | 2027‑01‑26 | 2031‑01‑26 | 4           | 2022‑09‑10    | 2022‑09‑21    | No                  |
| 4ONCNY  | NEWBMID    | 23ANG7JO      | 2017‑01‑26 | 2027‑01‑26 | 2031‑01‑26 | 5           | 2020‑05‑21    | 2020‑06‑08    | No                  |
| 4ONCNY  | NEWBMID    | 23ANG7JO      | 2017‑01‑26 | 2027‑01‑26 | 2031‑01‑26 | 6           | 2022‑08‑26    | 2022‑09‑25    | No                  |

#### Example 2.2: “Negative” ages

The function does work when `child_start_age` and `child_end_age` is
negative.

- Flag aducust record that exists “1 year before the child was born”,
  and age 5.

``` r
eg2.2 <- aducust_flag(data = aducust,
                      dobmap = dobmap,
                      carer_map = carer_map, 
                      child_start_age = -1, 
                      child_end_age = 5)
#> Flagged aducust records when child is aged -1 to 5.
```

Previewing this:

| rootnum | carer_type | carer_rootnum | dob        | start_date | end_date   | aducust_num | ReceptionDate | DischargeDate | carer_aducust\_-1_5 |
|---------|------------|---------------|------------|------------|------------|-------------|---------------|---------------|---------------------|
| 4ONCNY  | NEWBMID    | 23ANG7JO      | 2017‑01‑26 | 2016‑01‑26 | 2022‑01‑26 | 1           | 2020‑04‑20    | 2020‑05‑01    | Yes                 |
| 4ONCNY  | NEWBMID    | 23ANG7JO      | 2017‑01‑26 | 2016‑01‑26 | 2022‑01‑26 | 2           | 2020‑11‑20    | 2020‑12‑19    | Yes                 |
| 4ONCNY  | NEWBMID    | 23ANG7JO      | 2017‑01‑26 | 2016‑01‑26 | 2022‑01‑26 | 3           | 2020‑01‑18    | 2020‑01‑21    | Yes                 |
| 4ONCNY  | NEWBMID    | 23ANG7JO      | 2017‑01‑26 | 2016‑01‑26 | 2022‑01‑26 | 4           | 2022‑09‑10    | 2022‑09‑21    | No                  |
| 4ONCNY  | NEWBMID    | 23ANG7JO      | 2017‑01‑26 | 2016‑01‑26 | 2022‑01‑26 | 5           | 2020‑05‑21    | 2020‑06‑08    | Yes                 |
| 4ONCNY  | NEWBMID    | 23ANG7JO      | 2017‑01‑26 | 2016‑01‑26 | 2022‑01‑26 | 6           | 2022‑08‑26    | 2022‑09‑25    | No                  |

### Example 3: Non-default variable names

#### Example 3.1: Different `data` date variables

- Simply change `data_start_date` and `data_end_date` to suit.

``` r
# Rename ReceptionDate and DischargeDate
eg3.1 <- aducust_flag(data = aducust %>% rename(StartDate = ReceptionDate,
                                                EndDate = DischargeDate),
                      dobmap = dobmap,
                      carer_map = carer_map, 
                      child_start_age = 10, 
                      child_end_age = 14,
                      data_start_date = "StartDate",
                      data_end_date = "EndDate")
#> Flagged aducust records when child is aged 10 to 14.
```

Previewing this:

| rootnum | carer_type | carer_rootnum | dob        | start_date | end_date   | aducust_num | StartDate  | EndDate    | carer_aducust_10_14 |
|---------|------------|---------------|------------|------------|------------|-------------|------------|------------|---------------------|
| 4ONCNY  | NEWBMID    | 23ANG7JO      | 2017‑01‑26 | 2027‑01‑26 | 2031‑01‑26 | 1           | 2020‑04‑20 | 2020‑05‑01 | No                  |
| 4ONCNY  | NEWBMID    | 23ANG7JO      | 2017‑01‑26 | 2027‑01‑26 | 2031‑01‑26 | 2           | 2020‑11‑20 | 2020‑12‑19 | No                  |
| 4ONCNY  | NEWBMID    | 23ANG7JO      | 2017‑01‑26 | 2027‑01‑26 | 2031‑01‑26 | 3           | 2020‑01‑18 | 2020‑01‑21 | No                  |
| 4ONCNY  | NEWBMID    | 23ANG7JO      | 2017‑01‑26 | 2027‑01‑26 | 2031‑01‑26 | 4           | 2022‑09‑10 | 2022‑09‑21 | No                  |
| 4ONCNY  | NEWBMID    | 23ANG7JO      | 2017‑01‑26 | 2027‑01‑26 | 2031‑01‑26 | 5           | 2020‑05‑21 | 2020‑06‑08 | No                  |
| 4ONCNY  | NEWBMID    | 23ANG7JO      | 2017‑01‑26 | 2027‑01‑26 | 2031‑01‑26 | 6           | 2022‑08‑26 | 2022‑09‑25 | No                  |

#### Example 3.2: Different ID variable names

- Simply change `carer_id_var` to suit.

``` r
eg3.2 <- aducust_flag(data = aducust %>% rename(OtherID = carer_rootnum),
                      dobmap = dobmap,
                      carer_map = carer_map %>% rename(OtherID = carer_rootnum),
                      carer_id_var = "OtherID")
#> Flagged aducust records when child is aged 0 to 18.
```

Previewing this:

| rootnum | carer_type | OtherID  | dob        | start_date | end_date   | aducust_num | ReceptionDate | DischargeDate | carer_aducust_0_18 |
|---------|------------|----------|------------|------------|------------|-------------|---------------|---------------|--------------------|
| 4ONCNY  | NEWBMID    | 23ANG7JO | 2017‑01‑26 | 2017‑01‑26 | 2035‑01‑26 | 1           | 2020‑04‑20    | 2020‑05‑01    | Yes                |
| 4ONCNY  | NEWBMID    | 23ANG7JO | 2017‑01‑26 | 2017‑01‑26 | 2035‑01‑26 | 2           | 2020‑11‑20    | 2020‑12‑19    | Yes                |
| 4ONCNY  | NEWBMID    | 23ANG7JO | 2017‑01‑26 | 2017‑01‑26 | 2035‑01‑26 | 3           | 2020‑01‑18    | 2020‑01‑21    | Yes                |
| 4ONCNY  | NEWBMID    | 23ANG7JO | 2017‑01‑26 | 2017‑01‑26 | 2035‑01‑26 | 4           | 2022‑09‑10    | 2022‑09‑21    | Yes                |
| 4ONCNY  | NEWBMID    | 23ANG7JO | 2017‑01‑26 | 2017‑01‑26 | 2035‑01‑26 | 5           | 2020‑05‑21    | 2020‑06‑08    | Yes                |
| 4ONCNY  | NEWBMID    | 23ANG7JO | 2017‑01‑26 | 2017‑01‑26 | 2035‑01‑26 | 6           | 2022‑08‑26    | 2022‑09‑25    | Yes                |

#### Example 3.3: Different DOB variable

- Simply change `dobmap_dob_var` to suit.

``` r
eg3.3 <- aducust_flag(data = aducust,
                      dobmap = dobmap %>% rename(dateofbirth = dob),
                      carer_map = carer_map,
                      dobmap_dob_var = "dateofbirth")
#> Flagged aducust records when child is aged 0 to 18.
```

Previewing this:

| rootnum | carer_type | carer_rootnum | dateofbirth | start_date | end_date   | aducust_num | ReceptionDate | DischargeDate | carer_aducust_0_18 |
|---------|------------|---------------|-------------|------------|------------|-------------|---------------|---------------|--------------------|
| 4ONCNY  | NEWBMID    | 23ANG7JO      | 2017‑01‑26  | 2017‑01‑26 | 2035‑01‑26 | 1           | 2020‑04‑20    | 2020‑05‑01    | Yes                |
| 4ONCNY  | NEWBMID    | 23ANG7JO      | 2017‑01‑26  | 2017‑01‑26 | 2035‑01‑26 | 2           | 2020‑11‑20    | 2020‑12‑19    | Yes                |
| 4ONCNY  | NEWBMID    | 23ANG7JO      | 2017‑01‑26  | 2017‑01‑26 | 2035‑01‑26 | 3           | 2020‑01‑18    | 2020‑01‑21    | Yes                |
| 4ONCNY  | NEWBMID    | 23ANG7JO      | 2017‑01‑26  | 2017‑01‑26 | 2035‑01‑26 | 4           | 2022‑09‑10    | 2022‑09‑21    | Yes                |
| 4ONCNY  | NEWBMID    | 23ANG7JO      | 2017‑01‑26  | 2017‑01‑26 | 2035‑01‑26 | 5           | 2020‑05‑21    | 2020‑06‑08    | Yes                |
| 4ONCNY  | NEWBMID    | 23ANG7JO      | 2017‑01‑26  | 2017‑01‑26 | 2035‑01‑26 | 6           | 2022‑08‑26    | 2022‑09‑25    | Yes                |

### Example 4: Summarising Records

#### Example 4.1: Summarising within carer

- `carer_summary=TRUE`
- Within each carer, returns:
  - “Yes” if flag is “Yes” across any aducust record.
  - “No” if flag is “No” across all aducust records.

``` r
eg4.1 <- aducust_flag(data = aducust,
                      dobmap = dobmap,
                      carer_map = carer_map,
                      carer_summary = TRUE)
#> Flagged aducust records when child is aged 0 to 18.
```

Previewing this:

| rootnum | carer_type | carer_rootnum | dob        | carer_aducust_0_18 |
|---------|------------|---------------|------------|--------------------|
| 03DX1C  | NEWBMID    | HYZQLPJE      | 2018‑05‑26 | Yes                |
| 03DX1C  | carer1id   | FUQZ4L2X      | 2018‑05‑26 | Yes                |
| 08WC4B  | NEWBMID    | P7JBUH66      | 2016‑12‑10 | Yes                |
| 0YUOZ4  | carer2id   | 8U719ZAZ      | 2018‑08‑15 | Yes                |
| 1L1BLF  | carer2id   | VZ9O0HVY      | 2016‑05‑17 | Yes                |
| 264HX3  | carer1id   | ER04K2AG      | 2011‑04‑16 | Yes                |

#### Example 4.2: Summarising across carers

- `any_carer_summary=TRUE`
- Across all aducust records for all carers for a child, returns:
  - “Yes” if any flags are “Yes”.
  - “No” if all flags are “No”.

``` r
eg4.2 <- aducust_flag(data = aducust,
                      dobmap = dobmap,
                      carer_map = carer_map,
                      any_carer_summary = TRUE)
#> Warning in aducust_flag(data = aducust, dobmap = dobmap, carer_map = carer_map,
#> : 'any_carer_summary' is TRUE but 'carer_summary' is FALSE. 'carer_summary'
#> will be ignored, and collapsing will occur across carers.
#> Flagged aducust records when child is aged 0 to 18.
```

The above warning is to note that `carer_summary` will be ignored, and
records will be collapsed to a child level.

Previewing this:

| rootnum | dob        | carer_aducust_0_18 |
|---------|------------|--------------------|
| 03DX1C  | 2018‑05‑26 | Yes                |
| 08WC4B  | 2016‑12‑10 | Yes                |
| 0YUOZ4  | 2018‑08‑15 | Yes                |
| 1L1BLF  | 2016‑05‑17 | Yes                |
| 264HX3  | 2011‑04‑16 | Yes                |
| 28HZGI  | 2014‑09‑29 | Yes                |

And to check the collapse is correct:

``` r
nrow(eg4.2) == length(unique(dobmap$rootnum))
#> [1] TRUE
```

## Conclusion

The `aducust_flag` function prototype is useful for consistently
flagging aducust data sets.
