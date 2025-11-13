# Basic ICD code function

This function is already used by the team, and filters alphanumeric
ICD-9 and ICD-10 codes pursuant to requirements.

## Usage

``` r
val_filt(input_vec, letter, lower, upper)
```

## Arguments

- input_vec:

  Vector of all admissible ICD codes to filter on.

- letter:

  Letter to base filtration on (if purely numeric use empty string "")

- lower:

  Lower bound on the numeric element of the ICD code (includes numerics
  \>=lower).

- upper:

  Upper bound on the numeric element of the ICD code (includes numerics
  \<=upper).

## Value

Vector with filtered ICD codes.

## Examples

``` r
# Filter ICD codes in val3 to those between F10 and F10.9 (inclusive).
if (FALSE) { # \dontrun{
val_filt(val3, "F", 10.0, 10.9)
} # }
```
