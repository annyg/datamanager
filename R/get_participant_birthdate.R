#' Get participant birthdate based on social ID
#'
#' This function calculates the birthdate of a participant based on their social ID.
#'
#' @param socID Social ID of the participant
#' @param refDate Reference date for calculations (default is current date)
#' @param unit The unit of time to calculate the birthdate difference in (default is "year")
#' @param cutoff_2000 Cutoff year for two-digit year parsing (default is 22)
#'
#' @return A date object representing the participant's birthdate
#'
#' @importFrom lubridate parse_date_time2
#' @importFrom stringr str_sub
#' @importFrom stringr str_pad
#'
#' @export
#'
get_participant_birthdate <- function(socID, refDate = Sys.Date(), unit = "year", cutoff_2000 = 22L) {
  require(lubridate)
  birthDate <- parse_date_time2(str_sub(str_pad(socID, 11, "left", pad = 0), 0 ,6), "dmy", cutoff_2000 = cutoff_2000)
}
