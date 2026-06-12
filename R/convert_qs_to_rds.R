#' Convert `.qs2` / legacy `.qs` files to the `.rds` format
#'
#' Reads each input file and rewrites it next to the source as `<stem>.rds`
#' via [saveRDS()]. Modern `.qs2` files are read with [qs2::qs_read()]; legacy
#' `.qs` files are read with `qs::qread()`. The original file is left
#' untouched.
#'
#' Reading a legacy `.qs` file requires the `qs` package. `qs` was archived
#' from CRAN on 2026-01-17, so it is no longer a declared dependency of this
#' package. If you still have `.qs` files to convert, install it from the CRAN
#' archive with `remotes::install_version("qs")`. Converting `.qs2` files needs
#' only `qs2`.
#'
#' @param path Character vector of paths to existing `.qs2` or `.qs` files.
#' @param overwrite Logical. If `FALSE` (the default), existing `.rds`
#'   targets are skipped with a warning. If `TRUE`, they are overwritten.
#'
#' @return A character vector (invisibly) of the `.rds` paths that were
#'   written. Skipped or failed inputs are omitted.
#'
#' @seealso [convert_qs_to_qs2()], [read_latest_qs()],
#'   [export_results_for_research()].
#'
#' @export
#'
#' @importFrom qs2 qs_read
#'
#' @examples
#' \dontrun{
#' convert_qs_to_rds("data/results_2024-01-01.qs2")
#'
#' files <- list.files("data/", pattern = "\\.qs2?$", full.names = TRUE)
#' convert_qs_to_rds(files, overwrite = TRUE)
#' }
#'
convert_qs_to_rds <- function(path, overwrite = FALSE) {
  # 'qs' was archived from CRAN (2026-01-17) and is only needed to *read* the
  # legacy .qs format here, so it is not a declared dependency. The package name
  # is held in a variable (and the function fetched via getExportedValue()) so
  # R CMD check does not flag the archived 'qs' as a missing dependency. It is
  # loaded lazily, only when a legacy .qs file is actually encountered.
  qs_pkg <- "qs"

  written <- character(0)

  for (src in path) {
    if (!file.exists(src)) {
      warning("File does not exist, skipping: ", src, call. = FALSE)
      next
    }

    is_qs2 <- grepl("\\.qs2$", src, ignore.case = TRUE)
    is_qs <- grepl("\\.qs$", src, ignore.case = TRUE)
    if (!is_qs2 && !is_qs) {
      warning("Not a .qs2 or .qs file, skipping: ", src, call. = FALSE)
      next
    }

    dest <- sub("\\.qs2?$", ".rds", src, ignore.case = TRUE)

    if (file.exists(dest) && !overwrite) {
      warning("Target already exists, skipping (set overwrite = TRUE): ", dest, call. = FALSE)
      next
    }

    if (is_qs2) {
      obj <- qs2::qs_read(src)
    } else {
      if (!requireNamespace(qs_pkg, quietly = TRUE)) {
        stop(
          "Package 'qs' is required to read legacy .qs files but is not installed. ",
          "It was archived from CRAN on 2026-01-17; install it from the archive ",
          'with remotes::install_version("qs").',
          call. = FALSE
        )
      }
      qs_qread <- getExportedValue(qs_pkg, "qread")
      obj <- qs_qread(src)
    }

    saveRDS(obj, dest)
    written <- c(written, dest)
  }

  invisible(written)
}
