test_that("shared output parsing preserves records before unit selection", {
  path <- tempfile(); dir.create(path)
  on.exit(unlink(path, recursive = TRUE))
  writeLines(c("synthetic fixture", "jday mon day yr unit gis_id name lai", "units",
               "1 1 1 2007 1 0 first 1.25", "2 1 2 2007 2 0 second 2.5"),
             file.path(path, "hru_pw_day.txt"))
  output <- tibble::tibble(file_full = "hru_pw_day.txt", variable = "lai", unit = list(2L))
  result <- read_output_i(output, NULL, path,
                         date_cols = c("jday", "mon", "day", "yr"), n_skip = 3L)
  expect_equal(nrow(result), 1L)
  expect_equal(result$unit, 2L)
  expect_equal(result$lai, 2.5)
  expect_equal(result$day, 2L)
})

test_that("fallback outputs use explicit whitespace and reject malformed rows", {
  path <- tempfile(); dir.create(path)
  on.exit(unlink(path, recursive = TRUE))
  file <- file.path(path, "other.txt")
  writeLines(c("synthetic fixture", "units", "1 2007 1 2.5", "2 2007 2 3.5"), file)
  output <- tibble::tibble(file_full = "other.txt", variable = "value", unit = list(1:2))
  cols <- c("jday", "yr", "unit", "value")
  result <- read_output_i(output, cols, path, date_cols = c("jday", "yr"), n_skip = 2)
  expect_equal(result$value, c(2.5, 3.5))
  writeLines(c("synthetic fixture", "units", "1 2007 1 2.5", "2 2007 2"), file)
  expect_error(read_output_i(output, cols, path, date_cols = c("jday", "yr"), n_skip = 2),
               "Cannot safely parse|mismatch")
})
