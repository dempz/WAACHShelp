# Display dataframe as HTML table

**\[deprecated\]**

This function was deprecated because it was no longer required by
analysts.

## Usage

``` r
ptab(tt, shading = NULL, caption = " ", bodysize = 11)
```

## Arguments

- tt:

  Dataframe intended to display as a html table.

- shading:

  Vector denoting the lines of the table that might want to be shaded.
  For example, to shade the first, third and fifth rows, supply
  `shading = c(1, 3, 5)`.

- caption:

  Caption to add to the data set.

- bodysize:

  Text size of the table's content.

## Value

Two-way table

## Details

Created by PV (2023).
