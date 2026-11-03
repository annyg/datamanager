test_that("VARIABLE LABELS and multi-line VALUE LABELS blocks are parsed", {
  path <- tempfile(fileext = ".sps")
  writeLines(c(
    "VARIABLE LABELS sex 'Sex of respondent'.",
    "VARIABLE LABELS age 'Age in years'.",
    "VARIABLE LABELS region 'Home region'.",
    "",
    "VALUE LABELS sex",
    "  1 'Male'",
    "  2 'Female'.",
    "VALUE LABELS region",
    "  'N' 'North'",
    "  'S' 'South'."
  ), path)

  out <- parse_spss_syntax(path)

  expect_equal(out$var_name, c("sex", "age", "region"))
  expect_equal(out$var_label, c("Sex of respondent", "Age in years", "Home region"))
  expect_equal(out$val_labels, c("1 = Male, 2 = Female", NA, "'N' = North, 'S' = South"))
})

