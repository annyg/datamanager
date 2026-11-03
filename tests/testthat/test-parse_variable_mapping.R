test_that("variable definitions and value labels are parsed into one row per variable", {
  path <- tempfile(fileext = ".txt")
  writeLines(c(
    "Smoker : 'Smoking status' <- NUMERIC :: royk",
    "  0 = 'No' <- 0",
    "  1 = 'Yes' <- 1",
    "",
    "Visits : 'Number of visits' :: besok",
    "  0 = 'None' <- 0",
    "  1 = '1 - 3 times' <- 1_3",
    "  999 = 'Missing' <- _",
    "Comment : 'Free-text comment' <- STRING :: kommentar"
  ), path)

  out <- parse_variable_mapping(path)

  expect_equal(out$new_var_name, c("Smoker", "Visits", "Comment"))
  expect_equal(out$var_label, c("Smoking status", "Number of visits", "Free-text comment"))
  expect_equal(out$var_format, c("NUMERIC", NA, "STRING"))
  expect_equal(out$old_var_name, c("royk", "besok", "kommentar"))
  expect_equal(
    unname(out$val_labels),
    c("0 = No, 1 = Yes", "0 = None, 1 = 1 - 3 times, 999 = Missing", NA)
  )
})

test_that("value lines before any variable definition are ignored", {
  path <- tempfile(fileext = ".txt")
  writeLines(c(
    "0 = 'Orphan' <- 0",
    "Smoker : 'Smoking status' :: royk"
  ), path)

  out <- parse_variable_mapping(path)

  expect_equal(nrow(out), 1L)
  expect_true(is.na(out$val_labels))
})
