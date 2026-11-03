#' Convert a textual mapping definition into a long-format data frame
#'
#' Parses a multi-line mapping string of the form used in this package's
#' custom variable definition syntax (variable headers like
#' `Var_name : 'Variable label' <- TYPE :: oldname` followed by indented
#' value rows like `1 = 'Yes' <- 1`) and produces a long-format data frame
#' with one row per variable and one row per value label.
#'
#' Generally [parse_variable_mapping()] (which reads from a file path and
#' returns a wide format with one row per variable) is preferred; this
#' helper exists primarily for inline strings.
#'
#' @param mapping_text Character. The full mapping text (a single string,
#'   typically read from a file).
#'
#' @return A data frame with columns `Variable`, `Label`, and
#'   `Value_Label`. Rows representing the variable header have `NA` in
#'   `Value_Label`; rows representing value labels carry the value in
#'   `Value_Label` and the value's label in `Label`.
#'
#' @seealso [convert_mapping_to_dictionary()] for a list-shaped result,
#'   and [parse_variable_mapping()] for the file-based parser.
#'
#' @export
convert_mapping_to_dataframe <- function(mapping_text) {
  parsed <- parse_mapping_text(mapping_text)

  variables <- character()
  labels <- character()
  value_labels <- character()

  for (var in names(parsed)) {
    variables <- c(variables, var)
    labels <- c(labels, parsed[[var]]$label)
    value_labels <- c(value_labels, NA_character_)

    values <- parsed[[var]]$values
    variables <- c(variables, rep(var, length(values)))
    labels <- c(labels, unlist(values, use.names = FALSE))
    value_labels <- c(value_labels, names(values))
  }

  data.frame(
    Variable = variables,
    Label = labels,
    Value_Label = value_labels,
    stringsAsFactors = FALSE
  )
}

#' Convert a textual mapping definition into a nested dictionary
#'
#' Parses the same mapping syntax as [convert_mapping_to_dataframe()] but
#' returns a nested list keyed by variable name, with each element holding
#' the variable's `label` and a named list of `values` (value → value
#' label).
#'
#' @param mapping_text Character. The full mapping text (a single string,
#'   typically read from a file).
#'
#' @return A named list. Each element corresponds to one variable and has
#'   the structure `list(label = "...", values = list("0" = "No",
#'   "1" = "Yes", ...))`.
#'
#' @seealso [convert_mapping_to_dataframe()],
#'   [parse_variable_mapping()].
#'
#' @export
convert_mapping_to_dictionary <- function(mapping_text) {
  parse_mapping_text(mapping_text)
}

# Shared parser for convert_mapping_to_dataframe() and
# convert_mapping_to_dictionary(). Uses the same header and value patterns as
# parse_variable_mapping():
#   header: name : 'label' [<- TYPE] :: oldname
#   value:  N = 'label' <- code
# Lines matching neither pattern are ignored, as are value lines that appear
# before any header.
#' @noRd
parse_mapping_text <- function(mapping_text) {
  var_pattern <- "^([A-Za-z0-9_]+)\\s*:\\s*'([^']+)'(?:\\s*<-\\s*([A-Z]+))?\\s*::\\s*([A-Za-z0-9_]+)$"
  val_pattern <- "^\\s*(\\d+)\\s*=\\s*'([^']+)'\\s*<-\\s*([A-Za-z0-9_]+|_)\\s*$"

  lines <- trimws(strsplit(mapping_text, "\n")[[1]])
  lines <- lines[lines != ""]

  dict_list <- list()
  current_variable <- NULL

  for (line in lines) {
    header <- regmatches(line, regexec(var_pattern, line, perl = TRUE))[[1]]
    if (length(header) > 0) {
      current_variable <- header[2]
      dict_list[[current_variable]] <- list(label = trimws(header[3]), values = list())
      next
    }

    value <- regmatches(line, regexec(val_pattern, line, perl = TRUE))[[1]]
    if (length(value) > 0 && !is.null(current_variable)) {
      dict_list[[current_variable]]$values[[value[2]]] <- trimws(value[3])
    }
  }

  dict_list
}

# # Example usage
# mapping_text <- "
# Symptoms_elaborate : 'Textual elaboration of symptoms' <- STRING :: symptomer_utdyp
# Infected_elaborate : 'Textual elaboration on how the infection took place' <- STRING :: utdyp_smitte_hvordan
# Country_infected_elaborate : 'Textual elaboration of which country the infection took place' <- STRING :: utdyp_smitte_land
# Hospitalised_elaborate : 'Textual elaboration of the cause of the hospital admission' <- STRING :: innlagt_sykdom
# Date_hospitalized : 'Date of hospitalization' <- DATE :: innlagt_dato
# Other_store : 'Number of visits to other type of store' :: annen_butikk
# 0 = 'Not once in 2 weeks' <- 0
# 1 = '1 - 3 times in 2 weeks' <- 1_2
# 2 = '4 - 10 times in 2 weeks' <- 4_10
# 3 = '11 times or more in 2 weeks' <- 11_pluss
# 999 = 'Missing' <- _
# "
#
# # Get the dictionary
# dictionary <- convert_mapping_to_dictionary(mapping_text)
# print(dictionary)
