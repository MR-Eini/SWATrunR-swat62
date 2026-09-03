# Run with a working R installation, not the Git LFS pointer executables in R-Cran64.
root <- normalizePath("package-updates")
lib <- file.path(root, "library")
dir.create(lib, showWarnings = FALSE)
.libPaths(c(lib, .libPaths()))
packages <- c("SWATreadR", "SWATrunR", "SWATdoctR", "SWATtunR")
paths <- file.path(root, "repos", packages)
descriptions <- lapply(paths, function(p) read.dcf(file.path(p, "DESCRIPTION")))
imports <- unique(unlist(lapply(descriptions, function(d) {
  trimws(gsub("\\s*\\([^)]*\\)", "", unlist(strsplit(d[1, "Imports"], ","))))
})))
missing <- setdiff(c(imports, "testthat"), c(rownames(installed.packages()), packages))
if (length(missing)) install.packages(missing, lib = lib, repos = "https://cloud.r-project.org")
for (path in paths) {
  withCallingHandlers(install.packages(path, repos = NULL, type = "source", lib = lib),
    warning = function(w) stop(conditionMessage(w)))
}
cat("Installed into", lib, "\n")
cat("Start a fresh R session and prepend this path with .libPaths().\n")
