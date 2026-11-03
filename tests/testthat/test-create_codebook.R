make_df <- function() {
  df <- data.frame(
    grp = c(rep("a", 6), rep("b", 4)),
    level = c(1, 1, 2, 2, 2, 3, 3, 3, 3, NA),
    visit = as.Date("2024-01-01") + 0:9,
    stamp = as.POSIXct("2024-05-01 12:00", tz = "UTC") + 86400 * c(0:8, NA),
    comment = paste("free text answer", 1:10),
    stringsAsFactors = FALSE
  )
  labelled::var_label(df$grp) <- "Group"
  df
}

row_for <- function(book, var) book[book$varname == var, , drop = FALSE]

test_that("returns one row per variable with label and type", {
  book <- create_codebook(make_df())

  expect_setequal(book$varname, c("grp", "level", "visit", "stamp", "comment"))
  expect_equal(row_for(book, "grp")$varlabel, "Group")
  expect_equal(row_for(book, "grp")$vartype, "character")
  expect_equal(row_for(book, "visit")$vartype, "Date")
})

test_that("frequencies list each value with its count", {
  book <- create_codebook(make_df())

  expect_equal(row_for(book, "grp")$valfreqs, "a: 6\nb: 4")
  expect_equal(row_for(book, "level")$valfreqs, "1: 2\n2: 3\n3: 4\nNA: 1")
})

test_that("Date and POSIXct columns are summarised as a range", {
  book <- create_codebook(make_df())

  expect_equal(row_for(book, "visit")$valfreqs, "2024-01-01 -- 2024-01-10")
  expect_equal(row_for(book, "stamp")$valfreqs, "2024-05-01 -- 2024-05-09")
})

test_that("mostly-unique text columns are redacted", {
  book <- create_codebook(make_df())

  expect_equal(row_for(book, "comment")$valfreqs, "Free text (redacted)")
  # Low-cardinality text is not treated as free text
  expect_false(row_for(book, "grp")$valfreqs == "Free text (redacted)")
})

test_that("masking can be turned off", {
  book <- create_codebook(make_df(), mask_dates = FALSE, mask_free_text = FALSE)

  expect_match(row_for(book, "visit")$valfreqs, "2024-01-05: 1", fixed = TRUE)
  expect_match(row_for(book, "comment")$valfreqs, "free text answer 1: 1", fixed = TRUE)
})

test_that("free-text detection respects the minimum sample size", {
  df <- make_df()[1:5, ]
  book <- create_codebook(df)

  expect_false(row_for(book, "comment")$valfreqs == "Free text (redacted)")
  book <- create_codebook(df, free_text_min_n = 5L)
  expect_equal(row_for(book, "comment")$valfreqs, "Free text (redacted)")
})
