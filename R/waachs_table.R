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
#' @param highlight A numeric vector specifying rows to highlight.
#' @param highlight_darken A numeric value specifying the amount by which `body_bg_col` should be "darkened" (tinted) (default 0.3).
#' @param font_family Font family for plot (default Barlow).
#' @param ... Other arguments parsed to `flextable::set_flextable_defaults`.
#'
#' @importFrom gtsummary tbl_summary
#' @importFrom magrittr %>%
#'
#' @examples
#' head(mtcars) %>%
#'   waachs_table()
#'
#' @export

waachs_table <- function(x,
                         font.size = 10,
                         font.size.header = 11,
                         line.spacing = 1.5,
                         padding = 2.5,
                         body_bg_col = "#FEF0D8",
                         header_bg_col = "#89A1AD",
                         header_text_col = "black",
                         highlight = NULL,
                         highlight_darken = 0.3,
                         font_family = "Barlow",
                         ...) {


  # Check font family availability
  font_family <- check_font_family(font_family)


  # Check if x is already class flextable
  if (inherits(x, "flextable")) {
    warning("Object of class 'flextable' detected. Please note that some flextable formatting may not carry over as expected.\n\nPlease consider applying `waachs_table()` in place of `flextable()` call in your workflow.")
  }


  # Save *existing* flextable defaults so they can be restored at the end
  old_defaults <- flextable::get_flextable_defaults()

  # Ensure these existing defaults are reset on any exit
  #on.exit(flextable::init_flextable_defaults(), add = TRUE) ## This works! But resets to package default options on exit
  on.exit(do.call(flextable::set_flextable_defaults, old_defaults),
          add = TRUE)

  # NOW set the flextable defaults
  if (!is.null(highlight)){
    flextable::set_flextable_defaults(font.family = font_family,
                                      font.size = font.size,
                                      theme_fun = function(y) table_highlight(y,
                                                                              header_bg_col = header_bg_col,
                                                                              body_bg_col = body_bg_col,
                                                                              highlight = highlight,
                                                                              highlight_darken = highlight_darken),
                                      line_spacing = line.spacing,
                                      padding = padding,
                                      big.mark = "",
                                      table.layout = "autofit",
                                      ...)
  } else {
    flextable::set_flextable_defaults(font.family = font_family,
                                      font.size = font.size,
                                      theme_fun = function(y) table_plain_theme(y,
                                                                                header_bg_col = header_bg_col,
                                                                                body_bg_col = body_bg_col),
                                      line_spacing = line.spacing,
                                      padding = padding,
                                      big.mark = "",
                                      table.layout = "autofit",
                                      ...)
  }

  # Coerce x to flextable
  ## amended flextable defaults will be applied within function environment
  table_out <- table_coerce(x)

  table_out <- table_out %>%
    flextable::fontsize(size = font.size.header,
                        part = "header") %>%
    #flextable::bg(bg = header_bg_col,
    #              part = "header") %>%
    #flextable::bg(bg = body_bg_col,
    #              part = "body") %>%
    flextable::bold(part = "header") %>%
    flextable::hline_top(part = "all") %>%
    flextable::hline_bottom() %>%
    flextable::autofit()

  return(table_out)

}
