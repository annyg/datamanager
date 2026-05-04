test_that("short SocIDs are left-padded to 11 characters", {
  result <- prep_SocID("12345")
  expect_equal(result, "00000012345")
  expect_equal(nchar(result), 11L)
})

test_that("already-correct SocIDs pass through unchanged", {
  expect_equal(prep_SocID("12345678901"), "12345678901")
})

test_that("vector input is handled element-wise", {
  expect_equal(
    prep_SocID(c("1", "12345", "12345678901")),
    c("00000000001", "00000012345", "12345678901")
  )
})

test_that("numeric input is coerced and padded", {
  expect_equal(prep_SocID(12345), "00000012345")
})
