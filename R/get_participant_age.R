#' Calculate participant age from a Norwegian Social ID
#'
#' Parses the leading 6 characters of a Norwegian Social Identification number
#' (`ddmmyy`) as a birthdate and returns the participant's age relative to a
#' reference date. The SocID is left-padded to 11 characters before parsing.
#'
#' @param socID Character. A Norwegian Social ID. Shorter strings are
#'   left-padded with zeros to 11 characters.
#' @param refDate Date. Reference date used to compute the age. Defaults to
#'   `Sys.Date()`.
#' @param unit Character. One of `"year"`, `"month"`, `"week"`, or `"day"`.
#'   Defaults to `"year"`.
#' @param cutoff_2000 Integer. Two-digit-year cutoff passed to
#'   [lubridate::parse_date_time2()]. Years `<= cutoff_2000` are interpreted as
#'   20xx, otherwise 19xx. Defaults to `22L`.
#'
#' @return A numeric value: the participant's age in the requested `unit`, or
#'   `NA` if `unit` is not recognised.
#'
#' @seealso [calc_age()], [get_participant_birthdate()]
#'
#' @importFrom lubridate parse_date_time2 as.period interval
#' @importFrom stringr str_sub str_pad
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
}
