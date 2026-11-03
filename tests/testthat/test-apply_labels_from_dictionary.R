dict <- data.frame(
  var_name = c("q1", "q2", "missing_var"),
  var_label = c("Smoking status", "Age in years", "Not in data"),
  val_labels = c("0 = No, 1 = Yes", NA, "1 = A"),
  new_name = c("smoker", "age", "unused"),
  stringsAsFactors = FALSE
)
df <- data.frame(q1 = c(0L, 1L, 1L), q2 = c(30, 41, 52), other = c("x", "y", "z"))

test_that("variable labels are applied and unlisted columns are untouched", {
  out <- apply_labels_from_dictionary(df, dict)

  expect_equal(labelled::var_label(out$q1), "Smoking status")
  expect_equal(labelled::var_label(out$q2), "Age in years")
  expect_null(labelled::var_label(out$other))
  expect_named(out, c("q1", "q2", "other"))
})

test_that("empty or missing variable labels are skipped", {
  d <- data.frame(var_name = c("q1", "q2"), var_label = c("", NA))
  out <- apply_labels_from_dictionary(df, d)

  expect_null(labelled::var_label(out$q1))
  expect_null(labelled::var_label(out$q2))
})
