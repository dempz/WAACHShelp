# HTML summary table

**\[deprecated\]**

This function was deprecated because it was no longer required by
analysts.

## Usage

``` r
proc_freq(var1, data = NULL, sort = NULL, min.frq = 0)
```

## Arguments

- var1:

  Name of the variable

- data:

  Dataset that contains `var1`

- sort:

  Optional argument which can take on "asc" or "desc" to indicate the
  type of sort required.

- min.frq:

  Minimum frequency

## Value

Dataframe

## Details

Renders a HTML table ready for plonking into a HTML or word document.

Renders output similar to the "proc freq" function of SAS.

Created by PV (2023).

## Examples

``` r
test = iris
proc_freq(Species, test)
#> Warning: `proc_freq()` was deprecated in WAACHShelp 1.4.2.
#> ℹ Function is no required by analysts.


.cl-81dcd660{}.cl-81d5226c{font-family:'DejaVu Sans';font-size:11pt;font-weight:bold;font-style:normal;text-decoration:none;color:rgba(0, 0, 0, 1.00);background-color:transparent;}.cl-81d52280{font-family:'DejaVu Sans';font-size:11pt;font-weight:normal;font-style:normal;text-decoration:none;color:rgba(0, 0, 0, 1.00);background-color:transparent;}.cl-81d52281{font-family:'DejaVu Sans';font-size:11pt;font-weight:normal;font-style:italic;text-decoration:none;color:rgba(0, 0, 0, 1.00);background-color:transparent;}.cl-81d8089c{margin:0;text-align:left;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);padding-bottom:5pt;padding-top:5pt;padding-left:5pt;padding-right:5pt;line-height: 1;background-color:transparent;}.cl-81d808a6{margin:0;text-align:right;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);padding-bottom:5pt;padding-top:5pt;padding-left:5pt;padding-right:5pt;line-height: 1;background-color:transparent;}.cl-81d8275a{width:0.931in;background-color:transparent;vertical-align: middle;border-bottom: 0.75pt solid rgba(102, 102, 102, 1.00);border-top: 0.75pt solid rgba(102, 102, 102, 1.00);border-left: 0.75pt solid rgba(102, 102, 102, 1.00);border-right: 0.75pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-81d82764{width:1.089in;background-color:transparent;vertical-align: middle;border-bottom: 0.75pt solid rgba(102, 102, 102, 1.00);border-top: 0.75pt solid rgba(102, 102, 102, 1.00);border-left: 0.75pt solid rgba(102, 102, 102, 1.00);border-right: 0.75pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-81d8276e{width:0.852in;background-color:transparent;vertical-align: middle;border-bottom: 0.75pt solid rgba(102, 102, 102, 1.00);border-top: 0.75pt solid rgba(102, 102, 102, 1.00);border-left: 0.75pt solid rgba(102, 102, 102, 1.00);border-right: 0.75pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-81d8276f{width:2.115in;background-color:transparent;vertical-align: middle;border-bottom: 0.75pt solid rgba(102, 102, 102, 1.00);border-top: 0.75pt solid rgba(102, 102, 102, 1.00);border-left: 0.75pt solid rgba(102, 102, 102, 1.00);border-right: 0.75pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-81d82770{width:1.878in;background-color:transparent;vertical-align: middle;border-bottom: 0.75pt solid rgba(102, 102, 102, 1.00);border-top: 0.75pt solid rgba(102, 102, 102, 1.00);border-left: 0.75pt solid rgba(102, 102, 102, 1.00);border-right: 0.75pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-81d82771{width:0.931in;background-color:transparent;vertical-align: middle;border-bottom: 0.75pt solid rgba(102, 102, 102, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0.75pt solid rgba(102, 102, 102, 1.00);border-right: 0.75pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-81d82778{width:1.089in;background-color:transparent;vertical-align: middle;border-bottom: 0.75pt solid rgba(102, 102, 102, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0.75pt solid rgba(102, 102, 102, 1.00);border-right: 0.75pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-81d82779{width:0.852in;background-color:transparent;vertical-align: middle;border-bottom: 0.75pt solid rgba(102, 102, 102, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0.75pt solid rgba(102, 102, 102, 1.00);border-right: 0.75pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-81d8277a{width:2.115in;background-color:transparent;vertical-align: middle;border-bottom: 0.75pt solid rgba(102, 102, 102, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0.75pt solid rgba(102, 102, 102, 1.00);border-right: 0.75pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-81d82782{width:1.878in;background-color:transparent;vertical-align: middle;border-bottom: 0.75pt solid rgba(102, 102, 102, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0.75pt solid rgba(102, 102, 102, 1.00);border-right: 0.75pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}

 

Species
```

Species

Frequency

Percent

Cumulative Frequency

Cumulative Percent

setosa

50

33.3

50

33.3

versicolor

50

33.3

100

66.7

virginica

50

33.3

150

100.0

Frequency Missing = 0

| Species               |           |         |                      |                    |
|-----------------------|-----------|---------|----------------------|--------------------|
| Species               | Frequency | Percent | Cumulative Frequency | Cumulative Percent |
| setosa                | 50        | 33.3    | 50                   | 33.3               |
| versicolor            | 50        | 33.3    | 100                  | 66.7               |
| virginica             | 50        | 33.3    | 150                  | 100.0              |
| Frequency Missing = 0 |           |         |                      |                    |

| Species               |           |         |                      |                    |
|-----------------------|-----------|---------|----------------------|--------------------|
| Species               | Frequency | Percent | Cumulative Frequency | Cumulative Percent |
| setosa                | 50        | 33.3    | 50                   | 33.3               |
| versicolor            | 50        | 33.3    | 100                  | 66.7               |
| virginica             | 50        | 33.3    | 150                  | 100.0              |
| Frequency Missing = 0 |           |         |                      |                    |

test\[1:4, "Species"\] \<- NA proc_freq(Species, test)

| Species               |           |         |                      |                    |
|-----------------------|-----------|---------|----------------------|--------------------|
| Species               | Frequency | Percent | Cumulative Frequency | Cumulative Percent |
| setosa                | 46        | 31.5    | 46                   | 31.5               |
| versicolor            | 50        | 34.2    | 96                   | 65.8               |
| virginica             | 50        | 34.2    | 146                  | 100.0              |
| Frequency Missing = 4 |           |         |                      |                    |

| Species               |           |         |                      |                    |
|-----------------------|-----------|---------|----------------------|--------------------|
| Species               | Frequency | Percent | Cumulative Frequency | Cumulative Percent |
| setosa                | 46        | 31.5    | 46                   | 31.5               |
| versicolor            | 50        | 34.2    | 96                   | 65.8               |
| virginica             | 50        | 34.2    | 146                  | 100.0              |
| Frequency Missing = 4 |           |         |                      |                    |

| Species               |           |         |                      |                    |
|-----------------------|-----------|---------|----------------------|--------------------|
| Species               | Frequency | Percent | Cumulative Frequency | Cumulative Percent |
| setosa                | 46        | 31.5    | 46                   | 31.5               |
| versicolor            | 50        | 34.2    | 96                   | 65.8               |
| virginica             | 50        | 34.2    | 146                  | 100.0              |
| Frequency Missing = 4 |           |         |                      |                    |
