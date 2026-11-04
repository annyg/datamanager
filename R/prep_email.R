#' Preprocess and Clean Email Addresses
#'
#' This function preprocesses email addresses by cleaning and correcting them.
#' It strips invisible characters and common wrappers (e.g. `mailto:` or
#' `Name <user@example.com>`), removes extra spaces, converts text to
#' lowercase, optionally fixes common spelling errors in the domain, and can
#' flag or drop addresses that still do not look valid after cleaning.
#'
#' @param email A character vector (or factor) containing email addresses to
#'   be processed.
#' @param remove_spaces Logical, default is `TRUE`. If `TRUE`, all whitespace
#'   within the email will be removed. Leading and trailing whitespace is
#'   always removed.
#' @param lowercase Logical, default is `TRUE`. If `TRUE`, converts the entire
#'   email address to lowercase.
#' @param fix_spelling Logical, default is `FALSE`. If `TRUE`, corrects common
#'   misspellings in domain names and punctuation issues. Corrections are
#'   anchored to the domain part of the address (the local part before `@` is
#'   never altered by provider typo fixes) and are case-insensitive.
#' @param invalid What to do with addresses that do not match a basic email
#'   pattern after cleaning. One of:
#'   * `"keep"` (default): return them unchanged.
#'   * `"warn"`: return them unchanged, but emit a warning with a count and
#'     a few examples.
#'   * `"na"`: replace them with `NA`.
#'
#' @details
#' The following cleaning is always applied:
#' * Unicode compatibility normalisation (NFKC), so e.g. a full-width `＠`
#'   becomes `@`.
#' * Removal of invisible format characters such as zero-width spaces.
#' * Extraction of the address from `Name <user@example.com>` and removal of
#'   a `mailto:` prefix, surrounding quotes and stray leading/trailing
#'   punctuation.
#' * Empty strings become `NA`.
#'
#' When `fix_spelling = TRUE`, the following corrections are applied:
#' * Removing parentheses and collapsing repeated `@` (`@@` -> `@`).
#' * Ending typos: `.con`, `.vom`, `.cmo`, `,com`, `-com`, ... -> `.com`;
#'   `.noo`/`.nno` -> `.no`; `.ogr`/`.og` -> `.org`; a comma or hyphen
#'   before the final ending -> `.`.
#' * Provider typos directly after `@`: `gamil`, `gmal`, ... -> `gmail`;
#'   `yaoo`, `yahou`, ... -> `yahoo`; `hotnail`, `homail`, ... -> `hotmail`;
#'   `outlok`, ... -> `outlook`; `mailcom` -> `mail.com`.
#' * Adding `.com` when a major provider lacks an ending (`user@gmail`).
#' * Collapsing repeated dots and removing dots at the start/end of the
#'   address and next to `@`.
#'
#' An address is considered valid when it has exactly one `@`, a local part
#' made of letters, digits and `._%+'-` without leading, trailing or
#' repeated dots, and a domain with at least one dot and a final ending of
#' two or more letters.
#'
#' @return A character vector with preprocessed and cleaned email addresses,
#'   the same length as `email`.
#'
#' @seealso [check_email_syntax()] for a checker that can return flags,
#'   reasons, corrected addresses, or a correction log; and
#'   [clean_and_recheck_email()] for the data-frame-level wrapper.
#'
#' @examples
#' prep_email(" Example.email @gamil.com ", TRUE, TRUE, TRUE)
#' prep_email("user@homail.com", fix_spelling = TRUE)
#' prep_email("Ola Nordmann <ola@hotmail,com>", fix_spelling = TRUE)
#' prep_email(c("ok@example.com", "not-an-email"), invalid = "na")
#'
#' @importFrom stringr str_replace_all str_to_lower str_trim
#'   str_detect str_match str_remove_all regex
#' @importFrom stringi stri_trans_nfkc
#' @export
#'
prep_email <- function(email,
                       remove_spaces = TRUE,
                       lowercase = TRUE,
                       fix_spelling = FALSE,
                       invalid = c("keep", "warn", "na")) {
  invalid <- match.arg(invalid)

  if (is.factor(email)) email <- as.character(email)
  if (!is.character(email)) {
    if (all(is.na(email))) {
      email <- as.character(email)
    } else {
      stop("`email` must be a character vector or factor.", call. = FALSE)
    }
  }

  # --- Always-on cleanup -------------------------------------------------
  email <- stri_trans_nfkc(email)
  email <- str_remove_all(email, "\\p{Cf}") # zero-width spaces, BOM, etc.
  email <- str_trim(email)

  # "Name <user@example.com>" -> "user@example.com"
  bracketed <- str_match(email, "<\\s*([^<>\\s]+@[^<>\\s]+)\\s*>")[, 2]
  email <- ifelse(is.na(bracketed), email, bracketed)

  email <- str_remove_all(email, regex("^mailto:", ignore_case = TRUE))
  # Stray quotes/brackets/punctuation at either end
  email <- str_remove_all(email, "^[\\s\"'<>;:,]+|[\\s\"'<>;:,]+$")

  # --- Spaces / case -------------------------------------------------------
  if (remove_spaces) {
    email <- str_replace_all(email, "\\s+", "")
  }

  if (lowercase) {
    email <- str_to_lower(email)
  }

  # --- Spelling / punctuation fixes ---------------------------------------
  if (fix_spelling) {
    email <- apply_email_corrections(email)
  }

  email[!is.na(email) & email == ""] <- NA_character_

  # --- Validity check -----------------------------------------------------
  if (invalid != "keep") {
    bad <- !is.na(email) & !is_valid_email(email)
    if (any(bad)) {
      if (invalid == "warn") {
        examples <- unique(email[bad])
        examples <- examples[seq_len(min(3, length(examples)))]
        warning(
          sprintf(
            "%d of %d email address(es) do not look valid after cleaning, e.g. %s",
            sum(bad), sum(!is.na(email)),
            paste0("'", examples, "'", collapse = ", ")
          ),
          call. = FALSE
        )
      } else {
        email[bad] <- NA_character_
      }
    }
  }

  email
}

