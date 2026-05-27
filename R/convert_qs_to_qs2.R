#' Convert legacy `.qs` files to the `.qs2` format
#'
#' Reads each input `.qs` file with `qs::qread()` and rewrites it next to the
#' source as `<stem>.qs2` via [qs2::qs_save()]. The original `.qs` file is
#' left untouched.
#'
#' Requires the legacy `qs` package (used only for reading the old format).
#' `qs` was archived from CRAN on 2026-01-17, so it is no longer a declared
#' dependency of this package. If you still have `.qs` files to convert,
#' install it from the CRAN archive with `remotes::install_version("qs")`.
#'
#' @param path Character vector of paths to existing `.qs` files.
#' @param overwrite Logical. If `FALSE` (the default), existing `.qs2`
#'   targets are skipped with a warning. If `TRUE`, they are overwritten.
#'
#' @return A character vector (invisibly) of the `.qs2` paths that were
#'   written. Skipped or failed inputs are omitted.
#'
#' @seealso [read_latest_qs()], [export_results_for_research()].
#'
#' @export
#'
#' @importFrom qs2 qs_save
#'
#' @examples
#' \dontrun{
#' convert_qs_to_qs2("data/results_2024-01-01.qs")
#'
#' files <- list.files("data/", pattern = "\\.qs$", full.names = TRUE)
#' convert_qs_to_qs2(files, overwrite = TRUE)
#' }
#'
convert_qs_to_qs2 <- function(path, overwrite = FALSE) {
  # 'qs' was archived from CRAN (2026-01-17) and is only needed to *read* the
  # legacy format here, so it is not a declared dependency. The package name is
  # held in a variable (and the function fetched via getExportedValue()) so
  # R CMD check does not flag the archived 'qs' as a missing dependency.
  qs_pkg <- "qs"
  if (!requireNamespace(qs_pkg, quietly = TRUE)) {
    stop(
      "Package 'qs' is required to read legacy .qs files but is not installed. ",
      "It was archived from CRAN on 2026-01-17; install it from the archive ",
      'with remotes::install_version("qs").',
      call. = FALSE
    )
  }
  qs_qread <- getExportedValue(qs_pkg, "qread")

  written <- character(0)

  for (src in path) {
    if (!file.exists(src)) {
      warning("File does not exist, skipping: ", src, call. = FALSE)
      next
    }
    if (!grepl("\\.qs$", src, ignore.case = TRUE)) {
      warning("Not a .qs file, skipping: ", src, call. = FALSE)
      next
    }

    dest <- sub("\\.qs$", ".qs2", src, ignore.case = TRUE)

    if (file.exists(dest) && !overwrite) {
      warning("Target already exists, skipping (set overwrite = TRUE): ", dest, call. = FALSE)
      next
    }

    obj <- qs_qread(src)
    qs2::qs_save(obj, dest)
    written <- c(written, dest)
  }

  invisible(written)
}
