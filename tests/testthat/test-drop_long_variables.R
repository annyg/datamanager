test_that("variables with names longer than the threshold are dropped", {
  # NOTE: keep at least two short columns. `drop_long_variables()` indexes the
  # data frame without `drop = FALSE`, so a single retained column degrades to
  # a vector. See TODO.md.
  df <- data.frame(a = 1, b = 2, very_long_variable_name = 3)

  out <- suppressMessages(drop_long_variables(df, variable_length = 5))

  expect_named(out$data, c("a", "b"))
  expect_equal(out$message, "very_long_variable_name")
})

test_that("default threshold of 32 keeps typical variable names", {
  df <- data.frame(a = 1, b = 2, c = 3)

  out <- suppressMessages(drop_long_variables(df))

  expect_named(out$data, c("a", "b", "c"))
  expect_length(out$message, 0L)
})

test_that("emits a message listing the dropped variables", {
  df <- data.frame(short = 1, way_too_long = 2)
  expect_message(
    drop_long_variables(df, variable_length = 5),
    "way_too_long"
  )
})

test_that("return value has the documented shape", {
  out <- suppressMessages(drop_long_variables(iris, variable_length = 5))
  expect_named(out, c("data", "message"))
  expect_s3_class(out$data, "data.frame")
  expect_type(out$message, "character")
})
