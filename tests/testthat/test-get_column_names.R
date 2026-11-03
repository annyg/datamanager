test_that("returns each column name with its character length", {
  out <- get_column_names(data.frame(a = 1, long_name = 2, `x.y` = 3, check.names = FALSE))

  expect_equal(out$columns_names, c("a", "long_name", "x.y"))
  expect_equal(out$column_name_length, c(1L, 9L, 3L))
})
