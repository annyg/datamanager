#' Read the most recent QS file
#'
#' This function reads the most recent file from a specified results directory, matching the given directory and filename prefixes.
#' It complements `export_results_for_research()` by easily accessing the latest dataset.
#'
#' @param results_directory_location A character string specifying the path to the base results directory.
#' @param results_directory A character string specifying the prefix for the results directory (excluding the date).
#' @param results_filename A character string specifying the prefix for the results filename (excluding the date).
#'
#' @return Returns the most recent data loaded from the QS file as a dataframe or an error message if no file is found.
#'
#' @import tidyverse
#' @import qs
#'
#' @examples
#' # Assume your working directory has the folder structure and files
#' results_directory_location <- "data"
#' results_directory <- "folder1"
#' results_filename <- "rawdata"
#' latest_data <- read_latest_qs(results_directory_location, results_directory, results_filename)
#'
read_latest_qs <- function(results_directory_location, results_directory, results_filename) {
  # List subdirectories in the specified location to find recent folders
  folders <- list.dirs(results_directory_location, recursive = FALSE)

  # Filter folders by specified prefix and sort by date
  recent_folder <- folders %>%
    keep(~ str_detect(basename(.), paste0("^", results_directory, "_\\d{4}-\\d{2}-\\d{2}$"))) %>%
    as_tibble() %>%
    mutate(date = as.Date(gsub(paste0("^", results_directory, "_"), "", basename(value)), format = "%Y-%m-%d")) %>%
    arrange(desc(date)) %>%
    slice(1) %>%
    pull(value)

  # List .qs files in the recent folder matching the results filename and sort by date
  files <- list.files(recent_folder, pattern = paste0("^", results_filename, ".*\\.qs$"), full.names = TRUE)
  recent_file <- files %>%
    as_tibble() %>%
    mutate(date = as.Date(gsub(paste0(".*_", results_filename, "_"), "", basename(value)), format = "%Y-%m-%d.qs")) %>%
    arrange(desc(date)) %>%
    slice(1) %>%
    pull(value)

  # Ensure recent_file is a single string value, or return a message if no file is found
  if (length(recent_file) == 1) {
    data <- qread(recent_file)
    return(data)
  } else {
    stop("No suitable file found in specified folder set.")
  }
}
