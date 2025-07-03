#' Apply base theming to a flextable
#'
#' Internal function for setting header, footer, and body background colors,
#' with optional row highlighting.
#'
#' @param x A flextable object
#' @param header_bg Named vector of background colors for header rows (`odd`, `even`)
#' @param footer_bg Named vector of background colors for footer rows (`odd`, `even`)
#' @param body_bg Named vector of background colors for body rows (`odd`, `even` or `highlight`, `other`)
#' @param highlight Optional integer vector of row indices to highlight
#'
#' @return A styled flextable object
#' @noRd
table_theme <- function(x,
                        header_bg_col,
                        body_bg_col,
                        highlight = NULL) {
  stopifnot(inherits(x, "flextable"))

  h_n <- flextable::nrow_part(x, "header")
  f_n <- flextable::nrow_part(x, "footer")
  b_n <- flextable::nrow_part(x, "body")

  x <- flextable::border_remove(x)
  x <- flextable::align(x, align = "center", part = "header")

  # Header formatting
  if (h_n > 0) {
    even <- seq_len(h_n) %% 2 == 0
    odd <- !even
    x <- flextable::bg(x, i = which(odd), bg = header_bg_col["odd"], part = "header")
    x <- flextable::bg(x, i = which(even), bg = header_bg_col["even"], part = "header")
    x <- flextable::bold(x, part = "header")
  }

  # Body formatting
  if (b_n > 0) {
    if (!is.null(highlight)) {
      other <- setdiff(seq_len(b_n), highlight)
      x <- flextable::bg(x, i = highlight, bg = body_bg_col["highlight"], part = "body")
      x <- flextable::bg(x, i = other, bg = body_bg_col["other"], part = "body")
    } else {
      even <- seq_len(b_n) %% 2 == 0
      odd <- !even
      x <- flextable::bg(x, i = which(odd), bg = body_bg_col["odd"], part = "body")
      x <- flextable::bg(x, i = which(even), bg = body_bg_col["even"], part = "body")
    }
  }

  x <- flextable::align_text_col(x, align = "left", header = TRUE)
  x <- flextable::align_nottext_col(x, align = "right", header = TRUE)
  x
}


#' Highlight specific rows in a flextable
#'
#' Applies row-specific highlighting to the body of a flextable.
#'
#' @param x A flextable object
#' @param colour A valid colour name from `thekids_palettes$primary`
#' @param highlight Integer vector of row indices to highlight
#'
#' @return A styled flextable
#' @noRd
table_highlight <- function(x, header_bg_col, body_bg_col, highlight, highlight_darken) {
  # x must already be converted to a flextable
  stopifnot(inherits(x, "flextable"))

  # Ensure the highlight value is in integer
  if (!is.null(highlight)) {
    if (!is.numeric(highlight) || any(highlight <= 0) || any(highlight != floor(highlight))) {
      stop("`highlight` must be a vector of positive integers.", call. = FALSE)
    }
  }

  b_n <- flextable::nrow_part(x, "body")
  if (!is.null(highlight) && length(highlight) > 0) {
    if (any(highlight > b_n)) {
      stop(sprintf(
        "You are trying to highlight a row (%s) beyond the number of rows in the table body (%d).",
        paste(highlight, collapse = ", "), b_n
      ), call. = FALSE)
    }
  }

  body_col_vec <- c("highlight" = colorspace::darken(body_bg_col, amount = highlight_darken),
                    "other" = body_bg_col)

  table_theme(x,
              header_bg_col = c("odd" = header_bg_col, "even" = "transparent"),
              body_bg_col = body_col_vec,
              highlight = highlight)
}

#' Plain table styling
#'
#' Applies header color but no body striping or highlighting.
#'
#' @param x A flextable object
#' @param colour A valid colour.
#'
#' @return A styled flextable
#' @noRd
table_plain_theme <- function(x, header_bg_col, body_bg_col) {
  table_theme(x,
              header_bg_col = c("odd" = header_bg_col, "even" = "transparent"),
              body_bg_col   = c("odd" = body_bg_col, "even" = body_bg_col))
}

#' Coerce various table types to a flextable
#'
#' Converts gtsummary, gt_tbl, or data.frame objects into a flextable.
#'
#' @param x A table-like object
#'
#' @return A flextable object
#' @noRd
table_coerce <- function(x) {
  if(any(class(x) %in% c("flextable"))){
    table_out <- x
  } else if(any(class(x) %in% c("gtsummary"))){
    table_out <- x %>%
      gtsummary::as_flex_table()
  } else if(any(class(x) %in% c("gt_tbl"))){
    table_out <- x %>%
      data.frame %>%
      flextable::flextable()
  } else if (any(class(x) %in% c("knitr_kable"))){
    if (length(as.character(x)) > 1){
      stop("Please ensure `format='html'` is specified inside `kable()` call to proceed.")
    } else {
      if (substr(as.character(x), start = 1, stop = 6) != "<table"){
        stop("Please ensure `format='html'` is specified inside `kable()` call to proceed.")
      }
    }
    table_out <- x %>%
      as.character() %>%
      rvest::read_html() %>%
      rvest::html_node("table") %>%
      rvest::html_table(fill = TRUE) %>%
      tidyr::as_tibble() %>%
      flextable::flextable()
  } else {
    table_out <- x %>%
      flextable::flextable()
  }
}


#' Validate and fallback font family
#'
#' Checks whether the specified font is available on the system. If not,
#' returns a fallback font ("sans").
#'
#' @param font_family A character string specifying a font name
#' @param fallback_family Fallback font in case specified font not available on the system (default "sans").
#'
#' @return A character string of the validated or fallback font
#' @noRd
check_font_family <- function(font_family, fallback_family = "sans") {
  if (requireNamespace("systemfonts", quietly = TRUE)) {
    matched <- systemfonts::match_fonts(font_family)
    if (!is.na(matched$path)) return(font_family)
  }
  fallback_family
}
