# Run from the SWAT-Workflow-R-main directory after installing the local packages.
# This migration is deliberately limited to the pinned, non-carbon reference model.
.libPaths(c(normalizePath("package-updates/library"), .libPaths()))
source_path <- normalizePath("package-updates/models/legacy")
target_path <- file.path(dirname(source_path), "rev62-reference")
if (dir.exists(target_path)) stop("Target already exists; choose a new migration directory.")
cio <- readLines(file.path(source_path, "file.cio"))
basin <- grep("^basin[[:space:]]", cio)
stopifnot(length(basin) == 1L)
fields <- strsplit(trimws(cio[basin]), "[[:space:]]+")[[1L]]
stopifnot(length(fields) == 3L)
codes <- readLines(file.path(source_path, "codes.bsn"))
stopifnot(SWATreadR::swat_control_get(codes, "carbon") == "0")
cio[basin] <- paste(c(fields, "null"), collapse = " ")
print <- readLines(file.path(source_path, "print.prt"))
print <- sub("dbout", "use_obj_labels", print, fixed = TRUE)
print <- sub("soilout", "crop_yld", print, fixed = TRUE)
# Revision 62 no longer accepts region_cha; region_sd_cha remains available.
print <- print[!grepl("^region_cha[[:space:]]", print)]
print <- SWATreadR::swat_control_set(print, c(use_obj_labels = "y"))
plants <- SWATreadR::read_swat(file.path(source_path, "plants.plt"))
stopifnot(all(c("days_mat", "yrs_mat") %in% names(plants)))
dir.create(target_path)
files <- list.files(source_path, full.names = TRUE)
files <- files[!grepl("\\.exe$", files, ignore.case = TRUE) & !dir.exists(files)]
stopifnot(all(file.copy(files, target_path)))
writeLines(cio, file.path(target_path, "file.cio"))
writeLines(print, file.path(target_path, "print.prt"))
SWATreadR::write_swat(plants, file.path(target_path, "plants.plt"), overwrite = TRUE)
exe <- "package-updates/tools/ifort62/swatplus-62-ifo-win_amd64-Rel.exe"
stopifnot(file.copy(exe, target_path))
cat("Prepared", normalizePath(target_path), "\n")
