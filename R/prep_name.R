#' Tidy a free-text name
#'
#' Normalises a person's name by collapsing internal whitespace and
#' converting the result to title case (first letter of each word capitalised,
#' the rest lower case).
#'
#' @param x Character vector of names.
#'
#' @return A character vector of the same length as `x`, with whitespace
#'   squished and casing normalised to title case.
#'
#' @examples
#' prep_name("  ANDERS    nygaard ")
#'
#' @importFrom stringr str_squish str_to_lower str_to_title
#' @export
prep_name <- function(x) {
  # library(stringr)
  name <- str_to_title(
    str_to_lower(
      str_squish(x)
    )
  )
  # print(name)
}
