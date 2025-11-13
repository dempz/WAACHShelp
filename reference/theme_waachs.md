# Apply WAACHS theme to ggplot2 plots

This function applies a custom theme to ggplot2 plots, incorporating
colours to align with the project's visual identity.

## Usage

``` r
theme_waachs(
  base_size = 12,
  base_line_size = base_size/22,
  base_rect_size = base_size/22
)
```

## Arguments

- base_size:

  Base font size

- base_line_size:

  Base line size (default `base_size/22`)

- base_rect_size:

  Base rectangle size (default `base_size/22`)

## Value

A list of ggplot2 theme elements and scale adjustments.

## Details

The function determines the operating system and selects appropriate
font names for Windows or other systems. It also adjusts colour scales.

## Examples

``` r
ggplot(mtcars,
       aes(x = mpg, y = wt, col = factor(cyl))) +
  geom_point() +
  theme_waachs()

```
