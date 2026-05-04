test_that("returns only rows whose grouping key is duplicated", {
  df <- data.frame(
    id = c(1, 1, 2, 3, 3, 3),
    val = letters[1:6]
  )

  out <- check_duplicates(df, id)

  expect_equal(sort(unique(out$id)), c(1, 3))
  expect_equal(nrow(out), 5L)  # two id=1 rows + three id=3 rows
})

test_that("returns zero rows when there are no duplicates", {
  df <- data.frame(id = 1:5, val = letters[1:5])

  out <- check_duplicates(df, id)

  expect_equal(nrow(out), 0L)
})

test_that("supports multi-column grouping keys", {
  df <- data.frame(
    a = c(1, 1, 1, 2, 2),
    b = c("x", "x", "y", "z", "z"),
    val = 1:5
  )

  out <- check_duplicates(df, a, b)

  # only (a=1, b="x") and (a=2, b="z") are duplicated
  expect_equal(nrow(out), 4L)
  expect_false(any(out$b == "y"))
})

test_that("grouping columns appear first in the output", {
  df <- data.frame(extra = 1:4, id = c(1, 1, 2, 2))
  out <- check_duplicates(df, id)
  expect_equal(names(out)[1], "id")
})
