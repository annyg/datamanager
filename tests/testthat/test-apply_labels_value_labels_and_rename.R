dict <- data.frame(
  var_name = c("q1", "q2", "q3", "missing_var"),
  var_label = c("Smoking status", "Age group", "Region", "Not in data"),
  val_labels = c("0 = No, 1 = Yes", "1 = Young, 2 = Old", "N = North, S = South", "1 = A"),
  new_name = c("smoker", "age_group", NA, "unused"),
  stringsAsFactors = FALSE
)
df <- data.frame(
  q1 = c(0L, 1L, 1L),
  q2 = c(1, 2, 1),
  q3 = c("N", "S", "N"),
  stringsAsFactors = FALSE
)

test_that("numeric codes become value labels on integer columns", {
  out <- apply_labels_from_dictionary(df, dict, val_label_col = "val_labels")

  expect_equal(labelled::val_labels(out$q1), c(No = 0L, Yes = 1L))
  expect_equal(as.vector(labelled::to_character(out$q1)), c("No", "Yes", "Yes"))
})

test_that("integer-looking codes match double columns", {
  out <- apply_labels_from_dictionary(df, dict, val_label_col = "val_labels")

  expect_equal(labelled::val_labels(out$q2), c(Young = 1, Old = 2))
  expect_equal(as.vector(labelled::to_character(out$q2)), c("Young", "Old", "Young"))
})

test_that("character codes are named by their labels", {
  out <- apply_labels_from_dictionary(df, dict, val_label_col = "val_labels")

  expect_equal(labelled::val_labels(out$q3), c(North = "N", South = "S"))
  expect_equal(as.vector(labelled::to_character(out$q3)), c("North", "South", "North"))
})

test_that("new_var_name_col renames columns and labels them under the new name", {
  out <- apply_labels_from_dictionary(
    df, dict,
    val_label_col = "val_labels",
    new_var_name_col = "new_name"
  )

  # q3 has no new name, so it keeps its name; missing_var is not in data
  expect_named(out, c("smoker", "age_group", "q3"))
  expect_equal(labelled::var_label(out$smoker), "Smoking status")
  expect_equal(labelled::val_labels(out$smoker), c(No = 0L, Yes = 1L))
  expect_equal(labelled::var_label(out$age_group), "Age group")
  expect_equal(labelled::var_label(out$q3), "Region")
  expect_equal(labelled::val_labels(out$q3), c(North = "N", South = "S"))
})

test_that("labelled data round-trips through rio", {
  out <- apply_labels_from_dictionary(
    df, dict,
    val_label_col = "val_labels",
    new_var_name_col = "new_name"
  )
  path <- tempfile(fileext = ".rds")
  rio::export(out, path)
  back <- rio::import(path)

  expect_equal(labelled::val_labels(back$smoker), c(No = 0L, Yes = 1L))
  expect_equal(labelled::var_label(back$q3), "Region")
})
