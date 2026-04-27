# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Package overview

`datamanager` is an R package for managing and scoring research/questionnaire data (currently v0.3.0, GPL-3, RECON "experimental" lifecycle). Functions cluster into a few cooperating areas rather than being independent utilities — see "Architecture" below.

## Common commands

Run from the package root (R session, not bash):

```r
# Regenerate Rd files in man/ from roxygen2 comments. Required after editing any roxygen block.
devtools::document()

# Build + install locally
devtools::install()

# Full check (CRAN-style). Run before commit when changing exported APIs.
devtools::check()

# Tests (testthat). Note: tests/testthat/ does not yet exist — only the harness in tests/testthat.R.
devtools::test()
testthat::test_file("tests/testthat/test-<name>.R")  # single file once tests are added

# Lint (uses .lintr defaults, UTF-8)
lintr::lint_package()

# Regenerate README.md from README.Rmd. README.md must NEVER be edited directly — it is generated.
devtools::build_readme()
```

## Architecture

The package's non-obvious structure is the **three-stage labelling pipeline**, where several otherwise-unrelated files cooperate:

1. **Parse** an external label source into a tidy dictionary `data.frame`:
   - `parse_spss_syntax()` — reads `.sps` files (`VARIABLE LABELS` / `VALUE LABELS` blocks)
   - `parse_variable_mapping()` (in `R/parse_python_mapping.R`) — reads the project's custom mapping format (`newname: 'Label' <- TYPE :: oldname`)
   - `convert_mapping_to_dictionary()` — alternate text-based mapping converter
2. **Apply** the dictionary to a data frame: `apply_labels_from_dictionary()` reads `var_name`/`var_label`/`val_labels` columns and uses the `labelled` package to attach metadata; optionally renames variables via `new_var_name_col`.
3. **Export** the labelled frame: `export_results_for_research()` writes csv/xlsx/qs/sav/dta/sas via `rio`, plus optional codebooks (`create_codebook()` HTML via DT, or `codebookr::codebook()` Word) and a `labelled::generate_dictionary()` Excel.

Counterpart reader: `read_latest_qs()` discovers the most recent `<results_directory>_<YYYY-MM-DD>/<results_filename>_<YYYY-MM-DD>.qs` written by `export_results_for_research()`. The two are tightly coupled by that naming convention — changing the format in one must change it in the other.

Other groupings:
- **Field cleaners** (`prep_*.R`): `prep_email`, `prep_name`, `prep_phone`, `prep_SocID`. `check_email_syntax()` is a more thorough successor to `prep_email()` (returns flag/reason/corrected/log) and is wrapped at the data-frame level by `clean_and_recheck_email()`.
- **Norwegian SocID helpers**: `prep_SocID()` left-pads to 11 chars; `calc_age()` (in `extract_participant_age.R`) and `get_participant_age()` parse the leading 6 chars as a `ddmmyy` birthdate using `lubridate::parse_date_time2` with `cutoff_2000 = 22L`.
- **Scoring**: `scoring_rand12_unweighted()` produces unweighted RAND-12 PCS/MCS scores in 0–100 (Andersen et al. 2022).

## Conventions specific to this package

- **NAMESPACE is auto-managed by a wildcard**: `exportPattern("^[[:alpha:]]+")` exports every function whose name starts with a letter. You generally do not need `@export` to publish a function (though most files use it anyway). Keep internal helpers prefixed with `.` or `_` if you need to hide them.
- **`library()` calls inside functions** are common in this codebase (e.g., `library(tidyverse)`, `library(labelled)`, `library(stringr)` inside function bodies). This is not idiomatic CRAN style but is consistent throughout — match the existing pattern when editing rather than refactoring. New code should still also list the package in `DESCRIPTION` Imports and use `pkg::fn()` or roxygen `@importFrom` where practical.
- **roxygen2 7.3.2, markdown enabled** (`Roxygen: list(markdown = TRUE)` in DESCRIPTION). After editing any `#'` block, run `devtools::document()` to regenerate the corresponding `man/*.Rd`.
- **README workflow**: edit `README.Rmd`, then `devtools::build_readme()`. `.Rbuildignore` excludes `README.Rmd` from the built tarball.
- **Internal data**: `R/sysdata.rda` holds `readme_template` (used by `generate_readme()`). Regenerate via `usethis::use_data(readme_template, internal = TRUE, overwrite = TRUE)` if it changes.
- **Pipe**: `%>%` is re-exported from `magrittr` via `R/utils-pipe.R`. The base `|>` is not used in this package.

## Tests

The test harness exists (`tests/testthat.R`) but `tests/testthat/` is empty — there are currently no test files. When adding tests, create `tests/testthat/test-<topic>.R` and `devtools::test()` will pick them up.
