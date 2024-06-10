#' Export Results for Research
#'
#' This function exports the results of a data frame and labelled data for research purposes. It allows you to specify the output formats and generate metadata such as codebooks and dictionaries.
#'
#' @param df The data frame to be processed.
#' @param results_directory The path and name of the results directory (optional, default is "results").
#' @param results_filename The name of the results file (optional, default is "results").
#' @param results_date The date to be appended to the directory and file names (optional, default is Sys.Date()).
#' @param write_as_csv A logical indicating whether to write the results as a CSV file (optional, default is TRUE).
#' @param write_as_excel A logical indicating whether to write the results as an Excel file (optional, default is FALSE).
#' @param write_as_qs A logical indicating whether to write the results as a QS file (optional, default is FALSE).
#' @param write_as_spss A logical indicating whether to write the results as an SPSS file (optional, default is FALSE).
#' @param write_as_stata A logical indicating whether to write the results as a Stata file (optional, default is FALSE).
#' @param write_as_sas A logical indicating whether to write the results as a SAS file (optional, default is FALSE).
#' @param write_dictionary A logical indicating whether to generate a dictionary for the data frame (optional, default is FALSE).
#' @param write_codebook_word A logical indicating whether to generate a Word document codebook for the data frame (optional, default is FALSE).
#' @param write_codebook_html A logical indicating whether to generate an HTML codebook table for the data frame (optional, default is FALSE).
#'
#' @return None
#'
#' @examples
#' # Export results for research
#' export_results_for_research(df = my_data, results_directory = "output", results_filename = "my_results", write_as_csv = TRUE, write_as_excel = TRUE, write_dictionary = TRUE)
#'
export_results_for_research <- function(
    df,
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
    write_codebook_html = FALSE
) {
  # Set the result_directory by concatenating the results_directory, results_date,
  # and a trailing slash ("/") to create a file path for the results directory
  result_directory <- paste0(results_directory,"_", results_date, "/")

  # Create the result_directory by calling the dir.create() function and passing the result_directory
  dir.create(result_directory)

  # Set the result_file by concatenating the results_filename, results_date, and the file extension for each output format
  result_file <- paste0(results_filename,"_", results_date)

  # Write the results to the specified formats ####
  # If write_as_csv is TRUE, export the data frame as a CSV file
  if (write_as_csv) {
    rio::export(df, paste0(result_directory, result_file, ".csv"))
  }

  # If write_as_excel is TRUE, export the data frame as an Excel file
  if (write_as_excel) {
    rio::export(df, paste0(result_directory, result_file, "_excel.xlsx"))
  }

  # If write_as_spss is TRUE, export the data frame as an SPSS file
  if (write_as_spss) {
    rio::export(df, paste0(result_directory, result_file, "_spss.sav"))
  }

  # If write_as_qs is TRUE, export the data frame as a QS file
  if (write_as_qs) {
    rio::export(df, paste0(result_directory, result_file, "_qs.qs"))
  }

  # If write_as_stata is TRUE, export the data frame as a Stata file
  if (write_as_stata) {
    rio::export(df, paste0(result_directory, result_file, "_stata.dta"))
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
    book <- koRonastudytools::create_codebook(df)

    # Create a datatable from the codebook data frame with filtering and pagination options
    full_codebook_table <- datatable(book, filter = "top", options = list(pageLength = 20))

    # Save the datatable as an HTML widget in the result_directory
    htmlwidgets::saveWidget(full_codebook_table, paste0(result_directory, "html_codebook_", result_file, ".html"))
  }

  ## Generate a word document codebook ####
  if (write_codebook_word) {
    # Generate a codebook document using the codebookr package
    bookr <- codebookr::codebook(df)

    # Print the codebook document and save it as a Word document in the result_directory
    print(bookr, paste0(result_directory, "codebook_", result_file, ".docx"))
  }

  ## Generate a data dictionary ####
  if (write_dictionary) {
    # Generate a dictionary from the labelled package for the data frame
    dictionary <- labelled::generate_dictionary(df)

    # Export the dictionary as an Excel file in the result_directory
    rio::export(dictionary, paste0(result_directory, "dictionary_", result_file, ".xlsx"))
  }
}
