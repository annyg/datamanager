test_that("spaces, parentheses and country code are stripped", {
  expect_equal(prep_phone("(+47) 22 33 44 55"), "22334455")
  expect_equal(prep_phone("+47 900 11 222"), "90011222")
  expect_equal(prep_phone("  22334455 "), "22334455")
})

test_that("is vectorised and propagates NA", {
  expect_equal(prep_phone(c("22334455", NA)), c("22334455", NA))
})
