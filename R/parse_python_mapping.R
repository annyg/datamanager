#' Parse Custom Variable Mapping File
#'
#' Reads a custom-formatted text file defining variable labels and value labels,
#' and parses it into a data frame suitable for use with labelling tools such as
#' `labelled` or `sjlabelled`.
#'
#' @param file_path Path to the mapping file (e.g., a `.txt` file) with variable and value label definitions.
#'
#' @return A `data.frame` with one row per variable, containing the following columns:
#'   \describe{
#'     \item{new_var_name}{The name of the variable in the new dataset.}
#'     \item{var_label}{The descriptive label of the variable.}
#'     \item{var_format}{Optional format code (e.g., SPSS format type) if specified.}
#'     \item{old_var_name}{Original variable name (e.g., from the raw dataset).}
#'     \item{val_labels}{A character string combining all value labels in the format `"0 = No, 1 = Yes"`.}
#'   }
#'
#' @details
#' The function expects the mapping file to use a specific format:
#' - Variable definitions follow the pattern:
#'   `newname: 'Label text' <- TYPE :: oldname`
#' - Value labels follow the pattern:
#'   `  1 = 'Yes' <- varname`
#'
#' @examples
#' \dontrun{
#' mapping_df <- parse_variable_mapping("column_mapping.baseline.txt")
#' }
#'
#' @export
parse_variable_mapping <- function(file_path) {
  library(stringr)
  library(dplyr)

  # Read mapping file
  raw_text <- readLines(file_path, warn = FALSE, encoding = "UTF-8")

  # Initialize outputs
  var_table <- data.frame(
    new_var_name = character(),
    var_label = character(),
    var_format = character(),
    old_var_name = character(),
    stringsAsFactors = FALSE
  )
  value_labels <- list()
  current_var <- NULL

  # Regex patterns
  var_pattern <- "^([A-Za-z0-9_]+)\\s*:\\s*'([^']+)'(?:\\s*<-\\s*([A-Z]+))?\\s*::\\s*([A-Za-z0-9_]+)$"
  val_pattern <- "^\\s*(\\d+)\\s*=\\s*'([^']+)'\\s*<-\\s*([A-Za-z0-9_]+|_)\\s*$"

  for (line in raw_text) {
    line <- str_trim(line)
    if (line == "") next

    if (str_detect(line, var_pattern)) {
      # Parse variable definition
      parts <- str_match(line, var_pattern)
      current_var <- parts[2]
      var_table <- rbind(var_table, data.frame(
        new_var_name = parts[2],
        var_label = parts[3],
        var_format = ifelse(is.na(parts[4]), NA, parts[4]),
        old_var_name = parts[5],
        stringsAsFactors = FALSE
      ))
    } else if (str_detect(line, val_pattern) && !is.null(current_var)) {
      # Parse value label
      parts <- str_match(line, val_pattern)
      val <- as.integer(parts[2])
      label <- parts[3]
      if (is.null(value_labels[[current_var]])) {
        value_labels[[current_var]] <- c()
      }
      value_labels[[current_var]][as.character(val)] <- label
    }
  }

  # Add val_labels as text to var_table
  var_table$val_labels <- sapply(var_table$new_var_name, function(var) {
    if (var %in% names(value_labels)) {
      paste0(
        names(value_labels[[var]]), " = ", value_labels[[var]],
        collapse = ", "
      )
    } else {
      NA_character_
    }
  })

  return(var_table)
  #return(list(var_table = var_table, value_labels = value_labels))
}
