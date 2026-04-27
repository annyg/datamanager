#' Tidy a free-text phone number
#'
#' Strips spaces and parentheses from a phone-number string, coerces the
#' digits to numeric, and returns the last eight digits (the local subscriber
#' part of a Norwegian phone number).
#'
#' @param x Character vector of phone numbers, possibly containing spaces
#'   or parentheses.
#'
#' @return A character vector of the last eight digits of each cleaned number.
#'
#' @examples
#' prep_phone("(+47) 22 33 44 55")
#'
#' @importFrom stringr str_squish str_replace_all str_sub
#' @export
prep_phone <- function(x) {
  # library(stringr)
  phone <- str_sub(as.double(str_replace_all(str_squish(x), c(
    " " = "",
    "\\(" = "",
    "\\)" = ""
  ))), -8)
  # case_when(str_length(as.double(str_replace_all(str_squish(x), c(" "="",
  #                                                                        "\\("="",
  #                                                                        "\\)"=""))) == 10 &
  #                               str_sub(as.double(str_replace_all(str_squish(x), c(" "="",
  #                                                                                  "\\("="",
  #                                                                                  "\\)"=""))),1,2) == 47)) ~


  # print(email)
}
