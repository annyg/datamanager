test_that("names are normalised to title case", {
  expect_equal(prep_name("anders nygaard"), "Anders Nygaard")
  expect_equal(prep_name("ANDERS NYGAARD"), "Anders Nygaard")
})

test_that("internal and surrounding whitespace is squished", {
  expect_equal(prep_name("  anders    nygaard  "), "Anders Nygaard")
})

test_that("single-word input is handled", {
  expect_equal(prep_name("anders"), "Anders")
})

test_that("output length matches input length", {
  expect_length(prep_name(c("anders", "ola", "kari")), 3L)
})
