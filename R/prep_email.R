#' Preprocess email addresses for cleaning
#'
#' This function preprocesses email addresses for cleaning by replacing common mistakes with correct domain names and removing extra spaces.
#'
#' @param x Character vector containing email addresses.
#' @return A character vector with preprocessed email addresses.
#' @examples
#' prep_email("example@email.com")
#' @export
#'
prep_email <- function(x) {
  library(stringr)
  email <- str_to_lower(
    str_replace_all(
      str_squish(x),
      c(" "="",
        "\\("="",
        "\\)"="",
        "gamil"="gmail",
        "gamil"="gmail",
        "gmal"="gmail",
        "hotnail"="hotmail",
        "yaoo"="yahoo",
        "yahou"="yahoo",
        "yaho"="yahoo")
    ))
  print(email)
}

