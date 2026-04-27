#' Export a labelled data frame in multiple research formats
#'
#' Writes the input data frame to one or more file formats (CSV, Excel, qs,
#' SPSS, Stata, SAS) inside a dated results subdirectory, and optionally
#' generates a data dictionary or a codebook (HTML or Word) alongside the
#' data file. The companion function [read_latest_qs()] reads the qs output
#' produced by this function.
#'
#' @param df The data frame to export.
#' @param results_directory_location Character. Path prefix prepended to the
#'   created results subdirectory. The full output path is
#'   `paste0(results_directory_location, results_directory, "_", results_date, "/")`.
#' @param results_directory Character. Name (prefix) of the results
#'   subdirectory. The current `results_date` is appended to it. Defaults to
#'   `"results"`.
#' @param results_filename Character. Stem of the output file name; the
#'   `results_date` and a format-specific suffix/extension are appended.
#'   Defaults to `"results"`.
#' @param results_date Date or character. Date appended to both the directory
#'   and file names. Defaults to `Sys.Date()`.
#' @param write_as_csv Logical. Write a CSV file. Defaults to `TRUE`.
#' @param write_as_excel Logical. Write an Excel (`.xlsx`) file. Defaults to
#'   `FALSE`.
#' @param write_as_qs Logical. Write a `qs` file. Defaults to `FALSE`.
#' @param write_as_spss Logical. Write an SPSS (`.sav`) file. Defaults to
#'   `FALSE`.
#' @param write_as_stata Logical. Write a Stata (`.dta`) file. Variables with
#'   names longer than 32 characters are dropped (Stata's limit). Defaults to
#'   `FALSE`.
#' @param write_as_sas Logical. Write a SAS file. Defaults to `FALSE`.
#'   *(Currently unused — no SAS export is performed.)*
#' @param write_dictionary Logical. Generate a [labelled::generate_dictionary()]
#'   summary and write it as an Excel file. Defaults to `FALSE`.
#' @param write_codebook_word Logical. Generate a Word codebook via
#'   [codebookr::codebook()]. Defaults to `FALSE`.
#' @param write_codebook_html Logical. Generate an interactive HTML codebook
#'   table from [create_codebook()] saved as an `htmlwidget`. Defaults to
#'   `FALSE`.
#'
#' @return Called for its side effects (files written to disk). Returns
#'   `NULL` invisibly.
#'
#' @seealso [read_latest_qs()], [create_codebook()],
#'   [apply_labels_from_dictionary()].
#'
#' @examples
#' \dontrun{
#' export_results_for_research(
#'   df = my_data,
#'   results_directory_location = "",
#'   results_directory = "output",
#'   results_filename = "my_results",
#'   write_as_csv = TRUE,
#'   write_as_excel = TRUE,
#'   write_dictionary = TRUE
#' )
#' }
#'
export_results_for_research <- function(
    df,
    results_directory_location,
    results_directory = "results",
    results_filename = "results",
    results_date = Sys.Date(),
    write_as_csv = TRUE,
    write_as_excel = FALSE,
    write_as_qs = FALSE,
    write_as_spss = FALSE,
    write_as_stata = FALSE,
    write_as_sas = FALSE,
    write_dictionary = FALSE,
    write_codebook_word = FALSE,
    write_codebook_html = FALSE) {
  # Set the result_directory by concatenating the results_directory, results_date,
  # and a trailing slash ("/") to create a file path for the results directory
  result_directory <- paste0(results_directory, "_", results_date, "/")

  # Create the result_directory by calling the dir.create() function and passing the result_directory
  dir.create(result_directory)

  # Set the result_file by concatenating the results_filename, results_date, and the file extension for each output format
  result_file <- paste0(results_filename, "_", results_date)

  # Write the results to the specified formats ####
  # If write_as_csv is TRUE, export the data frame as a CSV file
  if (write_as_csv) {
    rio::export(df, paste0(results_directory_location, result_directory, result_file, ".csv"))
  }

  # If write_as_excel is TRUE, export the data frame as an Excel file
  if (write_as_excel) {
    rio::export(df, paste0(results_directory_location, result_directory, result_file, "_excel.xlsx"))
  }

  # If write_as_spss is TRUE, export the data frame as an SPSS file
  if (write_as_spss) {
    rio::export(df, paste0(results_directory_location, result_directory, result_file, "_spss.sav"))
  }

  # If write_as_qs is TRUE, export the data frame as a QS file
  if (write_as_qs) {
    rio::export(df, paste0(results_directory_location, result_directory, result_file, "_qs.qs"))
  }

  # If write_as_stata is TRUE, export the data frame as a Stata file
  if (write_as_stata) {
    # rio::export(df, paste0(results_directory_location, result_directory, result_file, "_stata.dta"))
    tryCatch(
      {
        long_var_names <- names(df)[nchar(names(df)) > 32]
        dropped_vars <- names(df)[nchar(names(df)) > 32]
        df_stata_export <- df[, !(nchar(names(df)) > 32)]

        warning(paste("Dropped variables longer than", 32, "characters:", paste(dropped_vars, collapse = ", ")))

        return(list(data = data, message = dropped_vars))

        rio::export(df_stata_export, paste0(results_directory_location, result_directory, result_file, "_stata.dta"))
      },
      error = function(e) {
        warning("Error exporting Stata file:", e$message)
      }
    )
  }



  # Create metadata for the data frame ####

  # Load the required packages for creating and exporting metadata
  library(labelled)
  library(DT)
  library(webshot)

  ## Generate an HTML codebook ####
  if (write_codebook_html) {
    # # Get the column names of the data frame
    # cols <- get_column_names(df)

    # Create a codebook using the koRonastudytools package
    book <- datamanager::create_codebook(df)

    # Create a datatable from the codebook data frame with filtering and pagination options
    full_codebook_table <- DT::datatable(book, filter = "top", options = list(pageLength = 20))

    # Save the datatable as an HTML widget in the result_directory
    htmlwidgets::saveWidget(full_codebook_table, paste0(results_directory_location, result_directory, "html_codebook_", result_file, ".html"))
  }

  ## Generate a word document codebook ####
  if (write_codebook_word) {
    # Generate a codebook document using the codebookr package
    bookr <- codebookr::codebook(df)

    # Print the codebook document and save it as a Word document in the result_directory
    print(bookr, paste0(results_directory_location, result_directory, "codebook_", result_file, ".docx"))
  }

  ## Generate a data dictionary ####
  if (write_dictionary) {
    # Generate a dictionary from the labelled package for the data frame
    dictionary <- labelled::generate_dictionary(df)

    # Export the dictionary as an Excel file in the result_directory
    rio::export(dictionary, paste0(results_directory_location, result_directory, "dictionary_", result_file, ".xlsx"))
  }
}
