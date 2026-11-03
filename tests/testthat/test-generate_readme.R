test_that("writes the bundled template to the requested path", {
  path <- tempfile(fileext = ".txt")
  on.exit(unlink(path))

  expect_message(out <- generate_readme(path), "README file created")
  expect_equal(out, path)
  expect_true(file.exists(path))
  expect_gt(length(readLines(path)), 0L)
})

test_that("does not overwrite an existing file by default", {
  path <- tempfile(fileext = ".txt")
  on.exit(unlink(path))
  writeLines("keep me", path)

  expect_warning(out <- generate_readme(path), "already exists")
  expect_null(out)
  expect_equal(readLines(path), "keep me")
})

test_that("overwrites an existing file when overwrite = TRUE", {
  path <- tempfile(fileext = ".txt")
  on.exit(unlink(path))
  writeLines("old", path)

  expect_message(
    expect_message(generate_readme(path, overwrite = TRUE), "will be overwritten"),
    "README file created"
  )
  expect_false(identical(readLines(path), "old"))
})
