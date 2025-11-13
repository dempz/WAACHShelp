# Compile metadata from dataframe

**\[deprecated\]**

This function was deprecated because it was no longer required by
analysts.

## Usage

``` r
proc_contents(df)
```

## Arguments

- df:

  Dataframe to input.

## Value

Dataframe

## Details

This little function pulls out the labels and formats from a dataframe
and compiles this metadata as a dataframe.

Imitates the "proc contents" function of SAS.

Created by PV (2023).

## Examples

``` r
proc_contents(iris)
#> Warning: `proc_contents()` was deprecated in WAACHShelp 1.4.2.
#> ℹ Function is no required by analysts.
#> # A tibble: 5 × 5
#>   var_name     class    format.sas num_labels label
#>   <chr>        <chr>    <chr>      <chr>      <chr>
#> 1 Sepal.Length ""       ""         null       ""   
#> 2 Sepal.Width  ""       ""         null       ""   
#> 3 Petal.Length ""       ""         null       ""   
#> 4 Petal.Width  ""       ""         null       ""   
#> 5 Species      "factor" ""         null       ""   
```
