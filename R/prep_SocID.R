#' Left-pad a Norwegian Social ID to 11 characters
#'
#' Norwegian Social Identification numbers are 11 characters long, but are
#' often stored as numerics that drop leading zeros. This helper restores them
#' by left-padding the input with `0`s up to length 11.
#'
#' @param SocID Character or numeric vector of Social IDs.
#' @return A character vector of zero-padded 11-character SocIDs.
#' @examples
#' prep_SocID("12345") # Returns "000000" + "12345" = "00000012345"
#' @importFrom stringr str_pad
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
