#' Extract the birthdate encoded in a Norwegian Social ID
#'
#' Parses the leading 6 characters of a Norwegian Social Identification number
#' (`ddmmyy`) as a birthdate. The SocID is left-padded to 11 characters before
#' parsing, so shorter inputs (e.g. accidentally numeric-coerced IDs) are still
#' handled.
#'
#' @param socID Character. A Norwegian Social ID.
#' @param refDate Date. Unused; retained for signature compatibility with
#'   [get_participant_age()] and [calc_age()].
#' @param unit Character. Unused; retained for signature compatibility with
#'   [get_participant_age()] and [calc_age()].
#' @param cutoff_2000 Integer. Two-digit-year cutoff passed to
#'   [lubridate::parse_date_time2()]. Years `<= cutoff_2000` are interpreted as
#'   20xx, otherwise 19xx. Defaults to `22L`.
#'
#' @return A `POSIXct` object representing the participant's birthdate.
#'
#' @importFrom lubridate parse_date_time2
#' @importFrom stringr str_sub str_pad
#'
#' @export
#'
get_participant_birthdate <- function(socID, refDate = Sys.Date(), unit = "year", cutoff_2000 = 22L) {
  require(lubridate)
  birthDate <- parse_date_time2(str_sub(str_pad(socID, 11, "left", pad = 0), 0, 6), "dmy", cutoff_2000 = cutoff_2000)
}
