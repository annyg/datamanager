#' Categorise participant age into 5-year intervals
#'
#' Parses a Norwegian Social ID into a birthdate, computes age relative to
#' `refDate`, and bins the result into 5-year age categories from `"18-24 years"`
#' up to `"70 years +"`.
#'
#' @param socID Character. A Norwegian Social ID. Shorter strings are
#'   left-padded with zeros to 11 characters.
#' @param refDate Date. Reference date used to compute the age. Defaults to
#'   `Sys.Date()`.
#' @param unit Character. Time unit used internally when computing the age
#'   (`"year"`, `"month"`, `"week"`, or `"day"`). Defaults to `"year"`.
#' @param cutoff_2000 Integer. Two-digit-year cutoff passed to
#'   [lubridate::parse_date_time2()]. Defaults to `22L`.
#'
#' @return A character vector of 5-year age band labels (e.g. `"25-29 years"`),
#'   or `NA` if the SocID could not be parsed.
#'
#' @note The function in this file is currently named `get_participant_age()`
#'   and collides with the function of the same name in
#'   `R/get_participant_age.R`. It should be renamed (e.g.
#'   `get_participant_age_5int()`) before use.
#'
#' @seealso [get_participant_age()] for the continuous age in a chosen unit.
#'
#' @importFrom lubridate parse_date_time2
#' @importFrom stringr str_sub str_pad
#' @importFrom dplyr case_when between
#'
#' @export
get_participant_age <- function(socID, refDate = Sys.Date(), unit = "year", cutoff_2000 = 22L) {
  require(lubridate)
  birthDate <- parse_date_time2(str_sub(str_pad(socID, 11, "left", pad = 0), 0, 6), "dmy", cutoff_2000 = cutoff_2000)
  if (grepl(x = unit, pattern = "year")) {
    as.period(interval(birthDate, refDate), unit = "year")$year
  } else if (grepl(x = unit, pattern = "month")) {
    as.period(interval(birthDate, refDate), unit = "month")$month
  } else if (grepl(x = unit, pattern = "week")) {
    floor(as.period(interval(birthDate, refDate), unit = "day")$day / 7)
  } else if (grepl(x = unit, pattern = "day")) {
    as.period(interval(birthDate, refDate), unit = "day")$day
  } else {
    print("Argument 'unit' must be one of 'year', 'month', 'week', or 'day'")
    NA
  }
  case_when(
    between(birthDate, 18, 24) ~ "18-24 years",
    between(birthDate, 25, 29) ~ "25-29 years",
    between(birthDate, 30, 34) ~ "30-34 years",
    between(birthDate, 35, 39) ~ "35-39 years",
    between(birthDate, 40, 44) ~ "40-44 years",
    between(birthDate, 45, 49) ~ "45-49 years",
    between(birthDate, 50, 54) ~ "50-54 years",
    between(birthDate, 55, 59) ~ "55-59 years",
    between(birthDate, 60, 64) ~ "60-64 years",
    between(birthDate, 65, 69) ~ "65-69 years",
    birthDate >= 70 ~ "70 years +"
  )
}
