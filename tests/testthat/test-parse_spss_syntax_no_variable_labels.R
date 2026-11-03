test_that("a file without VARIABLE LABELS returns an empty table", {
  path <- tempfile(fileext = ".sps")
  writeLines(c(
    "VALUE LABELS sex",
    "  1 'Male'",
    "  2 'Female'."
  ), path)

  out <- parse_spss_syntax(path)

  expect_s3_class(out, "data.frame")
  expect_equal(nrow(out), 0L)
  expect_named(out, c("var_name", "var_label", "val_labels"))
  expect_type(out$val_labels, "character")
})
