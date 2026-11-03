sample_df <- data.frame(id = 1:3, score = c(1.5, 2, 3.25), grp = c("a", "b", "c"))

# Each test exports under <tempfile>/nested/ to exercise recursive directory
# creation; `base` is removed afterwards.
new_root <- function(base) paste0(base, "/nested/")

test_that("writes csv by default into a dated folder under the location", {
  base <- tempfile(); on.exit(unlink(base, recursive = TRUE))
  root <- new_root(base)

  export_results_for_research(sample_df, root, results_date = "2024-03-01")

  path <- file.path(root, "results_2024-03-01", "results_2024-03-01.csv")
  expect_true(file.exists(path))
  expect_equal(nrow(utils::read.csv(path)), 3L)
})

test_that("rds and qs2 outputs round-trip, and read_latest_qs finds the qs2", {
  base <- tempfile(); on.exit(unlink(base, recursive = TRUE))
  root <- new_root(base)

  export_results_for_research(
    sample_df, root,
    results_directory = "out", results_filename = "study",
    results_date = "2024-03-01",
    write_as_csv = FALSE, write_as_rds = TRUE, write_as_qs2 = TRUE
  )

  dir <- file.path(root, "out_2024-03-01")
  expect_setequal(list.files(dir), c("study_2024-03-01.rds", "study_2024-03-01_qs2.qs2"))
  expect_equal(readRDS(file.path(dir, "study_2024-03-01.rds")), sample_df)
  expect_equal(read_latest_qs(root, "out", "study"), sample_df)
})

test_that("Stata export drops names over 32 characters with a warning", {
  base <- tempfile(); on.exit(unlink(base, recursive = TRUE))
  root <- new_root(base)
  df <- sample_df
  df[[strrep("x", 33)]] <- 1

  expect_warning(
    export_results_for_research(df, root, results_date = "2024-03-01",
                                write_as_csv = FALSE, write_as_stata = TRUE),
    "longer than 32 characters"
  )

  out <- rio::import(file.path(root, "results_2024-03-01", "results_2024-03-01_stata.dta"))
  expect_named(out, names(sample_df))
})

test_that("SPSS export drops invalid variable names with a warning", {
  base <- tempfile(); on.exit(unlink(base, recursive = TRUE))
  root <- new_root(base)
  df <- sample_df
  df[["1starts_with_digit"]] <- 1
  df[["AND"]] <- 2
  df[["ends_with_dot."]] <- 3

  expect_warning(
    export_results_for_research(df, root, results_date = "2024-03-01",
                                write_as_csv = FALSE, write_as_spss = TRUE),
    "invalid for SPSS"
  )

  out <- rio::import(file.path(root, "results_2024-03-01", "results_2024-03-01_spss.sav"))
  expect_named(out, names(sample_df))
})

test_that("write_as_qs errors helpfully when qs is not installed", {
  skip_if(requireNamespace("qs", quietly = TRUE), "qs is installed")
  base <- tempfile(); on.exit(unlink(base, recursive = TRUE))
  root <- new_root(base)

  expect_error(
    export_results_for_research(sample_df, root, write_as_csv = FALSE, write_as_qs = TRUE),
    "write_as_qs2 = TRUE"
  )
})
