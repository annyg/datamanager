#' Get column names from a data frame and calculate the length of each column name
#'
#' This function takes a data frame as input, retrieves the column names, renames the column, and calculates the length of each column name.
#'
#' @param data A data frame containing the data
#'
#' @return A data frame with two columns: 'columns_names' (column names) and 'column_name_length' (string length of each column name)
#'
#' @examples
#' data <- data.frame(col1 = c(1, 2, 3), col2 = c("A", "B", "C"))
#' get_column_names(data)
#'
#' @export
get_column_names <- function(data) {
  as.data.frame(colnames(data)) %>%
    rename(columns_names = "colnames(data)") %>%
    mutate(column_name_length = str_length(columns_names))
}
