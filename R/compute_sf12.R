compute_sf12_variables <- function(data,
                                   GH1 = RAND36_1,
                                   PF2 = RAND36_3b,
                                   PF4 = RAND36_3d,
                                   RP2 = RAND36_4b,
                                   RP3 = RAND36_4c,
                                   RE2 = RAND36_5b,
                                   RE3 = RAND36_5c,
                                   BP2 = RAND36_8,
                                   MH3 = RAND36_9d,
                                   VT2 = RAND36_9e,
                                   MH4 = RAND36_9f,
                                   SF2 = RAND36_10) {
  # Bevare rådata slik at dei kan nyttast til kontroll
  data <- data %>%
    mutate(
      GH1 = GH1,
      PF2 = PF2,
      PF4 = PF4,
      RP2 = RP2,
      RP3 = RP3,
      RE2 = RE2,
      RE3 = RE3,
      BP2 = BP2,
      MH3 = MH3,
      VT2 = VT2,
      MH4 = MH4,
      SF2 = SF2
    )
}

compute_sf12_valid_range <- function(data,
                                GH1 = GH1,
                                PF2 = PF2,
                                PF4 = PF4,
                                RP2 = RP2,
                                RP3 = RP3,
                                RE2 = RE2,
                                RE3 = RE3,
                                BP2 = BP2,
                                MH3 = MH3,
                                VT2 = VT2,
                                MH4 = MH4,
                                SF2 = SF2) {
  # Fjerne verdiar som er utanfor mogelege alterantiv
  data <- data %>%
    mutate(
      RP2 = ifelse(RP2 %in% 1:2, RP2, NA),
      RP3 = ifelse(RP3 %in% 1:2, RP3, NA),
      RE2 = ifelse(RE2 %in% 1:2, RE2, NA),
      RE3 = ifelse(RE3 %in% 1:2, RE3, NA),
      PF2 = ifelse(PF2 %in% 1:3, PF2, NA),
      PF4 = ifelse(PF4 %in% 1:3, PF4, NA),
      GH1 = ifelse(GH1 %in% 1:5, GH1, NA),
      BP2 = ifelse(BP2 %in% 1:5, BP2, NA),
      SF2 = ifelse(SF2 %in% 1:5, SF2, NA),
      MH3 = ifelse(MH3 %in% 1:6, MH3, NA),
      VT2 = ifelse(VT2 %in% 1:6, VT2, NA),
      MH4 = ifelse(MH4 %in% 1:6, MH4, NA)
    )
}

compute_sf12_normalise_score <- function(data,
                                     GH1 = GH1,
                                     PF2 = PF2,
                                     PF4 = PF4,
                                     RP2 = RP2,
                                     RP3 = RP3,
                                     RE2 = RE2,
                                     RE3 = RE3,
                                     BP2 = BP2,
                                     MH3 = MH3,
                                     VT2 = VT2,
                                     MH4 = MH4,
                                     SF2 = SF2) {
  # Kode om til 0-100 skår
  data <- data %>%
    mutate(
      RP2 = ifelse(RP2 == 1, 0, 100),
      RP3 = ifelse(RP3 == 1, 0, 100),
      RE2 = ifelse(RE2 == 1, 0, 100),
      RE3 = ifelse(RE3 == 1, 0, 100),
      PF2 = ifelse(PF2 == 1, 0, ifelse(PF2 == 2, 50, 100)),
      PF4 = ifelse(PF4 == 1, 0, ifelse(PF4 == 2, 50, 100)),
      GH1 = ifelse(GH1 == 1, 100, ifelse(GH1 == 2, 75, ifelse(GH1 == 3, 50, ifelse(GH1 == 4, 25, 0)))),
      SF2 = ifelse(SF2 == 1, 0, ifelse(SF2 == 2, 25, ifelse(SF2 == 3, 50, ifelse(SF2 == 4, 75, 100)))),
      MH3 = ifelse(MH3 == 1, 100, ifelse(MH3 == 2, 80, ifelse(MH3 == 3, 60, ifelse(MH3 == 4, 40, ifelse(MH3 == 5, 20, 0))))),
      MH4 = ifelse(MH4 == 1, 0, ifelse(MH4 == 2, 20, ifelse(MH4 == 3, 40, ifelse(MH4 == 4, 60, ifelse(MH4 == 5, 80, 100)))))
    )
}

compute_sf12_domain_score <- function(data,
                                      GH1 = GH1,
                                      PF2 = PF2,
                                      PF4 = PF4,
                                      RP2 = RP2,
                                      RP3 = RP3,
                                      RE2 = RE2,
                                      RE3 = RE3,
                                      BP2 = BP2,
                                      MH3 = MH3,
                                      VT2 = VT2,
                                      MH4 = MH4,
                                      SF2 = SF2) {
  # Lage 8 domeneskår
  data <- data %>%
    mutate(
      PF = (PF2 + PF4) / 2,
      RP = (RP2 + RP3) / 2,
      BP = BP2,
      GH = GH1,
      VT = VT2,
      SF = SF2,
      RE = (RE2 + RE3) / 2,
      MH = (MH3 + MH4) / 2
    )
}

compute_sf12_component_score <- function(data,
                                         PF = PF,
                                         RP = RP,
                                         BP = BP,
                                         GH = GH,
                                         VT = VT,
                                         SF = SF,
                                         RE = RE,
                                         MH = MH) {
  # Lage fysisk sumskår (PCS12) og mental sumskår (MCS12) (0-100 skår)
  data <- data %>%
    mutate(
      PCS12 = (PF + RP + BP + GH) / 4,
      MCS12 = (VT + SF + RE + MH) / 4
    )
}

compute_sf12_drop_helper_variables <- function(data,
                                               GH1 = GH1,
                                               PF2 = PF2,
                                               PF4 = PF4,
                                               RP2 = RP2,
                                               RP3 = RP3,
                                               RE2 = RE2,
                                               RE3 = RE3,
                                               BP2 = BP2,
                                               MH3 = MH3,
                                               VT2 = VT2,
                                               MH4 = MH4,
                                               SF2 = SF2) {
  # 6. OBS! slettar alle hjelpevariablane. Utelat denne kommandoen om du vil sjå heile utrekninga*
  data <- data %>%
    select(
      -GH1, -PF2, -PF4, -RP2, -RP3, -RE2, -RE3, -BP2, -MH3, -VT2, -MH4, -SF2
    )
}
