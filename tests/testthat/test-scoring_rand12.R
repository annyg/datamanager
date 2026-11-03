items <- c(
  "Health_rating_now", "Moderate_activity4w", "Stairs4w",
  "Physical_health_lessthanwanted4w", "Physical_health_limited4w",
  "Psychological_health_lessthanwanted4w", "Psychological_healthlimitation4w",
  "Pain_limited_activities4w", "Relaxed_feeling4w", "Energetic_feeling4w",
  "Depressed_feeling4w", "PhysicalAndEmotional_Social4w"
)

make_rand <- function(...) {
  m <- do.call(rbind, list(...))
  colnames(m) <- items
  as.data.frame(m)
}

best  <- c(4, 0, 0, 0, 0, 0, 0, 0, 5, 5, 0, 0)
worst <- c(0, 2, 2, 1, 1, 1, 1, 4, 0, 0, 5, 4)

test_that("best and worst possible answers score 100 and 0", {
  out <- scoring_rand12_unweighted(make_rand(best, worst))

  expect_equal(out$PCS12_unwh, c(100, 0))
  expect_equal(out$MCS12_unwh, c(100, 0))
})

test_that("domain scores average their items", {
  # PF: (50 + 100)/2, RP: (0 + 100)/2, BP: 75, GH: 50
  # VT: 60, SF: 25, RE: (100 + 0)/2, MH: (MH3 40 + MH4 80)/2
  mixed <- c(2, 1, 0, 1, 0, 0, 1, 1, 2, 3, 1, 3)
  out <- scoring_rand12_unweighted(make_rand(mixed))

  expect_equal(c(out$PF, out$RP, out$BP, out$GH), c(75, 50, 75, 50))
  expect_equal(c(out$VT, out$SF, out$RE, out$MH), c(60, 25, 50, 60))
  expect_equal(out$PCS12_unwh, mean(c(75, 50, 75, 50)))
  expect_equal(out$MCS12_unwh, mean(c(60, 25, 50, 60)))
})

test_that("out-of-range answers are treated as missing", {
  bad <- best
  bad[2] <- 9   # Moderate_activity4w: valid range is 0-2
  bad[12] <- 7  # PhysicalAndEmotional_Social4w: valid range is 0-4
  out <- scoring_rand12_unweighted(make_rand(bad))

  # PF falls back to the remaining valid item; SF becomes NA and is skipped
  expect_equal(out$PF, 100)
  expect_true(is.na(out$SF))
  expect_equal(out$MCS12_unwh, 100)
})

test_that("raw items are kept and auxiliary columns removed", {
  out <- scoring_rand12_unweighted(make_rand(best))

  expect_true(all(items %in% names(out)))
  expect_false(any(c("GH1", "PF2", "MH4", "SF2") %in% names(out)))
  expect_true(all(c("PF", "RP", "BP", "GH", "VT", "SF", "RE", "MH") %in% names(out)))
})

test_that("custom item column names can be supplied", {
  df <- make_rand(best, worst)
  names(df) <- paste0("r", seq_along(items))

  out <- scoring_rand12_unweighted(
    df,
    RAND36_1 = r1, RAND36_3b = r2, RAND36_3d = r3, RAND36_4b = r4,
    RAND36_4c = r5, RAND36_5b = r6, RAND36_5c = r7, RAND36_8 = r8,
    RAND36_9d = r9, RAND36_9e = r10, RAND36_9f = r11, RAND36_10 = r12
  )

  expect_equal(out$PCS12_unwh, c(100, 0))
  expect_equal(out$MCS12_unwh, c(100, 0))
})