# Ordered list of (pattern -> replacement) corrections used by prep_email().
# Order matters: punctuation/ending fixes run before provider typos so that
# e.g. "gamil,com" becomes "gamil.com" and then "gmail.com".
.email_corrections <- c(
  # Junk characters
  "[()]" = "",
  "@{2,}" = "@",

  # Ending (TLD) typos
  "[.,-](con|vom|xom|cpm|cmo|cim|coom|comm|comn|ocm)$" = ".com",
  "\\.(noo|nno|n0)$" = ".no",
  "\\.(ogr|og|orgg)$" = ".org",
  "(?<=@[^@]{1,250})-(?=(com|no|org|net|se|dk)$)" = ".",
  ",(?=[a-z]{2,6}$)" = ".",

  # Provider typos, anchored right after '@' and before '.' or end
  "(?<=@)(gamil|gmal|gmial|gnail|gmaill|gmali|gmil)(?=\\.|$)" = "gmail",
  "(?<=@)(yaoo|yahou|yahooo|yahho|yhoo)(?=\\.|$)" = "yahoo",
  "(?<=@)(hotnail|homail|hotmial|hotmai|hotmal|hotmaill|hptmail)(?=\\.|$)" = "hotmail",
  "(?<=@)(outlok|outloo|outllok)(?=\\.|$)" = "outlook",
  "(?<=@)mailcom$" = "mail.com",

  # Major provider without an ending
  "(?<=@)(gmail|yahoo|hotmail|outlook)$" = "\\1.com",

  # Dot cleanup
  "\\.{2,}" = ".",
  "^\\.+|\\.+$" = "",
  "\\.+(?=@)" = "",
  "(?<=@)\\.+" = ""
)

apply_email_corrections <- function(email) {
  for (i in seq_along(.email_corrections)) {
    email <- str_replace_all(
      email,
      regex(names(.email_corrections)[i], ignore_case = TRUE),
      .email_corrections[[i]]
    )
  }
  email
}

is_valid_email <- function(email) {
  local <- "[A-Za-z0-9_%+'-]+(\\.[A-Za-z0-9_%+'-]+)*"
  domain <- "([A-Za-z0-9]([A-Za-z0-9-]*[A-Za-z0-9])?\\.)+[A-Za-z]{2,}"
  str_detect(email, paste0("^", local, "@", domain, "$"))
}
