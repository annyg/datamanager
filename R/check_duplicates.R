#' Check for duplicates in dataset
#'
#' This function checks for duplicates in a data frame. It allows you to specify the output formats and generate metadata such as codebooks and dictionaries.
#'
#' @param df The data frame to be processed.
#' @param ... Variables to control for duplicates

#' @return None
#'
#' @examples
#'
check_duplicates <- function(
    data,
    ...
) {
  groups_ <- enquos(...)

  data <- data %>%
    dplyr::group_by(!!!groups_) %>%
    dplyr::filter(
      n() > 1
    ) %>%
    dplyr::select(!!!groups_, dplyr::everything())

  data
}
