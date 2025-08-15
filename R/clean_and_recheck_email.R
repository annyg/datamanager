#' Clean and Re-check Email Syntax in a Dataset
#'
#' @description
#' Validates and cleans email addresses in bulk datasets by running
#' pre-correction checks, applying known typo and formatting corrections,
#' and then re-checking the results.
#'
#' This is especially useful for datasets containing user-entered emails
#' from forms, surveys, or CRM systems, where common spelling mistakes and
#' formatting issues (e.g., "gamil.com", "hotmail,com", extra spaces) are
#' frequent.
#'
#' @param .data A data frame or tibble containing an email column.
#' @param email_col The unquoted name of the column containing email addresses.
#' @param .append Logical, whether to append the new check columns to the
#'   original dataset (\code{TRUE}, default) or return only the recheck results
#'   (\code{FALSE}).
#' @param ... Additional arguments passed to \code{\link{check_email_syntax}},
#'   such as \code{remove_spaces}, \code{lowercase}, or \code{fix_spelling}.
#'
#' @details
#' This function automates the process of:
#' \enumerate{
#'   \item Running pre-correction checks on email syntax.
#'   \item Applying auto-corrections (if enabled in \code{check_email_syntax}).
#'   \item Logging correction rules applied.
#'   \item Re-running checks on corrected emails to identify any remaining issues.
#' }
#'
#' The output includes the following columns:
#' \describe{
#'   \item{\code{pre_flag}}{Logical: \code{TRUE} if the email failed
#'   pre-correction checks.}
#'   \item{\code{pre_reason}}{Character: Reason(s) for pre-correction flag.}
#'   \item{\code{corrected_email}}{Character: Suggested corrected email
#'   address, or \code{NA} if no correction applied.}
#'   \item{\code{correction_log}}{Character: Log of regex rules applied during
#'   correction, or \code{NA} if no corrections made.}
#'   \item{\code{post_flag}}{Logical: \code{TRUE} if the corrected email still
#'   fails post-correction checks.}
#'   \item{\code{post_reason}}{Character: Reason(s) for post-correction flag.}
#' }
#'
#' If \code{.append = TRUE}, these columns are added to \code{.data}.
#' If \code{.append = FALSE}, a standalone table is returned including
#' the original email column.
#'
#' @return
#' A tibble with either:
#' \itemize{
#'   \item Original dataset plus appended check columns (\code{.append = TRUE}).
#'   \item Only the email column and check results (\code{.append = FALSE}).
#' }
#'
#' @seealso \code{\link{check_email_syntax}}
#'
#' @importFrom rlang enquo as_name
#' @importFrom dplyr pull bind_cols select
#' @importFrom tibble tibble
#'
#' @examples
#' library(dplyr)
#' df <- tibble(id = 1:3,
#'              email = c("john.doe@gamil.com", " valid @hotmail,com ", "ok@example.org"))
#'
#' # Append results to original dataset
#' clean_and_recheck_email(df, email, .append = TRUE)
#'
#' # Return only the recheck table
#' clean_and_recheck_email(df, email, .append = FALSE)
#'
#' @export
clean_and_recheck_email <- function(.data, email_col, .append = TRUE, ...) {
  # Capture the column name
  email_sym <- enquo(email_col)

  # Extract as vector
  email_vec <- pull(.data, !!email_sym)

  # Pre-correction checks
  pre_flag   <- check_email_syntax(email_vec, return = "flag", ...)
  pre_reason <- check_email_syntax(email_vec, return = "reason", ...)

  # Corrections and logs
  corrected  <- check_email_syntax(email_vec, return = "corrected", ...)
  log_rules  <- check_email_syntax(email_vec, return = "log", ...)

  # Values to re-check
  to_check <- ifelse(!is.na(corrected), corrected, email_vec)

  # Post-correction checks
  post_flag   <- check_email_syntax(to_check, return = "flag", ...)
  post_reason <- check_email_syntax(to_check, return = "reason", ...)

  # Build recheck tibble
  recheck_tbl <- tibble(
    !!as_name(email_sym) := email_vec,
    pre_flag        = pre_flag,
    pre_reason      = pre_reason,
    corrected_email = corrected,
    correction_log  = log_rules,
    post_flag       = post_flag,
    post_reason     = post_reason
  )

  if (.append) {
    # Append new columns to original dataset
    bind_cols(.data, recheck_tbl %>% select(-!!as_name(email_sym)))
  } else {
    # Return only the recheck table with the original email column
    recheck_tbl
  }
}
