# Add rows to labelled data set.

**\[deprecated\]**

This function was deprecated because it was no longer required by
analysts.

## Usage

``` r
add_rows2(..., id = NULL)
```

## Arguments

- ...:

  Other parameters to parse to function.

- id:

  Default NULL

## Value

SAS labelled dataframe

## Details

Almost identical to the original
[`dplyr::add_row`](https://tibble.tidyverse.org/reference/add_row.html)
but also looks for `format.sas` attribute which `haven` provides when
loading as SAS dataset.

Created by PV (2023).
