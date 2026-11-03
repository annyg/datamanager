sample_df <- data.frame(id = 1:3, grp = c("a", "b", "c"))

make_results <- function(root, date, value, ext = "qs2") {
  dir <- file.path(root, paste0("results_", date))
  dir.create(dir, recursive = TRUE, showWarnings = FALSE)
  file <- file.path(dir, paste0("results_", date, "_qs2.", ext))
  qs2::qs_save(value, file)
  file
}

test_that("reads the file from the most recent dated results folder", {
  root <- tempfile(); on.exit(unlink(root, recursive = TRUE))
  make_results(root, "2024-01-15", "old")
  make_results(root, "2024-03-01", sample_df)
  make_results(root, "2023-12-31", "older")
  dir.create(file.path(root, "unrelated_2099-01-01"))

  expect_equal(read_latest_qs(root, "results", "results"), sample_df)
})

test_that("prefers .qs2 over legacy .qs when both share a date", {
  root <- tempfile(); on.exit(unlink(root, recursive = TRUE))
  qs2_file <- make_results(root, "2024-03-01", sample_df)
  # A legacy file with the same date; if it were picked, reading would need 'qs'
  writeLines("legacy", sub("_qs2\\.qs2$", "_qs.qs", qs2_file))

  expect_equal(read_latest_qs(root, "results", "results"), sample_df)
})

test_that("errors when no matching file exists", {
  root <- tempfile(); on.exit(unlink(root, recursive = TRUE))
  dir.create(file.path(root, "results_2024-03-01"), recursive = TRUE)

  expect_error(read_latest_qs(root, "results", "results"), "No suitable file")
})

test_that("a legacy-only folder needs the archived qs package", {
  skip_if(requireNamespace("qs", quietly = TRUE), "qs is installed")
  root <- tempfile(); on.exit(unlink(root, recursive = TRUE))
  dir <- file.path(root, "results_2024-03-01")
  dir.create(dir, recursive = TRUE)
  writeLines("legacy", file.path(dir, "results_2024-03-01_qs.qs"))

  expect_error(read_latest_qs(root, "results", "results"), "requires the 'qs' package")
})
