#' Load unprocessed followup submissions
#' @param x Messy email.
#' @return Clean email.
#' @export
create_codebook <- function(data) {

  var_labels <- as.data.frame(enframe(var_label(data))) %>%
    rename(varname = name, varlabel = value)
  #look_for(data, details = FALSE)
  # data.frame(cbind(names(var_label(data)),
  #                              do.call(rbind, var_label(data))))
  var_type <- as.data.frame(enframe(lapply(data, class))) %>%
    rename(varname = name, vartype = value)


  freqs <- lapply(data, function(x) { return(questionr::freq(x)) }) %>%
    keep(function(x) nrow(x) < 100) %>%
    do.call(rbind, .) %>%
    tibble::rownames_to_column(var = "varname_value") %>%
    mutate(varname = gsub("(.+?)(\\..*)", "\\1", varname_value),
           value = gsub("^[^.]*.","",varname_value)) %>%
    group_by(varname) %>%
    mutate(npos = row_number(),
           value_n = paste(value, n, sep = ": ")) %>%
    select(varname, value_n, npos) %>%
    spread(npos, value_n) %>%
    # mutate(across(.cols = everything(-varname),
    #               ~(ifelse(is.na(.), "", .)))) %>% # NEW
    mutate_at(vars(-varname), funs(ifelse(is.na(.), "", .))) %>% # OLD
    unite("valfreqs", c(2:ncol(.)), sep = "\n") %>%
    mutate(valfreqs = sub("\\s+$", "", valfreqs)) #%>%
  #rename(variable = varname)

  full_join(var_labels, freqs, by = "varname") %>%
    mutate(varlabel = as.character(varlabel)) %>%
    full_join(var_type, by = "varname") %>%
    mutate(vartype = as.character(vartype)) %>%
    mutate(valfreqs = case_when(vartype == "c\\(\"POSIXct\", \"POSIXt\"\\)" |
                                  vartype == "Date" ~ "Dates",
                                str_detect(varname, "_elaborate") ~ "Textual elaborations",
                                str_detect(varname, "F2_Ignore") ~ "Textual elaborations",
                                str_detect(varname, "Sero_rekvirent") ~ "Rekvirent IDs",
                                str_detect(varname, "E3_sym_onset_date") ~ "Dates",
                                str_detect(varname, "Sero_") ~ "Measured serology",
                                str_detect(varname, "vitas_") ~ "Measured dried bloodspots",
                                TRUE ~ valfreqs))
}
