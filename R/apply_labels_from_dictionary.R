#' Apply Variable and Value Labels to a Data Frame with Optional Variable Renaming
#'
#' This function adds variable and value labels to a data frame using a label dictionary,
#' and optionally renames variables using a new name mapping.
#'
#' @param data A data frame without labels (e.g., imported from CSV).
#' @param dictionary A data frame containing at least variable names and labels.
#' @param var_name_col The name of the column in `dictionary` containing the current variable names in the dataset.
#' @param var_label_col The name of the column in `dictionary` containing the variable labels.
#' @param val_label_col Optional. The name of the column in `dictionary` containing value labels as strings like `"1 = Yes, 0 = No"`.
#' @param new_var_name_col Optional. The name of the column in `dictionary` containing new variable names. If specified, dataset variables will be renamed.
#'
#' @return A labelled data frame with updated variable names, variable labels, and value labels.
#'
#' @importFrom labelled var_label var_label<- val_labels val_labels<-
#' @export
apply_labels_from_dictionary <- function(data,
                                         dictionary,
                                         var_name_col = "var_name",
                                         var_label_col = "var_label",
                                         val_label_col = NULL,
                                         new_var_name_col = NULL) {
  library(labelled)
  library(stringr)

  # --- Rename variables if new names provided ---
  if (!is.null(new_var_name_col)) {
    rename_map <- setNames(dictionary[[new_var_name_col]], dictionary[[var_name_col]])
    rename_map <- rename_map[names(rename_map) %in% names(data)]
    data <- dplyr::rename(data, !!!rename_map)
  }

  # Use new name for lookup if renaming was done
  lookup_names <- if (!is.null(new_var_name_col)) dictionary[[new_var_name_col]] else dictionary[[var_name_col]]

  for (i in seq_len(nrow(dictionary))) {
    var <- lookup_names[i]

    # Skip if variable not in dataset
    if (!var %in% names(data)) next

    # --- Assign variable label ---
    var_lab <- dictionary[[var_label_col]][i]
    if (!is.na(var_lab) && nzchar(var_lab)) {
      var_label(data[[var]]) <- var_lab
    }

    # --- Assign value labels ---
    if (!is.null(val_label_col)) {
      val_lab_str <- dictionary[[val_label_col]][i]
      if (!is.na(val_lab_str) && nzchar(val_lab_str)) {
        # Parse value label string like "0 = No, 1 = Yes"
        parts <- str_match_all(val_lab_str, "([^=,]+)=\\s*([^,]+)")[[1]]
        if (nrow(parts) > 0) {
          values <- str_trim(parts[, 2])
          labels <- str_trim(parts[, 3])
          # Convert to numeric if values are numeric
          if (all(grepl("^\\d+$", values))) {
            values <- as.integer(values)
          }
          val_labels(data[[var]]) <- setNames(labels, values)
        }
      }
    }
  }

  return(data)
}
