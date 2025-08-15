#' Drop long variables from a dataset
#'
#' This function drops variables from a dataset that have names longer than a specified length.
#'
#' @param data The dataset from which to drop long variables.
#' @param variable_length The maximum character length for a variable name. Default is 32.
#' @return A list containing the modified dataset and a message with the names of dropped variables.
#'
#' @examples
#' data <- iris
#' drop_long_variables(data, 5)
#'
#' @export
drop_long_variables <- function(data, variable_length = 32) {
  long_var_names <- names(data)[nchar(names(data)) > variable_length]
  dropped_vars <- names(data)[nchar(names(data)) > variable_length]
  data <- data[, !(nchar(names(data)) > variable_length)]

  message(paste("Dropped variables longer than", variable_length, "characters:", paste(dropped_vars, collapse = ", ")))

  return(list(data = data, message = dropped_vars))
}
