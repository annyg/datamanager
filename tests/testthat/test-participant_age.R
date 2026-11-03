ref <- as.Date("2025-06-01")

test_that("get_participant_birthdate parses ddmmyy from the SocID", {
  out <- get_participant_birthdate(c("01019012345", "15067554321"))

  expect_equal(as.Date(out), as.Date(c("1990-01-01", "1975-06-15")))
})

test_that("cutoff_2000 decides the century", {
  out <- get_participant_birthdate(c("01010512345", "01012212345", "01012312345"))
  expect_equal(as.Date(out), as.Date(c("2005-01-01", "2022-01-01", "1923-01-01")))

  out <- get_participant_birthdate("01012312345", cutoff_2000 = 30L)
  expect_equal(as.Date(out), as.Date("2023-01-01"))
})

test_that("SocIDs that lost a leading zero are left-padded before parsing", {
  # 01019012345 stored as a number becomes 1019012345 (10 digits)
  expect_equal(
    as.Date(get_participant_birthdate("1019012345")),
    as.Date("1990-01-01")
  )
})

test_that("get_participant_age returns completed years by default", {
  # Born 15 June 1975: turns 50 two weeks after the reference date
  expect_equal(get_participant_age(c("01019012345", "15067554321"), refDate = ref), c(35, 49))
})

test_that("get_participant_age supports month, week and day units", {
  id <- "01019012345"
  expect_equal(get_participant_age(id, refDate = as.Date("1990-03-01"), unit = "month"), 2)
  expect_equal(get_participant_age(id, refDate = as.Date("1990-01-15"), unit = "week"), 2)
  expect_equal(get_participant_age(id, refDate = as.Date("1990-01-15"), unit = "day"), 14)
})

test_that("get_participant_age returns NA for an unknown unit", {
  expect_output(out <- get_participant_age("01019012345", unit = "decade"), "must be one of")
  expect_true(is.na(out))
})

test_that("calc_age matches get_participant_age", {
  ids <- c("01019012345", "15067554321", "1019012345")
  for (unit in c("year", "month", "week", "day")) {
    expect_equal(
      calc_age(ids, refDate = ref, unit = unit),
      get_participant_age(ids, refDate = ref, unit = unit)
    )
  }
})
