#' Load unprocessed followup submissions
#' @param x Messy email.
#' @return Clean email.
#' @export
prep_phone <- function(x) {
  #library(stringr)
  phone <- str_sub(as.double(str_replace_all(str_squish(x), c(" "="",
                                                              "\\("="",
                                                              "\\)"=""))), -8)
    # case_when(str_length(as.double(str_replace_all(str_squish(x), c(" "="",
    #                                                                        "\\("="",
    #                                                                        "\\)"=""))) == 10 &
    #                               str_sub(as.double(str_replace_all(str_squish(x), c(" "="",
    #                                                                                  "\\("="",
    #                                                                                  "\\)"=""))),1,2) == 47)) ~


  #print(email)
}
