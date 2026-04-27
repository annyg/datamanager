#' List a data frame's column names with their character lengths
#'
#' Useful when preparing a dataset for export to formats that limit variable
#' name length (e.g. Stata's 32-character limit).
#'
#' @param data A data frame.
#'
#' @return A data frame with two columns:
#'   \describe{
#'     \item{`columns_names`}{Each column name from `data`.}
#'     \item{`column_name_length`}{Number of characters in the corresponding name.}
#'   }
#'
#' @examples
#' data <- data.frame(col1 = c(1, 2, 3), col2 = c("A", "B", "C"))
#' get_column_names(data)
#'
#' @importFrom dplyr rename mutate
#' @importFrom stringr str_length
#' @export
get_column_names <- function(data) {
  as.data.frame(colnames(data)) %>%
    rename(columns_names = "colnames(data)") %>%
    mutate(column_name_length = str_length(columns_names))
}
