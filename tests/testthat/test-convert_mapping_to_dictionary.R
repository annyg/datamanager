mapping <- "Smoker : 'Smoking status' <- NUMERIC :: royk\n0 = 'No' <- 0\n1 = 'Yes' <- 1\n"

test_that("convert_mapping_to_dictionary() uses the quoted label and clean value labels", {
  expect_equal(
    convert_mapping_to_dictionary(mapping),
    list(Smoker = list(label = "Smoking status", values = list("0" = "No", "1" = "Yes")))
  )
})

test_that("convert_mapping_to_dictionary() handles several variables, optional type and indentation", {
  text <- paste(
    "Smoker : 'Smoking status' <- NUMERIC :: royk",
    "  0 = 'No' <- 0",
    "  1 = 'Yes' <- 1",
    "",
    "Visits : 'Number of visits' :: besok",
    "  1 = '1 - 3 times' <- 1_3",
    "  999 = 'Missing' <- _",
    "Comment : 'Free-text comment' <- STRING :: kommentar",
    sep = "\n"
  )

  out <- convert_mapping_to_dictionary(text)

  expect_named(out, c("Smoker", "Visits", "Comment"))
  expect_equal(out$Visits$label, "Number of visits")
  expect_equal(out$Visits$values, list("1" = "1 - 3 times", "999" = "Missing"))
  expect_equal(out$Comment, list(label = "Free-text comment", values = list()))
})

test_that("convert_mapping_to_dictionary() ignores value lines before any header", {
  out <- convert_mapping_to_dictionary("0 = 'Orphan' <- 0\nSmoker : 'Smoking status' :: royk")

  expect_equal(out, list(Smoker = list(label = "Smoking status", values = list())))
})

test_that("convert_mapping_to_dataframe() keeps values aligned with their rows", {
  expect_equal(
    convert_mapping_to_dataframe(mapping),
    data.frame(
      Variable = c("Smoker", "Smoker", "Smoker"),
      Label = c("Smoking status", "No", "Yes"),
      Value_Label = c(NA, "0", "1"),
      stringsAsFactors = FALSE
    )
  )
})

test_that("convert_mapping_to_dataframe() emits a header row for each variable", {
  text <- "A : 'First' :: a\n1 = 'One' <- 1\nB : 'Second' :: b\n2 = 'Two' <- 2\n"

  out <- convert_mapping_to_dataframe(text)

  expect_equal(out$Variable, c("A", "A", "B", "B"))
  expect_equal(out$Label, c("First", "One", "Second", "Two"))
  expect_equal(out$Value_Label, c(NA, "1", NA, "2"))
})
