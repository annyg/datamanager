#' Drop variables whose names exceed a given length
#'
#' Removes columns whose names have more than `variable_length` characters.
#' Useful before exporting to formats with name-length limits (e.g. Stata
#' caps variable names at 32 characters). Emits a `message()` listing the
#' dropped names.
#'
#' @param data A data frame.
#' @param variable_length Integer. Maximum allowed character length for a
#'   column name. Defaults to `32`.
#'
#' @return A list with two elements:
#'   \describe{
#'     \item{`data`}{The input data frame with offending columns removed.}
#'     \item{`message`}{A character vector of the dropped column names.}
#'   }
#'
#' @examples
#' drop_long_variables(iris, 5)
#'
#' @export
drop_long_variables <- function(data, variable_length = 32) {
  long_var_names <- names(data)[nchar(names(data)) > variable_length]
  dropped_vars <- names(data)[nchar(names(data)) > variable_length]
  data <- data[, !(nchar(names(data)) > variable_length)]

  message(paste("Dropped variables longer than", variable_length, "characters:", paste(dropped_vars, collapse = ", ")))

  return(list(data = data, message = dropped_vars))
}
