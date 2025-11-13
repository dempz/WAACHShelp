# Custodial data flagging function

This function flags whether a carer record (custodial, per its name)
exists when a child is of a certain age.

## Usage

``` r
aducust_flag(
  data,
  dobmap,
  carer_map,
  flag_name = "carer_aducust",
  child_id_var = "rootnum",
  carer_id_var = "carer_rootnum",
  data_start_date = "ReceptionDate",
  data_end_date = "DischargeDate",
  dobmap_dob_var = "dob",
  child_start_age = 0,
  child_end_age = 18,
  carer_summary = FALSE,
  any_carer_summary = FALSE
)
```

## Arguments

- data:

  Input dataset (carer aducust).

- dobmap:

  DOBmap file at the child level.

- carer_map:

  Mapping file with columns "child ID", "carer ID". Can have multiple
  rows per child (e.g., one per carer 1, carer 2, NEWBMID).

- flag_name:

  Name of flagging variable to return. Default `"carer_aducust"`.

- child_id_var:

  Variable denoting "child ID". Must exist and be called the same thing
  in `dobmap` and `carer_map`. Default `"rootnum"`.

- carer_id_var:

  Variable denoting "carer ID". Must exist in `carer_map`. Default
  `"carer_rootnum"`.

- data_start_date:

  Start date to consider in `data`. Corresponds to aducust *start* date.
  Default `"ReceptionDate"`.

- data_end_date:

  End date to consider in `data`. Corresponds to aducust *end* date.
  Default `"DischargeDate"`.

- dobmap_dob_var:

  Date of birth (DOB) variable in `dobmap`. Default `"dob"`.

- child_start_age:

  Numeric. Start (minimum) age (years) to consider for flagging (default
  `0`).

- child_end_age:

  Numeric. End (maximum) age (years) to consider for flagging (default
  `18`).

- carer_summary:

  Collapse aducust flags *within carer* (i.e., for each `carer_id_var`).
  Default `FALSE`.

- any_carer_summary:

  Collapse aducust flags *across carers*. Default `FALSE`.

## Value

Flagged dataframe.

## Details

While it is designed for use with flagging carer custodial records, it
can be applied in many other circumstances where flagging of a carer (or
otherwise) record exists when a child (or otherwise) is of a certain
age.

For more details, see the
[vignette](https://dempz.github.io/WAACHShelp/articles/aducust_flag.html).

## Note

- If `carer_summary` is `TRUE`, then we are flagging whether a specific
  carer has any aducust record.

- Therefore, we are assessing whether a specific carer has any aducust
  records.

- If `any_carer_summary` is `TRUE`, then we are flagging whether any
  carer (if multiple) have any aducust records.

- If `any_carer_summary` is `TRUE`, `carer_summary` will be ignored.

## Examples

``` r
if (FALSE) { # \dontrun{
# Example 1: Basic use
aducust_flag(data = carer_aducust %>% rename(carer_rootnum = root),
             dobmap = dobmap,
             carer_map = child_carer_map,
             child_id_var = "NEWUID",
             carer_id_var = "carer_rootnum",
             carer_summary = FALSE,
             any_carer_summary = TRUE
)
} # }
```
