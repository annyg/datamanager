#' Read the most recent qs file written by `export_results_for_research()`
#'
#' Locates the most recent dated subdirectory of the form
#' `<results_directory>_<YYYY-MM-DD>` under `results_directory_location`,
#' finds the most recent matching `.qs2` or legacy `.qs` file inside it, and
#' loads it (via [qs2::qs_read()] for `.qs2`, or `qs::qread()` for a legacy
#' `.qs` file). This is the companion reader for [export_results_for_research()]
#' when `write_as_qs2 = TRUE` (or the superseded `write_as_qs = TRUE`). When
#' both formats are present for the same date, the `.qs2` file is preferred.
#'
#' @param results_directory_location Character. Path containing the dated
#'   results subdirectories.
#' @param results_directory Character. Prefix of the results subdirectory
#'   name (without the trailing `_YYYY-MM-DD`).
#' @param results_filename Character. Prefix of the qs file name (without
#'   the trailing `_YYYY-MM-DD` and the `.qs2`/`.qs` extension).
#'
#' @return The data frame stored in the most recent matching `.qs2` or `.qs`
#'   file. Stops with an error if no matching file is found.
#'
#' @seealso [export_results_for_research()].
#'
#' @export
#'
#' @importFrom dplyr mutate arrange slice pull desc
#' @importFrom magrittr %>%
#' @importFrom tibble as_tibble
#' @importFrom stringr str_detect str_extract
#' @importFrom purrr keep
#' @importFrom qs2 qs_read
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

  # List qs2/qs files in the recent folder matching the results filename and sort
  # by date. Both the modern .qs2 (qs2::qs_save) and legacy .qs (superseded)
  # extensions are picked up; on a date tie the .qs2 file is preferred.
  files <- list.files(recent_folder, pattern = paste0("^", results_filename, ".*\\.qs2?$"), full.names = TRUE)
  recent_file <- files %>%
    as_tibble() %>%
    mutate(
      date = as.Date(str_extract(basename(value), "\\d{4}-\\d{2}-\\d{2}")),
      is_qs2 = str_detect(value, "\\.qs2$")
    ) %>%
    arrange(desc(date), desc(is_qs2)) %>%
    slice(1) %>%
    pull(value)

  # Ensure recent_file is a single string value, or return a message if no file is found
  if (length(recent_file) == 1) {
    if (grepl("\\.qs2$", recent_file, ignore.case = TRUE)) {
      data <- qs_read(recent_file)
    } else {
      # Legacy .qs file (superseded format) — requires the archived 'qs' package.
      # 'qs' was archived from CRAN (2026-01-17) and is only needed to *read* the
      # old format, so it is not a declared dependency. The package name is held
      # in a variable (and the reader fetched via getExportedValue()) so R CMD
      # check does not flag the archived 'qs' as a missing dependency.
      qs_pkg <- "qs"
      if (!requireNamespace(qs_pkg, quietly = TRUE)) {
        stop(
          "Reading a legacy .qs file requires the 'qs' package, which is not ",
          "installed. It was archived from CRAN on 2026-01-17; install it from ",
          'the archive with remotes::install_version("qs"), or re-export with ',
          "write_as_qs2 = TRUE.",
          call. = FALSE
        )
      }
      qs_qread <- getExportedValue(qs_pkg, "qread")
      data <- qs_qread(recent_file)
    }
    return(data)
  } else {
    stop("No suitable file found in specified folder set.")
  }
}
