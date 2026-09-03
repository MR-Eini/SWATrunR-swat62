test_that("setup finds chg by name and preserves extra file and print settings", {
  path <- tempfile(); dir.create(path)
  writeLines(c("fixture", "simulation time.sim print.prt null object.cnt null",
    "basin codes.bsn parameters.bsn carbon.bsn", "chg cal_parms.cal null soft.cal extra.cal"),
    file.path(path, "file.cio"))
  writeLines(c("fixture", "day_start yrc_start day_end yrc_end step", "0 2004 0 2007 0"),
    file.path(path, "time.sim"))
  print <- c("fixture", "nyskip day_start yrc_start day_end yrc_end interval", "0 0 0 0 0 1",
    "aa_int_cnt", "0", "csvout dbout cdfout future_flag", "n n n y",
    "soilout mgtout hydcon fdcout", "n n n n", "gwflow_out", "y",
    "objects daily monthly yearly avann", "channel_sd n n n n")
  writeLines(print, file.path(path, "print.prt"))
  output <- tibble::tibble(file = "channel_sd", file_full = "channel_sd_day.txt", time_interval = "day")
  setup <- setup_swatplus(path, NULL, output, "2004-01-01", "2007-12-31", "2007-01-01", NULL, NULL)
  expect_equal(setup$file.cio[4], "chg cal_parms.cal calibration.cal soft.cal extra.cal")
  expect_equal(setup$file.cio[3], "basin codes.bsn parameters.bsn carbon.bsn")
  expect_equal(tail(setup$print.prt, 1), "channel_sd y n n n")
  expect_equal(SWATreadR::swat_control_get(setup$print.prt, "future_flag"), c(future_flag = "y"))
  expect_equal(get_value_range("%in% c(1, 3)"), c(1, 3))
})
