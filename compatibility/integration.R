# Deterministic integration checks on the supplied model. Not a scientific calibration.
.libPaths(c(normalizePath("package-updates/library"), .libPaths()))
library(SWATrunR)
library(SWATtunR)
library(SWATdoctR)
model <- normalizePath("package-updates/models/rev62-reference")
output <- list(flow = define_output(file = "channel_sd_day", variable = "flo_out",
                                    unit = 2),
               runoff = define_output(file = "basin_wb_day", variable = "surq_gen", unit = 1))
par <- tibble::tibble("cn2.hru | change = abschg" = c(0, 2))
result <- run_swatplus(project_path = model, output = output, parameter = par,
  start_date = "2004-01-01", end_date = "2007-12-31", start_date_print = "2007-01-01",
  n_thread = 2, refresh = TRUE, keep_folder = TRUE, quiet = TRUE, time_out = 120)
saveRDS(result, "package-updates/artifacts/rev62-two-run.rds")
str(result$simulation)
stopifnot(is.data.frame(result$simulation$flow), nrow(result$simulation$flow) == 365L)
stopifnot(all(is.finite(as.matrix(result$simulation$flow[-1L]))),
  any(result$simulation$flow$run_1 > 0),
  any(result$simulation$runoff$run_1 != result$simulation$runoff$run_2))
verification <- run_swat_verification(model, outputs = c("wb", "mgt", "plt"),
  start_date = "2004-01-01", end_date = "2007-12-31", years_skip = 3,
  nostress = 0, keep_folder = TRUE)
stopifnot(is.list(verification), nrow(verification$basin_wb_day) == 365L,
          nrow(verification$mgt_out) > 0L, nrow(verification$hru_pw_day) == 365L * nrow(verification$hru_wb_aa))
saveRDS(verification, "package-updates/artifacts/rev62-verification.rds")
write_cal_file(par, model, "package-updates/artifacts/calibration-export", i_run = 1:2)
cat("INTEGRATION PASSED: two parallel parameter runs, verification, calibration export\n")
