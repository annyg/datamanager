# datamanager (development version)
* Hardened `prep_email()`. Provider typo fixes now only apply to the domain (e.g. `gmalmberg@uio.no` is no longer rewritten), the `.vom` fix no longer matches arbitrary characters (`user@gravom.no` was turned into `user@gr.com.no`), runs of dots are fully collapsed, and fixes are case-insensitive so they also work with `lowercase = FALSE`. `fix_spelling = TRUE` now also fixes ending typos such as `.con`, `,com` and `-no`, collapses `@@`, and adds `.com` to major providers without an ending.
* `prep_email()` now always removes invisible characters, normalises full-width characters such as `＠`, unwraps `Name <a@b.no>` and `mailto:`, trims stray quotes and punctuation, and turns empty strings into `NA`. It accepts factors and errors on non-character input.
* Added an `invalid` argument to `prep_email()` (`"keep"`, `"warn"` or `"na"`) to warn about or drop addresses that still look invalid after cleaning. The default `"keep"` matches previous behaviour.
* Fixed `get_participant_age_5int()`, which errored on every input because it binned the parsed birthdate instead of the computed age. Ages under 18 return `NA`.
* Fixed `convert_mapping_to_dictionary()` and `convert_mapping_to_dataframe()`. They now use the same header and value patterns as `parse_variable_mapping()`, so they take the quoted variable label, no longer parse the header line as a value, and trim value labels. `convert_mapping_to_dataframe()` also no longer misaligns values with their rows.
* Fixed `apply_labels_from_dictionary()`. Value labels were built the wrong way round, which errored for numeric codes and inverted character codes. `new_var_name_col` errored on any input. Integer-like codes now also match double columns, and variables with no new name keep their name and labels.
* Fixed `parse_spss_syntax()` erroring on files without `VARIABLE LABELS` lines. It now returns an empty table.

# datamanager 0.4.1
* Added `convert_qs_to_rds()` to convert `.qs2` (or legacy `.qs`) files to `.rds` via `saveRDS()`.
* Added a `write_as_rds` option to `export_results_for_research()` to write an R native `.rds` file.
* Fixed `export_results_for_research()` creating the dated output directory in the working directory instead of under `results_directory_location`, which made any non-empty `results_directory_location` fail. The directory is now created recursively at the documented path, and every write shares a single `result_path`.
* `export_results_for_research(write_as_qs = TRUE)` now writes via `qs::qsave()` directly instead of `rio::export()`. `rio` dropped `.qs` support in 1.3.0 (it errors with "qs format not supported"), which left `write_as_qs` broken even when `qs` was installed. The branch also checks for the archived `qs` package up front and errors with an actionable message, matching the legacy readers.
* `export_results_for_research()` no longer calls `create_codebook()` via `datamanager::`, so the HTML codebook works under `devtools::load_all()`.

# datamanager 0.4.0
* Migrated from the archived `qs` package to `qs2` for serialization; added `convert_qs_to_qs2()` to convert existing `.qs` files.
* Added a `write_as_qs2` option to `export_results_for_research()` (recommended fast binary format via `qs2::qs_save()`); `write_as_qs` is kept but superseded.
* `read_latest_qs()` now also discovers `.qs2` files (preferring them over legacy `.qs` on a date tie) and dispatches to `qs2::qs_read()` or `qs::qread()` accordingly.
* Added redaction options to `create_codebook()` (date-range and free-text detection) and standardized the date range separator to "--".

# datamanager 0.2.0
* Added `read_latest_qs()`, which reads the latest QS file written by `export_results_for_research()`.
* Added `generate_readme()`, which adds a README template file to the project.

# datamanager 0.1.0
* Initial release.
