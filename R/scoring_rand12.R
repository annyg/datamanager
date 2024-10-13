#' Generates unweighted Physical Component Scores and Mental Component Scores from RAND-12 or RAND-36
#'
#' This function generates the unweighted RAND-12 PCS and MCS scores that range from 0 to 100, with higher scores indicating better HRQoL.
#'
#' @param data Data frame containing the variables needed for scoring RAND-12
#' @param RAND36_1 The variable corresponding to RAND36_1 / RAND12_1
#' @param RAND36_3b The variable corresponding to RAND36_3b / RAND12_2a
#' @param RAND36_3d The variable corresponding to RAND36_3d / RAND12_2b
#' @param RAND36_4b The variable corresponding to RAND36_4b / RAND12_3a
#' @param RAND36_4c The variable corresponding to RAND36_4c / RAND12_3b
#' @param RAND36_5b The variable corresponding to RAND36_5b / RAND12_4a
#' @param RAND36_5c The variable corresponding to RAND36_5c / RAND12_4b
#' @param RAND36_8 The variable corresponding to RAND36_8 / RAND12_5
#' @param RAND36_9d The variable corresponding to RAND36_9d / RAND12_6a
#' @param RAND36_9e The variable corresponding to RAND36_9e / RAND12_6b
#' @param RAND36_9f The variable corresponding to RAND36_9f / RAND12_6c
#' @param RAND36_10 The variable corresponding to RAND36_10 / RAND12_7
#'
#' @return A data frame with unweighted RAND-12 PCS (PCS12_unwh) and MCS (MCS12_unwh) scores
#'
#' @references
#' Andersen, J. R., et al. (2022). Correlated physical and mental health composite scores for the RAND-36 and RAND-12 health surveys: Can we keep them simple? Health and Quality of Life Outcomes, 20(1), 89. https://doi.org/10.1186/s12955-022-01992-0
#'
#' @import tidyverse
#' @export
scoring_rand12_unweighted <- function(
    data,
    RAND36_1 = Health_rating_now,
    RAND36_3b = Moderate_activity4w,
    RAND36_3d = Stairs4w,
    RAND36_4b = Physical_health_lessthanwanted4w,
    RAND36_4c = Physical_health_limited4w,
    RAND36_5b = Psychological_health_lessthanwanted4w,
    RAND36_5c = Psychological_healthlimitation4w,
    RAND36_8 = Pain_limited_activities4w,
    RAND36_9d = Relaxed_feeling4w,
    RAND36_9e = Energetic_feeling4w,
    RAND36_9f = Depressed_feeling4w,
    RAND36_10 = PhysicalAndEmotional_Social4w) {
  library(tidyverse)
  # 1. Preserve raw data so they can be used for control
  data <- data %>%
    mutate(
      GH1 = {{ RAND36_1 }},
      PF2 = {{ RAND36_3b }},
      PF4 = {{ RAND36_3d }},
      RP2 = {{ RAND36_4b }},
      RP3 = {{ RAND36_4c }},
      RE2 = {{ RAND36_5b }},
      RE3 = {{ RAND36_5c }},
      BP2 = {{ RAND36_8 }},
      MH3 = {{ RAND36_9d }},
      VT2 = {{ RAND36_9e }},
      MH4 = {{ RAND36_9f }},
      SF2 = {{ RAND36_10 }}
    )

  # 2. Remove values that are outside possible alternatives
  data <- data %>%
    mutate(
      across(c(RP2, RP3, RE2, RE3), ~ case_when(. <= 2 ~ .)),
      across(c(PF2, PF4), ~ case_when(. <= 3 ~ .)),
      across(c(GH1, BP2, SF2), ~ case_when(. <= 5 ~ .)),
      across(c(MH3, VT2, MH4), ~ case_when(. <= 6 ~ .)),
    )

  # 3. Recode to 0-100 score so that higher score means better health on all 12 items
  data <- data %>%
    mutate(
      across(c(RP2, RP3, RE2, RE3), ~ case_when(. == 1 ~ 0, . == 0 ~ 100)), # ok
      across(c(PF2, PF4), ~ case_when(. == 2 ~ 0, . == 1 ~ 50, . == 0 ~ 100)), # ok
      across(c(GH1), ~ case_when(. == 4 ~ 100, . == 3 ~ 75, . == 2 ~ 50, . == 1 ~ 25, . == 0 ~ 0)), # ok
      across(c(BP2, SF2), ~ case_when(. == 4 ~ 0, . == 3 ~ 25, . == 2 ~ 50, . == 1 ~ 75, . == 0 ~ 100)), # ok
      across(c(MH3, VT2), ~ case_when(. == 5 ~ 100, . == 4 ~ 80, . == 3 ~ 60, . == 2 ~ 40, . == 1 ~ 20, . == 0 ~ 0)), # ok
      across(c(MH4), ~ case_when(. == 5 ~ 0, . == 4 ~ 20, . == 3 ~ 40, . == 2 ~ 60, . == 1 ~ 80, . == 0 ~ 100)) # ok
    )

  # 4. Create 8 domain scores (subscales)
  data$PF <- rowMeans(data[, c("PF2", "PF4")], na.rm = TRUE)
  data$RP <- rowMeans(data[, c("RP2", "RP3")], na.rm = TRUE)
  data$BP <- data$BP2
  data$GH <- data$GH1
  data$VT <- data$VT2
  data$SF <- data$SF2
  data$RE <- rowMeans(data[, c("RE2", "RE3")], na.rm = TRUE)
  data$MH <- rowMeans(data[, c("MH3", "MH4")], na.rm = TRUE)

  # 5. Create unweighted physical sum score (PCS12) and mental sum score (MCS12) (0-100 score)
  data$PCS12_unwh <- rowMeans(data[, c("PF", "RP", "BP", "GH")], na.rm = TRUE)
  data$MCS12_unwh <- rowMeans(data[, c("VT", "SF", "RE", "MH")], na.rm = TRUE)

  # 6. OBS! deletes all auxiliary variables. Omit this command if you want to see the whole calculation
  data <- data[, !(names(data) %in% c("GH1", "PF2", "PF4", "RP2", "RP3", "RE2", "RE3", "BP2", "MH3", "VT2", "MH4", "SF2"))]

  return(data)
}
