#' Calculate age based on given social ID and reference date
#'
#' This function calculates the age of an individual based on their social ID and a reference date.
#' The age can be returned in years, months, weeks, or days.
#'
#' @param socID The social ID of the individual
#' @param refDate The reference date to calculate the age from (default is today)
#' @param unit The unit in which to return the age ('year', 'month', 'week', or 'day')
#' @param cutoff_2000 The cutoff year for 2-digit years interpretation (default is 22)
#'
#' @return The age of the individual in the specified unit
#'
#' @examples
#' calc_age("01012012345", unit = "year")
#' calc_age("01012012345", unit = "month", refDate = as.Date("2022-01-01"))
#'
#' @import lubridate
#'
#' @export
calc_age <- function(socID, refDate = Sys.Date(), unit = "year", cutoff_2000 = 22L) {
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
