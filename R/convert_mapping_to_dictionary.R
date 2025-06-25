# Load necessary library
library(dplyr)
library(labelled)

# Define the function to convert mapping to dataframe format
convert_mapping_to_dataframe <- function(mapping_text) {
  # Split the input by lines and filter out empty lines
  lines <- strsplit(mapping_text, "\n")[[1]]
  lines <- lines[lines != ""]

  # Create vectors to hold the components of the final dataframe
  variables <- c()
  labels <- c()
  value_labels <- c()

  current_variable <- NULL

  for (line in lines) {
    # Check for variable definition
    if (grepl(":", line)) {
      # Extract variable name and label
      parts <- unlist(strsplit(line, ":"))
      current_variable <- trimws(parts[1])
      variable_label <- gsub("<-.*", "", parts[1])
      variable_label <- gsub("'", "", variable_label)

      # Store the variable and its label
      variables <- c(variables, current_variable)
      labels <- c(labels, variable_label)
    }

    # Check for value mapping
    if (grepl("<-", line) && !is.null(current_variable)) {
      # Extract value and label
      parts <- unlist(strsplit(line, "<-"))
      value_info <- trimws(parts[1])
      value_label <- gsub(".*=", "", parts[1])
      value <- trimws(gsub(" =.*", "", value_info))
      value_label <- gsub("'", "", value_label)

      # Store the variable, label, and value label
      variables <- c(variables, current_variable)
      labels <- c(labels, value_label)
      value_labels <- c(value_labels, value)
    }
  }

  # Create a dataframe
  result_df <- data.frame(
    Variable = variables,
    Label = labels,
    Value_Label = c(value_labels, rep(NA, length(variables) - length(value_labels))),  # Fill NA for non-value rows
    stringsAsFactors = FALSE
  )

  return(result_df)
}

# Define the function to convert mapping to dictionary format
convert_mapping_to_dictionary <- function(mapping_text) {
  # Split the input by lines and filter out empty lines
  lines <- strsplit(mapping_text, "\n")[[1]]
  lines <- lines[lines != ""]

  # Create a list to hold the dictionaries for each variable
  dict_list <- list()
  current_variable <- NULL

  for (line in lines) {
    # Check for variable definition
    if (grepl(":", line)) {
      # Extract variable name and label
      parts <- unlist(strsplit(line, ":"))
      current_variable <- trimws(parts[1])
      variable_label <- gsub("<-.*", "", parts[1])
      variable_label <- gsub("'", "", variable_label)
      dict_list[[current_variable]] <- list(label = variable_label, values = list())
    }

    # Check for value mapping
    if (grepl("<-", line) && !is.null(current_variable)) {
      # Extract value and label
      parts <- unlist(strsplit(line, "<-"))
      value_info <- trimws(parts[1])
      value_label <- gsub(".*=", "", parts[1])
      value <- trimws(gsub(" =.*", "", value_info))
      value_label <- gsub("'", "", value_label)
      dict_list[[current_variable]]$values[[value]] <- value_label
    }
  }

  return(dict_list)
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
