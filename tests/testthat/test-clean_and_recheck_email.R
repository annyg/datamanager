df <- tibble::tibble(
  id = 1:3,
  email = c("john.doe@gamil.com", "valid@example.org", "user@hotnail.com")
)

test_that(".append = TRUE keeps the original columns and adds the recheck columns", {
  out <- clean_and_recheck_email(df, email, .append = TRUE)

  expect_true(all(c("id", "email") %in% names(out)))
  expect_true(all(
    c("pre_flag", "pre_reason", "corrected_email",
      "correction_log", "post_flag", "post_reason") %in% names(out)
  ))
  expect_equal(nrow(out), nrow(df))
})

test_that(".append = FALSE drops everything but email + recheck columns", {
  out <- clean_and_recheck_email(df, email, .append = FALSE)

  expect_false("id" %in% names(out))
  expect_true("email" %in% names(out))
  expect_equal(nrow(out), nrow(df))
})

test_that("typos are flagged pre-correction and cleared post-correction", {
  out <- clean_and_recheck_email(df, email, .append = TRUE)

  # gamil.com is flagged pre, corrected to gmail.com, and clean post
  expect_true(out$pre_flag[1])
  expect_equal(out$corrected_email[1], "john.doe@gmail.com")
  expect_false(out$post_flag[1])
})

test_that("a valid email round-trips with no flags or corrections", {
  out <- clean_and_recheck_email(df, email, .append = TRUE)

  expect_false(out$pre_flag[2])
  expect_true(is.na(out$corrected_email[2]))
  expect_false(out$post_flag[2])
})
