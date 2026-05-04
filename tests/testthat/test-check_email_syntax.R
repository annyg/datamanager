# Indexed fixture: each row is one (kind, email) pair. Indices are referenced by
# the integer column to avoid relying on stringr/purrr preserving vector names.
cases <- data.frame(
  kind = c(
    "valid", "gmail_typo", "yahoo_typo", "hotmail_typo",
    "tld_typo", "double_at", "parens", "missing_tld", "no_at"
  ),
  email = c(
    "user@example.org",
    "user@gamil.com",
    "user@yaoo.com",
    "user@hotnail.com",
    "user@example.vom",
    "a@@b.com",
    "us(er)@example.com",
    "user@gmail",
    "user.example.org"
  ),
  stringsAsFactors = FALSE
)
idx <- function(k) which(cases$kind == k)

test_that("return = 'flag' produces a logical vector of the right length", {
  out <- check_email_syntax(cases$email, return = "flag")
  expect_type(out, "logical")
  expect_length(out, nrow(cases))
})

test_that("a clean address is not flagged", {
  expect_false(check_email_syntax("user@example.org", return = "flag"))
})

test_that("known typos are flagged", {
  flagged <- check_email_syntax(cases$email, return = "flag")
  for (k in c("gmail_typo", "yahoo_typo", "hotmail_typo", "tld_typo",
              "double_at", "parens", "no_at", "missing_tld")) {
    expect_true(flagged[idx(k)], info = k)
  }
})

test_that("return = 'reason' labels the correct typo families", {
  reasons <- check_email_syntax(cases$email, return = "reason")

  expect_match(reasons[idx("gmail_typo")],   "gmail_typo")
  expect_match(reasons[idx("hotmail_typo")], "other_domain_typo")
  expect_match(reasons[idx("yahoo_typo")],   "other_domain_typo")
  expect_match(reasons[idx("tld_typo")],     "tld_typo")
  expect_match(reasons[idx("double_at")],    "has_(multi|double)_at")
  expect_match(reasons[idx("parens")],       "has_parentheses")
  expect_match(reasons[idx("missing_tld")],  "other_domain_typo")
  expect_equal(reasons[idx("valid")], "")
})

test_that("return = 'corrected' fixes domain typos and gives NA for valid input", {
  corrected <- check_email_syntax(cases$email, return = "corrected")

  expect_equal(corrected[idx("gmail_typo")],   "user@gmail.com")
  expect_equal(corrected[idx("yahoo_typo")],   "user@yahoo.com")
  expect_equal(corrected[idx("hotmail_typo")], "user@hotmail.com")
  expect_equal(corrected[idx("tld_typo")],     "user@example.com")
  expect_equal(corrected[idx("missing_tld")],  "user@gmail.com")
  expect_true(is.na(corrected[idx("valid")]))
})

test_that("return = 'log' records which rule fired", {
  logs <- check_email_syntax(cases$email, return = "log")
  expect_match(logs[idx("gmail_typo")], "gamil")
  expect_match(logs[idx("tld_typo")],   "vom")
  expect_true(is.na(logs[idx("valid")]))
})

test_that("an invalid `return` argument is rejected", {
  expect_error(check_email_syntax("a@b.com", return = "nonsense"))
})
