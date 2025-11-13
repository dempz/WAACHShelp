# ICD Classification Data set

Data set specifying the ICD (9 & 10) codes for different events in the
morbidity data set.

## Usage

``` r
data(icd_dat)
```

## Format

A data frame where rows correspond to an event and columns correspond to
the variable name, morbidity search parameters (diagnosis/ediag, ecode)
and ICD code breakdown

- num:

  Counter variable representing the number of rows associated with any
  given var

- classification:

  Classification type

- var:

  Variable name

- broad_type:

  Type of diagnosis field this ICD code corresponds to (diagnosis &
  ediag = "diag_ediag", ecode = "ecode")

- letter:

  Letter of ICD code (purely numeric is empty string "")

- lower:

  Lower bound of numeric element of ICD code

- upper:

  Upper bound of numeric element of ICD code

## Source

Generated internally by package
