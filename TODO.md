# TODO — datamanager

Suggestions for future improvements, grouped by impact. None of these are urgent for end-users today, but most would pay off the next time the package is touched.

## Bugs

- [ ] **`export_results_for_research()` Stata branch is broken.** In `R/export_results_for_research.R` the `tryCatch` block contains `return(list(data = data, message = dropped_vars))` *before* the `rio::export(df_stata_export, ...)` call, so the Stata file is never written and the function exits with a partial list when `write_as_stata = TRUE`. Remove the early `return()`, fix the `data` vs `df_stata_export` typo (currently returns the un-trimmed `data`), and let the export run.
- [ ] **`get_participant_age_5int.R` defines `get_participant_age`, not a 5-interval variant.** It overwrites `get_participant_age()` from `R/get_participant_age.R`, computes the early `if/else` block but discards the result, then runs `case_when()` on a `birthDate` (a Date) using numeric comparisons that can never match. The function as written cannot return age bands. Either rename to `get_participant_age_5int()` and fix the logic to compare *ages*, or delete the file.
- [ ] **`get_participant_birthdate()` uses copy-pasted roxygen.** `@param x Messy email. @return Clean email.` in `R/get_participant_age.R` is left over from `prep_email`. Fix the docs.
- [ ] **Orphan `man/hello.Rd`** has no matching `R/hello.R`. Delete it (and rerun `devtools::document()`).
- [ ] **`drop_long_variables()` degrades to a vector when only one column is kept.** The body does `data[, !(nchar(names(data)) > variable_length)]` without `drop = FALSE`, so single-column results lose their data-frame class. Fix to `data[, ..., drop = FALSE]`. The test in `tests/testthat/test-drop_long_variables.R` currently side-steps this with a 2-column fixture.

## CRAN-readiness / R CMD check

- [ ] **DESCRIPTION `Imports` is incomplete.** Code uses `stringr`, `magrittr`, `tibble`, `rlang`, `purrr`, `tidyr`, `lubridate`, `qs`, and `questionr` but they are not declared. Add them to `Imports` and replace `library(tidyverse)` / `@import tidyverse` with `@importFrom` for the specific functions used.
- [ ] **Switch from wildcard `NAMESPACE` export to explicit `@export`.** `exportPattern("^[[:alpha:]]+")` exports every helper, including `convert_mapping_to_dataframe()` which is internal. Delete the wildcard, add `usethis::use_namespace(roxygen = TRUE)` so roxygen owns NAMESPACE, and rely on the existing `@export` tags.
- [ ] **Replace in-function `library()` / `require()` with `@importFrom`.** Calls like `library(tidyverse)`, `library(labelled)`, `require(lubridate)` mutate the user's search path and are CRAN warnings. The existing roxygen blocks in some files (e.g. `apply_labels_from_dictionary.R`, `get_participant_birthdate.R`) already do this — extend it everywhere.
- [ ] **Declare `globalVariables` for tidy-eval defaults.** `scoring_rand12_unweighted()` defaults reference unquoted symbols (`Health_rating_now`, `Moderate_activity4w`, …) and `create_codebook()` uses unprefixed dplyr verbs, both producing `no visible binding` notes. Add `utils::globalVariables(c(...))` in `R/zzz.R` or rewrite to use `.data$`.
- [ ] **Add CI.** Standard `.github/workflows/R-CMD-check.yaml` (and `test-coverage.yaml` to make the existing codecov badge real). Use `usethis::use_github_action_check_standard()`.

## Tests

- [ ] **Populate `tests/testthat/`.** Currently empty. Highest-value targets:
  - `check_email_syntax()` — table-driven cases (typos, double `@`, missing TLD, parentheses, mailcom).
  - `clean_and_recheck_email()` — `.append = TRUE` vs `FALSE` shape; pre/post flag transitions.
  - `parse_spss_syntax()` and `parse_variable_mapping()` — round-trip a small fixture into a dictionary.
  - `apply_labels_from_dictionary()` — variable label, value label parsing of `"0 = No, 1 = Yes"`, optional rename path.
  - `prep_SocID()` — left-pad behaviour at boundary lengths.
  - `scoring_rand12_unweighted()` — known input → known PCS/MCS (worth fixing one canonical case from the Andersen 2022 reference).
  - `read_latest_qs()` — set up a temp directory with two dated folders, confirm the newer one wins.

## Code-quality cleanup

- [ ] **Remove commented-out old versions.** Large blocks of legacy code remain in `R/check_email_syntax.R` (~lines 226–291), `R/create_codebook.R` (~lines 67–108), and `R/prep_email.R` (~lines 45–62). Git history preserves them; delete from source.
- [ ] **Deduplicate `get_participant_age()` and `calc_age()`.** They have identical bodies. Keep one (`calc_age()` is the better name and has the more complete roxygen) and either delete the other or make it a thin alias with `lifecycle::deprecate_soft()`.
- [ ] **Deprecate `prep_email()` in favour of `check_email_syntax()`.** The newer function is a strict superset (returns flag/reason/corrected/log, anchors corrections to the domain to avoid false positives). Add `lifecycle::deprecate_warn()` rather than removing immediately.
- [ ] **Standardise function naming.** Most functions are `snake_case`; `prep_SocID` mixes case. Consider renaming to `prep_socid()` with a deprecation alias for one cycle.
- [ ] **`@import tidyverse` is not allowed by CRAN.** Replace in `scoring_rand12.R` and `read_latest_data.R` with specific `@importFrom dplyr ...` etc.

## Documentation

- [ ] **Fix `export_results_for_research()` roxygen.** `@param results_directory` is documented twice — one of them should be `@param results_directory_location`.
- [ ] **Write a vignette.** README mentions "or vignette" but none exists. A "labelling pipeline" vignette walking through `parse_spss_syntax()` → `apply_labels_from_dictionary()` → `export_results_for_research()` would be the most useful, since that flow is the package's main value-add and isn't obvious from individual help pages.
- [ ] **Real examples.** Many `@examples` are wrapped in `\dontrun{}` or commented out in `README.Rmd`. Provide small inline data so `devtools::check()` actually runs them.
- [ ] **Flesh out `NEWS.md`.** Versions 0.1.0–0.3.0 are listed without changelog entries. Backfill from `git log` while it's still recent.
- [ ] **Set up pkgdown.** `usethis::use_pkgdown_github_pages()` would give the package a browsable doc site grouping the labelling, cleaning, and scoring families separately.

## Nice-to-haves

- [ ] **Generalise `create_codebook()` domain rules.** The `case_when()` at the bottom hard-codes project-specific variable patterns (`Sero_*`, `vitas_*`, `F2_Ignore`, `E3_sym_onset_date`). Move these to a `rules` argument with sensible defaults so the function is reusable outside the originating study.
- [ ] **Add a `score_emq()` function.** README and DESCRIPTION advertise EMQ scoring but only RAND-12 is implemented.
- [ ] **`scoring_rand12_weighted()` companion.** The unweighted version is documented as such; a US-norm-weighted variant would round out the scoring family.
