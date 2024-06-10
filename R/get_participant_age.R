#' Load unprocessed followup submissions
#' @param x Messy email.
#' @return Clean email.
#' @export
get_participant_age <- function(socID, refDate = Sys.Date(), unit = "year", cutoff_2000 = 22L) {
  require(lubridate)
  birthDate <- parse_date_time2(str_sub(str_pad(socID, 11, "left", pad = 0), 0 ,6), "dmy", cutoff_2000 = cutoff_2000)
  if(grepl(x = unit, pattern = "year")) {
    as.period(interval(birthDate, refDate), unit = 'year')$year
  } else if(grepl(x = unit, pattern = "month")) {
    as.period(interval(birthDate, refDate), unit = 'month')$month
  } else if(grepl(x = unit, pattern = "week")) {
    floor(as.period(interval(birthDate, refDate), unit = 'day')$day / 7)
  } else if(grepl(x = unit, pattern = "day")) {
    as.period(interval(birthDate, refDate), unit = 'day')$day
  } else {
    print("Argument 'unit' must be one of 'year', 'month', 'week', or 'day'")
    NA
  }

}

