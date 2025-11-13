# Summary function reminiscent of Stata's "tabset".

**\[deprecated\]**

This function was deprecated because it was no longer required by
analysts.

## Usage

``` r
sumfun(x, na.rm = TRUE, ...)
```

## Arguments

- x:

  Vector from input dataframe to summarise.

- na.rm:

  (Default TRUE) to remove NA (missing) observations from summary.

- ...:

  Any other arguments parsed into component base R functions.

## Value

Summary table with n (length), miss (number of missing observations),
mean, sd (standard deviation), med (median), q25 (first quartile), q75
(third quartile), min (minimum value), max (maximum value).

## Details

Created by PV (2023).

## Examples

``` r
sumfun(iris$Sepal.Length)
#> Warning: `sumfun()` was deprecated in WAACHShelp 1.4.2.
#> ℹ Function is no required by analysts.
#>     n miss     mean        sd med q25 q75 min max
#> 1 150    0 5.843333 0.8280661 5.8 5.1 6.4 4.3 7.9
```
