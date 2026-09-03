# Reproducing the supplied-workspace experiment

These scripts run from the original `SWAT-Workflow-R-main` workspace root. They expect the layout documented in `package-updates/STATUS.md`: package clones under `package-updates/repos`, untouched pinned inputs under `package-updates/models/legacy`, and the official executable under `package-updates/tools/ifort62`.

Run `install-local.R`, then `prepare-reference.R` once, `test-local.R`, and `integration.R`. Use a fresh R process for installation and testing. The model and executable are deliberately not bundled in these package repositories. `test-summary.json` records the completed experiment; the unit tests under `tests/testthat` are self-contained and do not need the model.
