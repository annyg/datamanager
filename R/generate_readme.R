#' Generate README File from Template
#'
#' This function creates a README file using an embedded template stored as internal data within the package.
#' It ensures not to overwrite an existing file unless explicitly permitted.
#'
#' @param output_name Character. The name of the output README file to create. Defaults to `"README_template.txt"`.
#' @param overwrite Logical. If `TRUE`, allows overwriting the existing file. Defaults to `FALSE`.
#'
#' @return Invisibly returns the name of the created or existing README file.
#' @export
#'
#' @examples
#' generate_readme(output_name = "Project_Readme.txt", overwrite = FALSE)
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
