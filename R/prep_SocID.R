#' Corrects the Norwegian Social Identification (SocID) number by left-padding it with zeros to have a length of 11.
#'
#' @param SocID A character representing the SocID to be corrected.
#' @return A character string with the corrected SocID.
#' @examples
#' prep_SocID("12345") # Returns "000000012345"
#' @export
prep_SocID <- function(SocID) {
  correct_SocID <- stringr::str_pad(
    SocID,
    11,
    "left",
    pad = 0
  )
  return(correct_SocID)
}
