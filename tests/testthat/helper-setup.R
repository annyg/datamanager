# Several package functions reference unprefixed `stringr`, `purrr`, `tibble`,
# and `dplyr` helpers (e.g. `str_to_lower`, `pmap_chr`, `tibble`) that rely on
# the calling environment having those packages attached. Until the package's
# DESCRIPTION + roxygen `@importFrom` declarations are complete, attach them
# explicitly here so the test suite can exercise the functions.
suppressPackageStartupMessages({
  library(stringr)
  library(purrr)
  library(tibble)
  library(dplyr)
  library(rlang)
})
