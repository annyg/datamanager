#' Load unprocessed followup submissions
#' @param x Messy email.
#' @return Clean email.
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
