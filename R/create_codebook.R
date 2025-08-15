#' Create a codebook for the provided data
#'
#' This function generates a codebook containing variable labels, types, and frequency distributions for the input data.
#'
#' @param data The dataset for which to create the codebook
#' @return A data frame containing variable labels, types, and frequency distributions
#'
#' @examples
#' create_codebook(mtcars)
#'
#' @import questionr tibble dplyr stringr
#'
#' @export
create_codebook <- function(data) {
  # Transform variable labels (var_label) into a data frame and rename columns for clearer identification
  var_labels <- as.data.frame(enframe(var_label(data))) %>%
    rename(varname = name, varlabel = value)

  # Transform the variable class/type into a data frame and rename columns for clearer identification
  var_type <- as.data.frame(enframe(lapply(data, class))) %>%
    rename(varname = name, vartype = value)

  # Generate frequencies for each variable, but only retain those with less than 100 unique values to avoid large outputs
  freqs <- lapply(data, function(x) {
    return(questionr::freq(x))
  }) %>%
    keep(function(x) nrow(x) < 100) %>%
    do.call(rbind, .) %>%
    tibble::rownames_to_column(var = "varname_value") %>%
    mutate(
      varname = gsub("(.+?)(\\..*)", "\\1", varname_value),
      value = gsub("^[^.]*.", "", varname_value)
    ) %>%
    group_by(varname) %>%
    mutate(
      npos = row_number(),
      value_n = paste(value, n, sep = ": ")
    ) %>%
    select(varname, value_n, npos) %>%
    spread(npos, value_n) %>%
    mutate_at(across(
      .cols = -varname,
      ~ (ifelse(is.na(.), "", .))
    )) %>% # NEW
    # mutate_at(vars(-varname), funs(ifelse(is.na(.), "", .))) %>% # OLD
    unite("valfreqs", c(2:ncol(.)), sep = "\n") %>%
    mutate(valfreqs = sub("\\s+$", "", valfreqs))

  # Combine variable names, labels, frequencies, and types into a single data frame
  full_join(var_labels, freqs, by = "varname") %>%
    mutate(varlabel = as.character(varlabel)) %>%
    full_join(var_type, by = "varname") %>%
    mutate(vartype = as.character(vartype)) %>%
    mutate(valfreqs = case_when(
      vartype == "c\\(\"POSIXct\", \"POSIXt\"\\)" |
        vartype == "Date" ~ "Dates",
      str_detect(varname, "_elaborate") ~ "Textual elaborations",
      str_detect(varname, "F2_Ignore") ~ "Textual elaborations",
      str_detect(varname, "Sero_rekvirent") ~ "Rekvirent IDs",
      str_detect(varname, "E3_sym_onset_date") ~ "Dates",
      str_detect(varname, "Sero_") ~ "Measured serology",
      str_detect(varname, "vitas_") ~ "Measured dried bloodspots",
      TRUE ~ valfreqs
    ))
}

# Commented version ####
# create_codebook <- function(data) {
#   # Transform variable labels (var_label) into a data frame and rename columns for clearer identification
#   var_labels <- as.data.frame(enframe(var_label(data))) %>%
#     rename(varname = name, varlabel = value)
#
#   # Transform the variable class/type into a data frame and rename columns for clearer identification
#   var_type <- as.data.frame(enframe(lapply(data, class))) %>%
#     rename(varname = name, vartype = value)
#
#   # Generate frequencies for each variable, but only retain those with less than 100 unique values to avoid large outputs
#   freqs <- lapply(data, function(x) { return(questionr::freq(x)) }) %>%
#     keep(function(x) nrow(x) < 100) %>%  # Keep data frames with <100 rows
#     do.call(rbind, .) %>%  # Combine rows from all lists into a single data frame
#     tibble::rownames_to_column(var = "varname_value") %>%
#     mutate(varname = gsub("(.+?)(\\..*)", "\\1", varname_value),  # Extract varname before the "."
#            value = gsub("^[^.]*.","",varname_value)) %>%  # Extract value after the "."
#     group_by(varname) %>%
#     mutate(npos = row_number(),  # Number the rows within each group
#            value_n = paste(value, n, sep = ": ")) %>%  # Combine values and their counts
#     select(varname, value_n, npos) %>%
#     spread(npos, value_n) %>%
#     mutate_at(vars(-varname), funs(ifelse(is.na(.), "", .))) %>%  # Replace NA values with empty strings
#     unite("valfreqs", c(2:ncol(.)), sep = "\n") %>%
#     mutate(valfreqs = sub("\\s+$", "", valfreqs))  # Trim trailing whitespaces in valfreqs
#
#   # Combine variable names, labels, frequencies, and types into a single data frame
#   full_join(var_labels, freqs, by = "varname") %>%
#     mutate(varlabel = as.character(varlabel)) %>%
#     full_join(var_type, by = "varname") %>%
#     mutate(vartype = as.character(vartype)) %>%
#     # Categorize variables by type or content, modifying the 'valfreqs' column based on specific rules
#     mutate(valfreqs = case_when(
#       vartype == "c(\"POSIXct\", \"POSIXt\")" | vartype == "Date" ~ "Dates",
#       str_detect(varname, "_elaborate") ~ "Textual elaborations",
#       str_detect(varname, "F2_Ignore") ~ "Textual elaborations",
#       str_detect(varname, "Sero_rekvirent") ~ "Rekvirent IDs",
#       str_detect(varname, "E3_sym_onset_date") ~ "Dates",
#       str_detect(varname, "Sero_") ~ "Measured serology",
#       str_detect(varname, "vitas_") ~ "Measured dried bloodspots",
#       TRUE ~ valfreqs))  # Default to using the frequency values unless a specific case is met
# }
