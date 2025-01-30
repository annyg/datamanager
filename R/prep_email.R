#' Preprocess and Clean Email Addresses
#'
#' This function preprocesses email addresses by cleaning and correcting them. It removes extra spaces, converts text to lowercase, and fixes common spelling errors typically found in domain names.
#'
#' @param email A character vector containing email addresses to be processed.
#' @param remove_spaces Logical, default is `TRUE`. If `TRUE`, extraneous spaces within the email will be removed.
#' @param lowercase Logical, default is `TRUE`. If `TRUE`, converts the entire email address to lowercase.
#' @param fix_spelling Logical, default is `FALSE`. If `TRUE`, corrects common misspellings in domain names and handles some punctuation issues.
#'
#' Common corrections include:
#' - Replacing `gamil`, `gmal` with `gmail`
#' - Replacing `yaoo`, `yahou`, `yahooo` with `yahoo`
#' - Replacing `hotnail`, `homail`, `hotmial` with `hotmail`
#' - Fixing `.vom` to `.com` and addressing double periods
#'
#' @return A character vector with preprocessed and cleaned email addresses.
#' @examples
#' prep_email(" Example.email @gamil.com ", TRUE, TRUE, TRUE)
#' prep_email("user@homail.com", fix_spelling = TRUE)
#'
#' @export
#'
prep_email <- function(email, remove_spaces = TRUE, lowercase = TRUE, fix_spelling = FALSE) {
  # Spelling errors to be corrected
  corrections <- c(
    # Spacing and punctuation fixes
    # " "="",
    "\\("="",
    "\\)"="",
    # Common domain misspellin corrections
    "gamil"="gmail",
    "gmal"="gmail",
    "yaoo"="yahoo",
    "yahou"="yahoo",
    "yahooo"="yahoo",
    "hotnail"="hotmail",
    "homail"="hotmail",
    "hotmial"="hotmail",
    # Ensure domain endings are correctly formatted
    ".vom"=".com",
    "mailcom"="mail.com",
    # Finally, manage double periods, this should be last to catch any introduced by earlier replacements
    "\\.\\."="."

    # "\\("="",
    # "\\)"="",
    # "gamil"="gmail",
    # "gamil"="gmail",
    # "gmal"="gmail",
    # "hotnail"="hotmail",
    # "yaoo"="yahoo",
    # "yahou"="yahoo",
    # "yaho."="yahoo.",
    # # New fixes added
    # "yahooo"="yahoo",
    # ".vom"=".com",
    # "mailcom"="mail.com",
    # "homail"="hotmail",
    # "hotmial"="hotmail"#,
    # # "..com"=".com",
    # # "..no"=".no"
  )

  # Remove spaces condition
  if (remove_spaces) {
    email <- email %>% str_squish() %>% str_replace_all(c(" "=""))
  }

  # Convert to lowercase condition
  if (lowercase) {
    email <- email %>% str_to_lower()
  }

  # Fix spelling condition
  if (fix_spelling) {
    email <- email %>% str_replace_all(corrections)
  }

  return(email)
}
