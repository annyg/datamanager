# Made according to
# Andersen, J. R., et al. (2022). Correlated physical and mental health composite
# scores for the RAND-36 and RAND-12 health surveys: Can we keep them simple? Health
# and Quality of Life Outcomes, 20(1), 89. https://doi.org/10.1186/s12955-022-01992-0

# This function generates the unweighted RAND-12 PCS and MCS scores that range from 0 to 100, with higher scores indicating better HRQoL.

scoring_rand12_unweighted <- function(df,
                                RAND36_1 = Health_rating_now, #RAND12_1,
                                RAND36_3b = Moderate_activity4w, #RAND12_2a,
                                RAND36_3d = Stairs4w, #RAND12_2b,
                                RAND36_4b = Physical_health_lessthanwanted4w, #RAND12_3a,
                                RAND36_4c = Physical_health_limited4w, #RAND12_3b,
                                RAND36_5b = Psychological_health_lessthanwanted4w, #RAND12_4a,
                                RAND36_5c = Psychological_healthlimitation4w, #RAND12_4b,
                                RAND36_8 = Pain_limited_activities4w, #RAND12_5,
                                RAND36_9d = Relaxed_feeling4w, #RAND12_6a,
                                RAND36_9e = Energetic_feeling4w, #RAND12_6b,
                                RAND36_9f = Depressed_feeling4w, #RAND12_6c,
                                RAND36_10 = PhysicalAndEmotional_Social4w) { #RAND12_7
  library(tidyverse)

  # 1. Preserve raw data so they can be used for control
  df <- df %>%
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
  df <- df %>%
    mutate(across(c(RP2, RP3, RE2, RE3), ~case_when(. <= 2 ~ .)),
           across(c(PF2, PF4), ~case_when(. <= 3 ~ .)),
           across(c(GH1, BP2, SF2), ~case_when(. <= 5 ~ .)),
           across(c(MH3, VT2, MH4), ~case_when(. <= 6 ~ .)),
                  )

  # 3. Recode to 0-100 score so that higher score means better health on all 12 items
  df <- df %>%
    mutate(across(c(RP2, RP3, RE2, RE3), ~case_when(. == 1 ~ 0, . == 0 ~ 100)), #ok
           across(c(PF2, PF4), ~case_when(. == 2 ~ 0, . == 1 ~ 50, . == 0 ~ 100)), #ok
           across(c(GH1), ~case_when(. == 4 ~ 100, . == 3 ~ 75, . == 2 ~ 50, . == 1 ~ 25, . == 0 ~ 0)), #ok
           across(c(BP2, SF2), ~case_when(. == 4 ~ 0, . == 3 ~ 25, . == 2 ~ 50, . == 1 ~ 75, . == 0 ~ 100)), #ok
           across(c(MH3, VT2), ~case_when(. == 5 ~ 100, . == 4 ~ 80, . == 3 ~ 60, . == 2 ~ 40, . == 1 ~ 20, . == 0 ~ 0)), #ok
           across(c(MH4), ~case_when(. == 5 ~ 0, . == 4 ~ 20, . == 3 ~ 40, . == 2 ~ 60, . == 1 ~ 80, . == 0 ~ 100)) #ok
    )

  # 4. Create 8 domain scores (subscales)
  df$PF <- rowMeans(df[,c("PF2","PF4")], na.rm = TRUE)
  df$RP <- rowMeans(df[,c("RP2","RP3")], na.rm = TRUE)
  df$BP <- df$BP2
  df$GH <- df$GH1
  df$VT <- df$VT2
  df$SF <- df$SF2
  df$RE <- rowMeans(df[,c("RE2","RE3")], na.rm = TRUE)
  df$MH <- rowMeans(df[,c("MH3","MH4")], na.rm = TRUE)

  # 5. Create unweighted physical sum score (PCS12) and mental sum score (MCS12) (0-100 score)
  df$PCS12_unwh <- rowMeans(df[,c("PF","RP","BP","GH")], na.rm = TRUE)
  df$MCS12_unwh <- rowMeans(df[,c("VT","SF","RE","MH")], na.rm = TRUE)

  # 6. OBS! deletes all auxiliary variables. Omit this command if you want to see the whole calculation
  df <- df[, !(names(df) %in% c("GH1","PF2","PF4","RP2","RP3","RE2","RE3","BP2","MH3","VT2","MH4","SF2"))]

  return(df)
}
