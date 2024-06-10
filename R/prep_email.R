#' Load unprocessed followup submissions
#' @param x Messy email.
#' @return Clean email.
#' @export
prep_email <- function(x) {
  #library(stringr)
  email <- str_to_lower(
    str_replace_all(
      str_squish(x), c(" "="",
                         "\\("="",
                         "\\)"="")
    ))
  #print(email)
}
