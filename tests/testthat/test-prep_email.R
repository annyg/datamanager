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
