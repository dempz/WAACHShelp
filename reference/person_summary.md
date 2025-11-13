# Summarise a dataframe to a person level

In cases where we have a *long* data frame (i.e., multiple rows of data
per participant) with a flag against each record (e.g., variable `x` =
"Yes"/"No"), this function will collapse this dataframe to a participant
level.

## Usage

``` r
person_summary(data, flag_category, flag_category_val = "Yes", grouping_var)
```

## Arguments

- data:

  Input dataframe.

- flag_category:

  Name of the variable to perform classification on.

- flag_category_val:

  String value of the `flag_category` variable the flag will be judged
  against. Defaults to "Yes".

- grouping_var:

  Grouping ID variable that identifies potentially multiple records per
  participant.

## Details

The collapsing is based on the value of `flag_category_val` and a
grouping variable (participant ID) `grouping_var`.

Specifically, records will be collapsed such that:

- If *any* record(s) for a participant is equal to `flag_category_val`,
  then return "Yes".

- If *all* record(s) for a participant are not equal to
  `flag_category_val`, then return "No".

## Examples

``` r
if (FALSE) { # \dontrun{
person_summary(data = dat,
               flag_category = "variable_x",
               flag_category_val = "Yes",
               grouping_var = "record_id"
               )
} # }
```
