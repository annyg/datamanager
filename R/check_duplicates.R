#' Return rows that are duplicated across the given grouping variables
#'
#' Groups the input by the columns passed via `...` and returns only the rows
#' belonging to groups whose size is greater than one — i.e. the rows that
#' share their grouping key with at least one other row. Useful for inspecting
#' duplicates rather than removing them.
#'
#' @param data A data frame.
#' @param ... Unquoted column names that together define the duplicate key.
#'
#' @return A grouped data frame containing only the rows whose group size is
#'   `> 1`, with the grouping columns moved to the front.
#'
#' @examples
#' check_duplicates(mtcars, cyl, gear)
#'
#' @importFrom dplyr group_by filter select everything
#' @importFrom rlang enquos
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
