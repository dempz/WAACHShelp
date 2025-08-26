#' Attendance flagging function for staggered (July--June) years
#'
#' Internal function for use in `check_att` for instances where kids are born post 1997,
#' where there are 'staggered' (July–June) school years.
#'
#' @param a_ref Reference data frame containing the minimum/maximum age an individual can be in each school level.
#' @param dob Date of birth (date object).
#' @param visibility_window Visibility window to consider.
#'
#' @return A list containing a flag for each year in `visibility_window` and total number of records.
#' @noRd
staggered_att <- function(a_ref, dob, visibility_window) {
  dob_year <- lubridate::year(dob)
  results <- data.frame(year = integer(), level = character(), stringsAsFactors = FALSE)

  # Born in first half of year
  if (dob >= as.Date(paste0(dob_year - 1, "-07-01")) &
      dob <= as.Date(paste0(dob_year, "-06-30"))) {

    for (i in visibility_window) {
      age <- as.numeric(difftime(paste0(i, "-12-31"), dob)) / 365.25

      if (age >= min(a_ref$min_age) & age <= max(a_ref$max_age)) {
        level <- a_ref %>%
          dplyr::filter(age >= .data$min_age & age <= .data$max_age) %>%
          dplyr::pull(.data$g)
      } else {
        level <- NA_character_
      }

      results <- rbind(results, data.frame(year = i, level = level, stringsAsFactors = FALSE))
    }
  }

  # Born in second half of year
  else if (dob >= as.Date(paste0(dob_year, "-07-01")) &
           dob <= as.Date(paste0(dob_year + 1, "-06-30"))) {

    for (i in visibility_window) {
      age <- floor(as.numeric(difftime(paste0(i, "-12-31"), dob)) / 365)

      if (age >= min(a_ref$min_age) & age <= max(a_ref$max_age)) {
        level <- a_ref %>%
          dplyr::filter(age >= .data$min_age & age <= .data$max_age) %>%
          dplyr::filter(.data$max_age == min(.data$max_age)) %>%
          dplyr::pull(.data$g)
      } else {
        level <- NA_character_
      }

      results <- rbind(results, data.frame(year = i, level = level, stringsAsFactors = FALSE))
    }
  }

  n_att <- nrow(dplyr::filter(results, !is.na(.data$level)))

  return(list(results = results, n = n_att))
}

#' Attendance flagging function for non-staggered (Jan--Dec) years
#'
#' Internal function for use in `check_att` for instances where kids are born pre 1997,
#' where there are 'non-staggered' calendar year school years.
#'
#' @param a_ref Reference data frame containing the minimum/maximum age an individual can be in each school level.
#' @param dob Date of birth (date object).
#' @param visibility_window Visibility window to consider.
#'
#' @return A list containing a flag for each year in `visibility_window` and total number of records.
#' @noRd
normal_att <- function(a_ref, dob, visibility_window) {
  dob_year <- lubridate::year(dob)
  results <- data.frame(year = integer(), level = character(), stringsAsFactors = FALSE)

  if (dob <= as.Date(paste0(dob_year, "-06-30"))) {
    for (i in visibility_window) {
      age <- floor(as.numeric(difftime(paste0(i, "-12-31"), dob)) / 365.25)

      if (age >= min(a_ref$min_age) & age <= max(a_ref$max_age)) {
        level <- a_ref %>%
          dplyr::filter(age >= .data$min_age & age <= .data$max_age) %>%
          dplyr::filter(.data$max_age == max(.data$max_age)) %>%
          dplyr::pull(.data$g)
      } else {
        level <- NA_character_
      }

      results <- rbind(results, data.frame(year = i, level = level, stringsAsFactors = FALSE))
    }
  }

  else if (dob >= as.Date(paste0(dob_year, "-07-01"))) {
    for (i in visibility_window) {
      age <- floor(as.numeric(difftime(paste0(i, "-12-31"), dob)) / 365)

      if (age >= min(a_ref$min_age) & age <= max(a_ref$max_age)) {
        level <- a_ref %>%
          dplyr::filter(age >= .data$min_age & age <= .data$max_age) %>%
          dplyr::filter(.data$max_age == max(.data$max_age)) %>%
          dplyr::pull(.data$g)
      } else {
        level <- NA_character_
      }

      results <- rbind(results, data.frame(year = i, level = level, stringsAsFactors = FALSE))
    }
  }

  n_att <- nrow(dplyr::filter(results, !is.na(.data$level)))

  return(list(results = results, n = n_att))
}
