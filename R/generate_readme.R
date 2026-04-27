#' Generate a README file from the bundled template
#'
#' Writes the package's internal `readme_template` (stored in `R/sysdata.rda`)
#' to a text file at `output_name`. Refuses to clobber an existing file unless
#' `overwrite = TRUE`.
#'
#' @param output_name Character. Path of the README file to create. Defaults
#'   to `"README_template.txt"` in the working directory.
#' @param overwrite Logical. If `TRUE`, an existing file at `output_name` is
#'   replaced. Defaults to `FALSE`.
#'
#' @return Invisibly returns `output_name` when a file is written, or `NULL`
#'   when nothing was written (file already exists and `overwrite = FALSE`).
#' @export
#'
#' @examples
#' \dontrun{
#' generate_readme(output_name = "Project_Readme.txt", overwrite = FALSE)
#' }
generate_readme <- function(output_name = "README_template.txt", overwrite = FALSE) {
  # Check if internal data readme_template is available
  if (!exists("readme_template")) {
    stop("Internal template data is not available.")
  }

  # Check if the output file exists
  if (file.exists(output_name)) {
    if (!overwrite) {
      warning(paste("The file", output_name, "already exists and overwrite is set to FALSE. No changes made."))
      return(invisible(NULL)) # Exit function without doing anything
    } else {
      message(paste("The file", output_name, "already exists and will be overwritten."))
    }
  }

  # Write internal template content to the output file
  writeLines(readme_template, output_name)

  message(sprintf("README file created: %s", output_name))

  return(invisible(output_name))
}
