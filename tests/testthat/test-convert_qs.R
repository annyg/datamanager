sample_df <- data.frame(id = 1:3, grp = c("a", "b", "c"))

test_that("convert_qs_to_rds converts .qs2 files and leaves the source", {
  dir <- tempfile(); dir.create(dir); on.exit(unlink(dir, recursive = TRUE))
  src <- file.path(dir, "data.qs2")
  qs2::qs_save(sample_df, src)

  out <- convert_qs_to_rds(src)

  expect_equal(out, file.path(dir, "data.rds"))
  expect_equal(readRDS(out), sample_df)
  expect_true(file.exists(src))
})

test_that("convert_qs_to_rds skips missing, wrong-type and existing targets", {
  dir <- tempfile(); dir.create(dir); on.exit(unlink(dir, recursive = TRUE))
  src <- file.path(dir, "data.qs2")
  qs2::qs_save(sample_df, src)
  txt <- file.path(dir, "notes.txt")
  writeLines("x", txt)
  saveRDS("old", file.path(dir, "data.rds"))

  expect_warning(out <- convert_qs_to_rds(file.path(dir, "nope.qs2")), "does not exist")
  expect_length(out, 0L)
  expect_warning(convert_qs_to_rds(txt), "Not a .qs2 or .qs file")
  expect_warning(convert_qs_to_rds(src), "Target already exists")
  expect_equal(readRDS(file.path(dir, "data.rds")), "old")

  convert_qs_to_rds(src, overwrite = TRUE)
  expect_equal(readRDS(file.path(dir, "data.rds")), sample_df)
})

test_that("legacy .qs inputs need the archived qs package", {
  skip_if(requireNamespace("qs", quietly = TRUE), "qs is installed")
  dir <- tempfile(); dir.create(dir); on.exit(unlink(dir, recursive = TRUE))
  src <- file.path(dir, "legacy.qs")
  writeLines("placeholder", src)

  expect_error(convert_qs_to_rds(src), "Package 'qs' is required")
  expect_error(convert_qs_to_qs2(src), "Package 'qs' is required")
})

test_that("legacy .qs files round-trip through both converters", {
  skip_if_not_installed("qs")
  qsave <- getExportedValue("qs", "qsave")
  dir <- tempfile(); dir.create(dir); on.exit(unlink(dir, recursive = TRUE))
  src <- file.path(dir, "legacy.qs")
  qsave(sample_df, src)

  expect_equal(readRDS(convert_qs_to_rds(src)), sample_df)
  expect_equal(qs2::qs_read(convert_qs_to_qs2(src)), sample_df)
})
