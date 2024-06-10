#' Load unprocessed followup submissions
#' @param x Messy email.
#' @return Clean email.
#' @export
get_column_names <- function(data) {
  as.data.frame(colnames(data)) %>%
    rename(Data_columns = "colnames(data)") %>%
    mutate(col_length = str_length(Data_columns))
}
