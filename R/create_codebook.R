#' Create a codebook for the provided data
#'
#' Builds a codebook table joining each variable's name, attached
#' [labelled::var_label()], R class, and a newline-separated list of
#' value frequencies (only for variables with fewer than 100 unique values).
#'
#' Two redaction defaults are applied to keep potentially identifying
#' information out of the codebook:
#' * **Date / datetime columns** are summarised as `"YYYY-MM-DD — YYYY-MM-DD"`
#'   (the observed min / max) rather than enumerating every unique date.
#' * **Free-text columns** — character or factor columns whose non-NA values
#'   are mostly distinct — are replaced with the literal `"Free text (redacted)"`.
#'
#' Both behaviours can be turned off or tuned via arguments.
#'
#' @param data A data frame, ideally with [labelled::var_label()] attributes
#'   set on its columns.
#' @param mask_dates Logical. If `TRUE` (default), date / POSIXct columns are
#'   replaced with their observed min/max range. Set to `FALSE` to fall back
#'   to the raw frequency table.
#' @param mask_free_text Logical. If `TRUE` (default), character / factor
#'   columns whose non-NA values are mostly distinct (see
#'   `free_text_threshold`) are redacted.
#' @param free_text_threshold Numeric in `(0, 1]`. Uniqueness ratio
#'   (`n_distinct(x) / n_non_na`) at or above which a character / factor
#'   column is flagged as free text. Defaults to `0.9`.
#' @param free_text_min_n Integer. Minimum number of non-NA values required
#'   before the uniqueness ratio is considered meaningful. Defaults to `10`
#'   so tiny datasets do not produce spurious free-text flags.
#'
#' @return A data frame with one row per variable and the columns
#'   `varname`, `varlabel`, `valfreqs`, and `vartype`.
#'
#' @examples
#' \dontrun{
#' create_codebook(mtcars)
#' }
#'
#' @importFrom questionr freq
#' @importFrom tibble enframe rownames_to_column
#' @importFrom dplyr rename mutate group_by row_number select full_join case_when across
#' @importFrom tidyr spread unite
#' @importFrom purrr keep
#' @importFrom labelled var_label
#'
#' @export
create_codebook <- function(data,
                            mask_dates = TRUE,
                            mask_free_text = TRUE,
                            free_text_threshold = 0.9,
                            free_text_min_n = 10L) {
  # Identify date / datetime columns up-front via inherits() rather than
  # string-matching a deparsed class vector later — POSIXct columns have
  # class c("POSIXct", "POSIXt"), which previous string-comparison logic
  # failed to detect.
  date_vars <- names(data)[vapply(
    data, inherits, logical(1), what = c("Date", "POSIXt")
  )]

  # For each date column, summarise to a "min — max" range string. Avoids
  # enumerating every unique date in the codebook (privacy + readability).
  date_summaries <- vapply(data[date_vars], function(x) {
    if (all(is.na(x))) return("(no dates)")
    rng <- range(x, na.rm = TRUE)
    paste(format(rng, "%Y-%m-%d"), collapse = " — ")
  }, character(1))

  # Heuristically flag free-text columns: character / factor columns where
  # the non-NA values are mostly distinct AND there are enough non-NA values
  # for the ratio to be meaningful. Open-text answers often contain
  # identifying details and should not be dumped into the codebook.
  free_text_vars <- if (mask_free_text) {
    names(data)[vapply(data, function(x) {
      if (!is.character(x) && !is.factor(x)) return(FALSE)
      x_no_na <- x[!is.na(x)]
      n_total <- length(x_no_na)
      if (n_total < free_text_min_n) return(FALSE)
      length(unique(x_no_na)) / n_total >= free_text_threshold
    }, logical(1))]
  } else {
    character()
  }

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
    ungroup() %>%
    mutate(across(-varname, ~ ifelse(is.na(.), "", .))) %>%
    unite("valfreqs", c(2:ncol(.)), sep = "\n") %>%
    mutate(valfreqs = sub("\\s+$", "", valfreqs))

  # Combine variable names, labels, frequencies, and types into a single data frame
  full_join(var_labels, freqs, by = "varname") %>%
    mutate(varlabel = as.character(varlabel)) %>%
    full_join(var_type, by = "varname") %>%
    mutate(vartype = as.character(vartype)) %>%
    mutate(valfreqs = case_when(
      mask_dates & varname %in% date_vars ~ unname(date_summaries[varname]),
      varname %in% free_text_vars ~ "Free text (redacted)",
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
