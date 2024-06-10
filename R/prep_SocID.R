#' Load unprocessed followup submissions
#' @param x Messy email.
#' @return Clean email.
#' @export
prep_SocID <- function(SocID) {
  #library(tidyverse)
  correct_SocID <- stringr::str_pad(
    SocID,
    11,
    "left",
    pad = 0
    )
  #print("SocID prepped")
}
