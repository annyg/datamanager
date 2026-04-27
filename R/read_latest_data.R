#' Read the most recent qs file written by `export_results_for_research()`
#'
#' Locates the most recent dated subdirectory of the form
#' `<results_directory>_<YYYY-MM-DD>` under `results_directory_location`,
#' finds the most recent `<results_filename>_<YYYY-MM-DD>.qs` inside it, and
#' loads it via [qs::qread()]. This is the companion reader for
#' [export_results_for_research()] when `write_as_qs = TRUE`.
#'
#' @param results_directory_location Character. Path containing the dated
#'   results subdirectories.
#' @param results_directory Character. Prefix of the results subdirectory
#'   name (without the trailing `_YYYY-MM-DD`).
#' @param results_filename Character. Prefix of the qs file name (without
#'   the trailing `_YYYY-MM-DD.qs`).
#'
#' @return The data frame stored in the most recent matching `.qs` file.
#'   Stops with an error if no matching file is found.
#'
#' @seealso [export_results_for_research()].
#'
#' @importFrom dplyr mutate arrange slice pull desc
#' @importFrom tibble as_tibble
#' @importFrom stringr str_detect
#' @importFrom purrr keep
#' @importFrom qs qread
#'
#' @examples
#' \dontrun{
#' latest_data <- read_latest_qs(
#'   results_directory_location = "data/",
#'   results_directory = "folder1",
#'   results_filename = "rawdata"
#' )
#' }
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
