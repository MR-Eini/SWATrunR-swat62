.libPaths(c(normalizePath("package-updates/library"), .libPaths()))
for (package in c("SWATreadR", "SWATrunR", "SWATdoctR", "SWATtunR")) {
  path <- file.path("package-updates/repos", package)
  pkgload::load_all(path, quiet = TRUE)
  testthat::test_dir(file.path(path, "tests/testthat"), package = package,
                     reporter = "summary", stop_on_failure = TRUE)
}
