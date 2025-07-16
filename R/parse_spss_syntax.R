#' Parse SPSS Syntax File for Variable and Value Labels
#'
#' Reads a `.sps` or `.txt` SPSS syntax file containing `VARIABLE LABELS` and `VALUE LABELS`
#' statements and extracts them into a tidy `data.frame`.
#'
#' @param filepath Character string. Path to the SPSS syntax file.
#'
#' @return A `data.frame` with one row per variable, containing:
#' \describe{
#'   \item{var_name}{The name of the variable.}
#'   \item{var_label}{The descriptive label assigned to the variable.}
#'   \item{val_labels}{A single character string of all value labels (if any) in the format `"0 = No, 1 = Yes"`.}
#' }
#'
#' @details
#' The function expects the SPSS syntax to follow common conventions:
#' \itemize{
#'   \item Each `VARIABLE LABELS` line contains exactly one variable and ends with a period.
#'   \item `VALUE LABELS` blocks span multiple lines. The block ends when the final value label ends with a period.
#'   \item Both numeric and string values can be used in value labels.
#' }
#'
#' @examples
#' \dontrun{
#' df_labels <- parse_spss_syntax("labels_2025.sps")
#' }
#'
#' @export
parse_spss_syntax <- function(filepath) {
  library(stringr)

  lines <- readLines(filepath, warn = FALSE, encoding = "UTF-8")

  # --- Initialize ---
  var_table <- data.frame(
    var_name = character(),
    var_label = character(),
    stringsAsFactors = FALSE
  )
  value_labels <- list()

  inside_val_block <- FALSE
  current_var <- NULL

  for (i in seq_along(lines)) {
    line <- str_trim(lines[i])

    # --- VARIABLE LABELS ---
    if (str_detect(line, "^VARIABLE LABELS\\s+")) {
      parts <- str_match(line, "^VARIABLE LABELS\\s+([A-Za-z0-9_.]+)\\s+'(.*?)'\\.$")
      if (!is.na(parts[1])) {
        var_table <- rbind(var_table, data.frame(
          var_name = parts[2],
          var_label = parts[3],
          stringsAsFactors = FALSE
        ))
      }
    }

    # --- VALUE LABELS START ---
    else if (str_detect(line, "^VALUE LABELS\\s+([A-Za-z0-9_.]+)\\s*$")) {
      parts <- str_match(line, "^VALUE LABELS\\s+([A-Za-z0-9_.]+)\\s*$")
      current_var <- parts[2]
      value_labels[[current_var]] <- c()
      inside_val_block <- TRUE
    }

    # --- Inside VALUE LABELS block ---
    else if (inside_val_block && !is.null(current_var)) {
      parts <- str_match(line, "^([0-9A-Za-z_.']+)\\s+'(.*?)'\\.?$")
      if (!is.na(parts[1])) {
        value <- parts[2]
        label <- parts[3]
        value_labels[[current_var]][value] <- label
      }

      # Check if this is the last value label line (ends with a period)
      if (str_detect(line, "\\.\\s*$")) {
        inside_val_block <- FALSE
        current_var <- NULL
      }
    }
  }

  # --- Add value label summaries to var_table ---
  var_table$val_labels <- NA_character_
  for (i in seq_len(nrow(var_table))) {
    var <- var_table$var_name[i]
    if (var %in% names(value_labels)) {
      val_lab_vec <- value_labels[[var]]
      val_lab_str <- paste0(names(val_lab_vec), " = ", val_lab_vec, collapse = ", ")
      var_table$val_labels[i] <- val_lab_str
    }
  }

  # return(list(var_table = var_table, value_labels = value_labels))
  return(var_table)
}
