#' Check and Correct Common Email Syntax and Domain Typos
#'
#' This function detects and optionally corrects common email syntax issues
#' and misspellings in popular domains (e.g., Gmail, Yahoo, Hotmail, Outlook),
#' as well as certain top-level domain (TLD) errors. It can return flags,
#' reasons for invalidity, corrected email addresses, or a log of corrections.
#'
#' @param email_vec A character vector of email addresses to check.
#' @param return Character string indicating what to return. Must be one of:
#'   \itemize{
#'     \item \code{"flag"} — Logical vector indicating whether the email
#'     fails basic pre-correction checks.
#'     \item \code{"reason"} — Character vector describing the reason(s)
#'     for the failure (e.g., whitespace, double '@', domain typos, invalid format).
#'     \item \code{"corrected"} — Corrected email addresses if auto-corrections
#'     were applied, otherwise \code{NA}.
#'     \item \code{"log"} — Character vector logging the specific corrections applied.
#'   }
#'   Defaults to \code{"flag"}.
#' @param remove_spaces Logical, whether to remove spaces before correction.
#'   Defaults to \code{TRUE}.
#' @param lowercase Logical, whether to convert email addresses to lowercase
#'   before correction. Defaults to \code{TRUE}.
#' @param fix_spelling Logical, whether to attempt spelling corrections
#'   for known domain and TLD typos. Defaults to \code{TRUE}.
#'
#' @details
#' The function performs the following steps:
#' \enumerate{
#'   \item \strong{Pre-correction checks}: Flags parentheses, double dots,
#'   adjacent multiple `@` signs, two `@` signs anywhere, known domain typos
#'   for Gmail / Hotmail / Yahoo / Outlook, the `mailcom` typo, common TLD
#'   typos (e.g. `.vom`, `.con`, `,com`), and any address that does not match
#'   a basic email regex. The `invalid_format_pre` reason is suppressed when
#'   the only problem is a major-provider domain missing its TLD
#'   (e.g. `user@gmail`).
#'   \item \strong{Corrections}: Optionally trims spaces and lowercases, then
#'   applies sequential regex replacements anchored to the domain portion to
#'   remove invalid characters, fix domain spelling mistakes, and correct
#'   common TLD errors (e.g., ".vom" → ".com").
#'   \item \strong{Post-correction cleanup}: Collapses double dots and trims
#'   leading or trailing dots from the email.
#' }
#'
#' Domain corrections are anchored to the domain portion of the email
#' (using lookbehinds/lookaheads) to avoid false positives.
#'
#' @return Depending on the value of \code{return}:
#'   \itemize{
#'     \item \code{"flag"} — Logical vector.
#'     \item \code{"reason"} — Character vector.
#'     \item \code{"corrected"} — Character vector (with \code{NA} where no correction applied).
#'     \item \code{"log"} — Character vector (with \code{NA} where no correction applied).
#'   }
#'
#' @examples
#' emails <- c("john.doe@gamil.com", " jane_doe @hotmail,com ", "valid@example.org")
#'
#' # Flag invalid emails
#' check_email_syntax(emails, return = "flag")
#'
#' # Get reasons for invalidity
#' check_email_syntax(emails, return = "reason")
#'
#' # Get corrected addresses
#' check_email_syntax(emails, return = "corrected")
#'
#' # Get a log of applied corrections
#' check_email_syntax(emails, return = "log")
#'
#' @importFrom stringr str_detect str_replace str_replace_all str_to_lower
#' @importFrom purrr pmap_chr
#'
#' @export
check_email_syntax <- function(
    email_vec,
    return = c("flag", "reason", "corrected", "log"),
    remove_spaces = TRUE,
    lowercase = TRUE,
    fix_spelling = TRUE) {
  return <- match.arg(return)

  # --- Corrections (anchored to domain or end-of-string) ---
  corrections <- c(
    # General cleanup
    "\\(" = "",
    "\\)" = "",
    "\\.\\." = ".",

    # Gmail
    "(?<=@)gamil(?=\\.|$)" = "gmail",
    "(?<=@)gmal(?=\\.|$)" = "gmail",
    "(?<=@)gmial(?=\\.|$)" = "gmail",
    "(?<=@)gnail(?=\\.|$)" = "gmail",
    "(?<=@)gmaill(?=\\.|$)" = "gmail",

    # Yahoo
    "(?<=@)yaoo(?=\\.|$)" = "yahoo",
    "(?<=@)yahou(?=\\.|$)" = "yahoo",
    "(?<=@)yahooo(?=\\.|$)" = "yahoo",
    "(?<=@)yahho(?=\\.|$)" = "yahoo",
    "(?<=@)yhoo(?=\\.|$)" = "yahoo",

    # Hotmail
    "(?<=@)hotnail(?=\\.|$)" = "hotmail",
    "(?<=@)hotmai(?=\\.|$)" = "hotmail",
    "(?<=@)hotmal(?=\\.|$)" = "hotmail",
    "(?<=@)hotmial(?=\\.|$)" = "hotmail",
    "(?<=@)homail(?=\\.|$)" = "hotmail",

    # Outlook
    "(?<=@)outlok(?=\\.|$)" = "outlook",
    "(?<=@)outloo(?=\\.|$)" = "outlook",
    "(?<=@)outllok(?=\\.|$)" = "outlook",

    # Mail.com (full domain)
    "(?<=@)mailcom$" = "mail.com",

    # Fix double @
    "@{2,}" = "@", # collapse double (or more) '@' to a single '@'

    # Add .com when major provider domain lacks TLD
    "(?<=@)gmail$" = "gmail.com",
    "(?<=@)yahoo$" = "yahoo.com",
    "(?<=@)outlook$" = "outlook.com",
    "(?<=@)hotmail$" = "hotmail.com",

    # TLD fixes
    "\\.con$" = ".com",
    "\\.vom$" = ".com",
    "\\.coom$" = ".com",
    "\\.cim$" = ".com",
    "\\.cmo$" = ".com",
    "\\.comm$" = ".com",
    "\\.comn$" = ".com",
    "\\.noo$" = ".no",
    "\\.nno$" = ".no",
    "\\.ogr$" = ".org",
    "\\.og$" = ".org",
    "\\-no$" = ".no",
    "\\-com$" = ".com",
    ",com$" = ".com",
    ",no$" = ".no",
    ",org$" = ".org"
  )

  # --- Pre-correction typo detection ---
  gmail_typos <- c(
    "^gamil(\\.|$)", "^gmal(\\.|$)", "^gmial(\\.|$)", "^gnail(\\.|$)", "^gmaill(\\.|$)"
  )
  other_typos <- c(
    # Hotmail family
    "^hotnail(\\.|$)", "^hotmai(\\.|$)", "^hotmal(\\.|$)", "^hotmial(\\.|$)", "^homail(\\.|$)",
    # Yahoo family
    "^yaoo(\\.|$)", "^yahou(\\.|$)", "^yahooo(\\.|$)", "^yahho(\\.|$)", "^yhoo(\\.|$)",
    # Outlook family
    "^outlok(\\.|$)", "^outloo(\\.|$)", "^outllok(\\.|$)",
    # Missing TLD on major providers (treat as "other_domain_typo")
    "^gmail$", "^yahoo$", "^outlook$", "^hotmail$"
  )

  # Basic email regex
  basic_regex <- "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"

  # -------- PRE-CORRECTION checks --------
  orig <- email_vec
  email_lower <- str_to_lower(orig)

  # General cleanup issues that you later correct
  has_parentheses <- str_detect(email_lower, "[()]")
  has_double_dot  <- str_detect(email_lower, "\\.\\.")
  has_multi_at    <- str_detect(email_lower, "@{2,}")     # adjacent multiple '@'

  # Two @ with anything between (you already had this)
  has_double_at   <- str_detect(orig, "@.*@")

  # Invalid full-format (missing TLD, etc.)
  invalid_format_pre <- !str_detect(orig, basic_regex)

  # Domain-only view (lowercased)
  domain_pre <- ifelse(
    str_detect(orig, "@"),
    str_replace(email_lower, "^[^@]+@", ""),
    email_lower
  )

  # Domain typo families
  gmail_typo_pre <- str_detect(domain_pre, paste0(gmail_typos, collapse = "|"))
  other_typo_pre <- str_detect(domain_pre, paste0(other_typos, collapse = "|"))

  # Specific domain miss w/ dot (mail.com fix)
  mailcom_typo <- str_detect(domain_pre, "^mailcom$")

  # TLD typos that you correct later
  tld_typo_patterns <- c(
    "\\.con$", "\\.vom$", "\\.coom$", "\\.cim$", "\\.cmo$", "\\.comm$", "\\.comn$",
    "\\.noo$", "\\.nno$", "\\.ogr$", "\\.og$", "\\-no$", "\\-com$",
    ",com$", ",no$", ",org$"
  )
  has_tld_typo <- str_detect(email_lower, paste0(tld_typo_patterns, collapse = "|"))

  # Is the domain exactly one of the majors and missing a TLD?
  missing_tld_major <- str_detect(domain_pre, "^(gmail|yahoo|outlook|hotmail)$")

  # Build reasons (suppress "invalid_format_pre" when ONLY missing-TLD-major)
  reasons_pre <- pmap_chr(
    list(has_parentheses, has_double_dot, has_multi_at, has_double_at,
         gmail_typo_pre, other_typo_pre, mailcom_typo, has_tld_typo,
         invalid_format_pre, missing_tld_major),
    function(paren, ddot, mat, dat,
             gtypo, otypo, mailcom, tldtypo,
             inv_pre, missing_major) {
      r <- character(0)
      if (paren)  r <- c(r, "has_parentheses")
      if (ddot)   r <- c(r, "has_double_dot")
      if (mat)    r <- c(r, "has_multi_at")        # '@@' etc.
      if (dat)    r <- c(r, "has_double_at")       # two '@' anywhere
      if (gtypo)  r <- c(r, "gmail_typo")
      if (otypo)  r <- c(r, "other_domain_typo")
      if (mailcom) r <- c(r, "mailcom_typo")
      if (tldtypo) r <- c(r, "tld_typo")

      # Only-missing-TLD-major suppression of invalid_format_pre
      only_missing_tld <- missing_major &&
        !paren && !ddot && !mat && !dat &&
        !gtypo && otypo && !mailcom && !tldtypo && inv_pre

      if (inv_pre && !only_missing_tld) {
        r <- c(r, "invalid_format_pre")
      }
      if (length(r) == 0) "" else paste(unique(r), collapse = ", ")
    }
  )
  # # --- Pre-correction typo detection ---
  # gmail_typos <- c(
  #   "^gamil(\\.|$)", "^gmal(\\.|$)", "^gmial(\\.|$)", "^gnail(\\.|$)", "^gmaill(\\.|$)"
  # )
  # other_typos <- c(
  #   "^hotnail(\\.|$)", "^hotmai(\\.|$)", "^hotmal(\\.|$)", "^hotmial(\\.|$)", "^homail(\\.|$)",
  #   "^yaoo(\\.|$)", "^yahou(\\.|$)", "^yahooo(\\.|$)", "^yahho(\\.|$)", "^yhoo(\\.|$)",
  #   "^outlok(\\.|$)", "^outloo(\\.|$)", "^outllok(\\.|$)",
  #   # Missing TLD on major providers (treat as "other_domain_typo")
  #   "^gmail$",
  #   "^yahoo$",
  #   "^outlook$",
  #   "^hotmail$"
  # )
  #
  # # Basic email regex
  # basic_regex <- "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
  #
  # # -------- PRE-CORRECTION checks --------
  # orig <- email_vec
  # has_whitespace <- str_detect(orig, "\\s")
  # has_double_at <- str_detect(orig, "@.*@")
  # invalid_format_pre <- !str_detect(orig, basic_regex)
  #
  # domain_pre <- ifelse(
  #   str_detect(orig, "@"),
  #   str_replace(str_to_lower(orig), "^[^@]+@", ""),
  #   str_to_lower(orig)
  # )
  # gmail_typo_pre <- str_detect(domain_pre, paste0(gmail_typos, collapse = "|"))
  # other_typo_pre <- str_detect(domain_pre, paste0(other_typos, collapse = "|"))
  # # Is the domain exactly one of the majors and missing a TLD?
  # missing_tld_major <- str_detect(domain_pre, "^(gmail|yahoo|outlook|hotmail)$")
  #
  # reasons_pre <- pmap_chr(
  #   list(has_whitespace, has_double_at, gmail_typo_pre, other_typo_pre, invalid_format_pre, missing_tld_major),
  #   function(ws, dbl, gtypo, otypo, inv_pre, missing_major) {
  #     r <- character(0)
  #     if (ws) r <- c(r, "has_whitespace")
  #     if (dbl) r <- c(r, "has_double_at")
  #     if (gtypo) r <- c(r, "gmail_typo")
  #     if (otypo) r <- c(r, "other_domain_typo")
  #
  #     # Suppress "invalid_format_pre" when the ONLY problem is a missing TLD on a major provider
  #     only_missing_tld <- missing_major &&
  #       !ws && !dbl && !gtypo && otypo && inv_pre
  #
  #     if (inv_pre && !only_missing_tld) {
  #       r <- c(r, "invalid_format_pre")
  #     }
  #     if (length(r) == 0) "" else paste(unique(r), collapse = ", ")
  #   }
  # )

  # reasons_pre <- pmap_chr(
  #   list(has_whitespace, has_double_at, gmail_typo_pre, other_typo_pre, invalid_format_pre),
  #   function(ws, dbl, gtypo, otypo, inv_pre) {
  #     r <- character(0)
  #     if (ws)     r <- c(r, "has_whitespace")
  #     if (dbl)    r <- c(r, "has_double_at")
  #     if (gtypo)  r <- c(r, "gmail_typo")
  #     if (otypo)  r <- c(r, "other_domain_typo")
  #     if (inv_pre) r <- c(r, "invalid_format_pre")
  #     if (length(r) == 0) "" else paste(unique(r), collapse = ", ")
  #   }
  # )

  # -------- CORRECTION pipeline --------
  corrected <- orig
  if (remove_spaces) corrected <- str_replace_all(corrected, " ", "")
  if (lowercase) corrected <- str_to_lower(corrected)

  log_vec <- rep("", length(orig))

  if (fix_spelling) {
    for (pat in names(corrections)) {
      repl <- corrections[[pat]]
      new_val <- str_replace_all(corrected, pat, repl)
      changed <- new_val != corrected
      if (any(changed, na.rm = TRUE)) {
        log_vec[changed] <- paste0(
          ifelse(log_vec[changed] != "", paste0(log_vec[changed], "; "), ""),
          pat, " -> ", repl
        )
      }
      corrected <- new_val
    }
  }

  corrected <- str_replace_all(corrected, "\\.\\.", ".")
  corrected <- str_replace(corrected, "^\\.", "")
  corrected <- str_replace(corrected, "\\.$", "")

  auto_corrected <- !is.na(orig) & !is.na(corrected) & (corrected != orig)

  # -------- RETURN --------
  if (return == "reason") {
    return(reasons_pre)
  } else if (return == "flag") {
    flagged_pre <- has_parentheses | has_double_dot | has_multi_at | has_double_at |
      gmail_typo_pre | other_typo_pre | mailcom_typo | has_tld_typo |
      invalid_format_pre
    # flagged_pre <- has_whitespace | has_double_at | gmail_typo_pre | other_typo_pre | invalid_format_pre
    return(flagged_pre %in% TRUE)
  } else if (return == "corrected") {
    return(ifelse(auto_corrected, corrected, NA_character_))
  } else if (return == "log") {
    return(ifelse(log_vec == "", NA_character_, log_vec))
  }
}
