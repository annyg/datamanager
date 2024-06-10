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
  case_when(between(birthDate, 18, 24) ~ "18-24 years",
            between(birthDate, 25, 29) ~ "25-29 years",
            between(birthDate, 30, 34) ~ "30-34 years",
            between(birthDate, 35, 39) ~ "35-39 years",
            between(birthDate, 40, 44) ~ "40-44 years",
            between(birthDate, 45, 49) ~ "45-49 years",
            between(birthDate, 50, 54) ~ "50-54 years",
            between(birthDate, 55, 59) ~ "55-59 years",
            between(birthDate, 60, 64) ~ "60-64 years",
            between(birthDate, 65, 69) ~ "65-69 years",
            birthDate >= 70 ~ "70 years +")
}

