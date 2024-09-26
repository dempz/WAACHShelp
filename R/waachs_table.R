#' WAACHS table formatting function.
#'
#' Function to apply consistent formatting to summary tables rendered using R. Works with functions from the `gtsummary` package, or dataframes.
#'
#' Inspired and based on `thekidsbiostats::thekids_table()`.
#'
#' @param x A table, typically a data.frame, tibble, or output from gtsummary.
#' @param font.size The font size for text in the body of the table, defaults to 8 (passed throught to set_flextable_defaults).
#' @param font.size.header The font size for text in the header of the table, defaults to 10.
#' @param line.spacing Line spacing for the table, defaults to 1.5 (passed throught to set_flextable_defaults).
#' @param padding Padding around all four sides of the text within the cell, defaults to 2 (passed throught to set_flextable_defaults).
#' @param body_bg_col Body background colour (default WAACHS cream).
#' @param header_bg_col Header background colour (default WAACHS blue).
#' @param header_text_col Header text colour (default black).
#' @param font.family Font family for plot (default Barlow).
#'
#' @examples
#' head(mtcars) %>%
#'   waachs_table()
#'
#' @export

waachs_table <- function(x,
                         font.size = 8,
                         font.size.header = 10,
                         line.spacing = 1.5,
                         padding = 2,
                         body_bg_col = "#FEF0D8",
                         header_bg_col = "#89A1AD",
                         header_text_col = "black",
                         font.family = "Barlow"){

  # Set global defaults for flextable
  set_flextable_defaults(font.family = font.family,
                         font.size = font.size,
                         line_spacing = line.spacing,
                         padding = padding,
                         big.mark = "",
                         table.layout = "autofit")

  # Define the colors for the headers and the body
  header_bg_col <- header_bg_col
  body_bg_col <- body_bg_col
  header_text_col <- header_text_col

  if (any(class(x) %in% c("gtsummary"))) {
    x %>%
      as_flex_table() %>%
      fontsize(part = "header",
               size = font.size.header) %>%
      color(color = header_text_col,
            part = "header") %>%
      bg(bg = header_bg_col,
         part = "header") %>%  # Apply header background color
      color(color = "#111921",
            part = "body") %>%
      bold(part = "header") %>%
      bg(bg = body_bg_col,
         part = "body") %>%     # Apply cream background to the body
      autofit()
  }
  else if (any(class(x) %in% c("flextable"))) {
    x %>%
      fontsize(part = "header",
               size = font.size.header) %>%
      color(color = header_text_col,
            part = "header") %>%
      bg(bg = header_bg_col,
         part = "header") %>%  # Apply header background color
      color(color = "#111921",
            part = "body") %>%
      bg(bg = body_bg_col,
         part = "body") %>%     # Apply cream background to the body
      bold(part = "header") %>%
      hline_top(part = "all") %>%
      hline_bottom() %>%
      autofit()
  }
  else if (any(class(x) %in% c("gt_tbl"))) {
    x %>%
      data.frame() %>%
      flextable() %>%
      fontsize(part = "header",
               size = font.size.header) %>%
      color(color = header_text_col,
            part = "header") %>%
      bg(bg = header_bg_col,
         part = "header") %>%  # Apply header background color
      color(color = "#111921",
            part = "body") %>%
      bg(bg = body_bg_col,
         part = "body") %>%     # Apply cream background to the body
      bold(part = "header") %>%
      hline_top(part = "all") %>%
      hline_bottom() %>%
      autofit()
  }
  else {
    x %>%
      flextable() %>%
      fontsize(part = "header",
               size = font.size.header) %>%
      color(color = header_text_col,
            part = "header") %>%
      bg(bg = header_bg_col,
         part = "header") %>%  # Apply header background color
      color(color = "#111921",
            part = "body") %>%
      bg(bg = body_bg_col,
         part = "body") %>%     # Apply cream background to the body
      bold(part = "header") %>%
      hline_top(part = "all") %>%
      hline_bottom() %>%
      autofit()
  }
}
