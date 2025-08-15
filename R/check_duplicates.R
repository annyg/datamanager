#' Check for duplicates in a dataset based on specified groups
#'
#' This function checks for duplicates in a dataset based on specified grouping variables.
#'
#' @param data The input dataset to check for duplicates
#' @param ... Unquoted variable names of the grouping variables
#'
#' @return A data frame with duplicates removed based on the specified grouping variables
#'
#' @examples
#' check_duplicates(mtcars, cyl, gear)
#'
#' @import dplyr
#'
#' @export
check_duplicates <- function(
    data,
    ...) {
  groups_ <- enquos(...)

  data <- data %>%
    dplyr::group_by(!!!groups_) %>%
    dplyr::filter(
      n() > 1
    ) %>%
    dplyr::select(!!!groups_, dplyr::everything())

  data
}
