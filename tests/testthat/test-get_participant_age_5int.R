ref <- as.Date("2025-06-01")

test_that("ages are binned into 5-year bands", {
  # Born 1990-01-01 and 1975-06-15: ages 35 and 49 on the reference date
  expect_equal(
    get_participant_age_5int(c("01019012345", "15067554321"), refDate = ref),
    c("35-39 years", "45-49 years")
  )
})

test_that("band edges are inclusive", {
  # Born 2007-06-01 turns 18 on the reference date; born 2000-06-02 is still 24
  expect_equal(
    get_participant_age_5int(c("01060712345", "02060012345"), refDate = ref, cutoff_2000 = 10L),
    c("18-24 years", "18-24 years")
  )
})

test_that("ages of 70 and over fall in the top band", {
  # Born 1950-01-01 (age 75) and 1955-06-01 (turns 70 on the reference date)
  expect_equal(
    get_participant_age_5int(c("01015012345", "01065512345"), refDate = ref),
    c("70 years +", "70 years +")
  )
})

test_that("ages under 18 are NA", {
  # Born 2010-01-01: age 15
  expect_true(is.na(get_participant_age_5int("01011012345", refDate = ref)))
})

test_that("SocIDs that lost a leading zero are left-padded", {
  expect_equal(get_participant_age_5int("1019012345", refDate = ref), "35-39 years")
})
