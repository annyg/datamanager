test_that("default flags collapse whitespace and lowercase", {
  expect_equal(
    prep_email("  Anders.Nygaard @Gmail.com "),
    "anders.nygaard@gmail.com"
  )
})

test_that("remove_spaces = FALSE preserves internal whitespace", {
  out <- prep_email("a @b.com", remove_spaces = FALSE, lowercase = TRUE)
  expect_match(out, " ")
})

test_that("lowercase = FALSE preserves case", {
  expect_equal(
    prep_email("A@B.com", remove_spaces = TRUE, lowercase = FALSE),
    "A@B.com"
  )
})

test_that("fix_spelling corrects common provider typos", {
  expect_equal(
    prep_email("user@gamil.com", fix_spelling = TRUE),
    "user@gmail.com"
  )
  expect_equal(
    prep_email("user@hotnail.com", fix_spelling = TRUE),
    "user@hotmail.com"
  )
  expect_equal(
    prep_email("user@yaoo.com", fix_spelling = TRUE),
    "user@yahoo.com"
  )
  expect_equal(
    prep_email("user@outlok.com", fix_spelling = TRUE),
    "user@outlook.com"
  )
  expect_equal(
    prep_email("user@mailcom", fix_spelling = TRUE),
    "user@mail.com"
  )
})

test_that("fix_spelling repairs the .vom -> .com TLD typo", {
  expect_equal(
    prep_email("user@example.vom", fix_spelling = TRUE),
    "user@example.com"
  )
})

test_that("fix_spelling = FALSE leaves typos alone", {
  expect_equal(
    prep_email("user@gamil.com", fix_spelling = FALSE),
    "user@gamil.com"
  )
})

test_that("output length matches input length", {
  emails <- c("a@b.com", "c@d.com", NA_character_)
  expect_length(prep_email(emails), length(emails))
})

# --- Regressions: corrections must not touch unrelated text ---------------

test_that(".vom fix does not match arbitrary characters or the local part", {
  expect_equal(prep_email("user@gravom.no", fix_spelling = TRUE), "user@gravom.no")
  expect_equal(prep_email("ivomar@uio.no", fix_spelling = TRUE), "ivomar@uio.no")
})

test_that("provider typos are only fixed in the domain", {
  expect_equal(prep_email("gmalmberg@uio.no", fix_spelling = TRUE), "gmalmberg@uio.no")
  expect_equal(prep_email("gamil@uio.no", fix_spelling = TRUE), "gamil@uio.no")
  expect_equal(prep_email("mailcomputing@x.no", fix_spelling = TRUE), "mailcomputing@x.no")
  expect_equal(prep_email("user@gamilton.no", fix_spelling = TRUE), "user@gamilton.no")
})

test_that("runs of dots are fully collapsed and stray dots removed", {
  expect_equal(prep_email("a...b@x.com", fix_spelling = TRUE), "a.b@x.com")
  expect_equal(prep_email(".user.@.x.com.", fix_spelling = TRUE), "user@x.com")
})

test_that("spelling fixes work when lowercase = FALSE", {
  expect_equal(
    prep_email("User@Gamil.com", lowercase = FALSE, fix_spelling = TRUE),
    "User@gmail.com"
  )
})

# --- New corrections --------------------------------------------------------

test_that("TLD punctuation and spelling typos are fixed", {
  expect_equal(prep_email("user@hotmail,com", fix_spelling = TRUE), "user@hotmail.com")
  expect_equal(prep_email("user@gamil,com", fix_spelling = TRUE), "user@gmail.com")
  expect_equal(prep_email("user@x.con", fix_spelling = TRUE), "user@x.com")
  expect_equal(prep_email("user@x.cmo", fix_spelling = TRUE), "user@x.com")
  expect_equal(prep_email("user@online-no", fix_spelling = TRUE), "user@online.no")
  expect_equal(prep_email("user@uio,no", fix_spelling = TRUE), "user@uio.no")
  expect_equal(prep_email("user@x.ogr", fix_spelling = TRUE), "user@x.org")
})

test_that("double @ is collapsed and major providers get a TLD", {
  expect_equal(prep_email("a@@gmail.com", fix_spelling = TRUE), "a@gmail.com")
  expect_equal(prep_email("user@gmail", fix_spelling = TRUE), "user@gmail.com")
  expect_equal(prep_email("user@gamil", fix_spelling = TRUE), "user@gmail.com")
})

# --- Always-on cleanup ------------------------------------------------------

test_that("wrappers, prefixes and stray punctuation are stripped", {
  expect_equal(prep_email("Ola Nordmann <ola@x.no>"), "ola@x.no")
  expect_equal(prep_email("mailto:ola@x.no"), "ola@x.no")
  expect_equal(prep_email("MAILTO:Ola@X.no"), "ola@x.no")
  expect_equal(prep_email("\"ola@x.no\";"), "ola@x.no")
})

test_that("invisible and full-width characters are normalised", {
  expect_equal(prep_email("ola​@x.no"), "ola@x.no")
  expect_equal(prep_email("﻿ola@x.no"), "ola@x.no")
  expect_equal(prep_email("ola＠x.no"), "ola@x.no")
  expect_equal(prep_email("ola@x.no "), "ola@x.no")
})

test_that("empty strings become NA", {
  expect_equal(prep_email(c("", "   ", NA)), rep(NA_character_, 3))
})

test_that("factors are accepted and non-character input is rejected", {
  expect_equal(prep_email(factor("A@B.com")), "a@b.com")
  expect_equal(prep_email(NA), NA_character_)
  expect_error(prep_email(123), "character")
})

# --- Invalid handling -------------------------------------------------------

invalid_examples <- c(
  "user.gmail.com",   # no @
  "a@b@c.com",        # two @
  "user@example",     # no TLD
  "a@x.no;b@y.no",    # two addresses
  "a@x.no b@y.no",    # two addresses (merged by space removal)
  "åse@x.no",    # non-ASCII local part
  "user@-x.no",       # domain label starts with hyphen
  "user@x.c"          # one-letter TLD
)

test_that("invalid = 'keep' (default) returns addresses unchanged and silently", {
  expect_silent(out <- prep_email(invalid_examples))
  expect_false(anyNA(out))
})

test_that("invalid = 'na' replaces invalid addresses with NA", {
  out <- prep_email(c("ok@example.com", invalid_examples), invalid = "na")
  expect_equal(out[1], "ok@example.com")
  expect_true(all(is.na(out[-1])))
})

test_that("invalid = 'warn' warns with a count but keeps values", {
  expect_warning(
    out <- prep_email(c("ok@example.com", "bad", NA), invalid = "warn"),
    "1 of 2 email"
  )
  expect_equal(out, c("ok@example.com", "bad", NA))
})

test_that("valid addresses pass the validity check", {
  ok <- c(
    "a@b.co", "first.last@uio.no", "o'brien@x.ie", "a+tag@gmail.com",
    "a_b-c@sub.domain-name.org", "x%y@x.museum"
  )
  expect_silent(out <- prep_email(ok, invalid = "warn"))
  expect_equal(out, ok)
})

test_that("corrections can rescue addresses that would otherwise be invalid", {
  expect_equal(
    prep_email("user@hotmail,com", fix_spelling = TRUE, invalid = "na"),
    "user@hotmail.com"
  )
  expect_true(is.na(prep_email("user@hotmail,com", invalid = "na")))
})
