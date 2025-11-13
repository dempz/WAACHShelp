# Education flagging function

This function serves to flag whether an individual is expected to have
education data for every year within a "visibility window" based on
their date of birth. The fact that "staggered" (June/July) years were
introduced in Western Australia in 1997 has been built into the
function.

## Usage

``` r
check_att(
  dob,
  visibility_min = 2008,
  visibility_max = 2014,
  show_expectation = TRUE
)
```

## Arguments

- dob:

  Date of individual. Must be class "Date".

- visibility_min:

  Minimum year in visibility window. Default `2008`.

- visibility_max:

  Maximum year in visibility window. Default `2014`.

- show_expectation:

  Logical. Show flagged dataframe with expected flag per year in
  visibility window. Default `TRUE`.

## Value

Flagged dataframe.

## Examples

``` r
check_att(dob = as.Date("2000-05-30"))
#> $results
#>   year level
#> 1 2008   Y03
#> 2 2009   Y04
#> 3 2010   Y05
#> 4 2011   Y06
#> 5 2012   Y07
#> 6 2013   Y08
#> 7 2014   Y09
#> 
#> $n
#> [1] 7
#> 
```
