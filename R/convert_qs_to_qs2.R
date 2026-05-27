#' Convert legacy `.qs` files to the `.qs2` format
#'
#' Reads each input `.qs` file with [qs::qread()] and rewrites it next to the
#' source as `<stem>.qs2` via [qs2::qs_save()]. The original `.qs` file is
#' left untouched.
#'
#' Requires the suggested `qs` package (used only for reading the legacy
#' format). Install with `install.packages("qs")` if missing.
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
  if (!requireNamespace("qs", quietly = TRUE)) {
    stop(
      "Package 'qs' is required to read legacy .qs files. ",
      "Install it with install.packages(\"qs\").",
      call. = FALSE
    )
  }

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

    obj <- qs::qread(src)
    qs2::qs_save(obj, dest)
    written <- c(written, dest)
  }

  invisible(written)
}
