# SWATrunR: old and updated versions

These version tags expose the source before the SWAT+ 62 update and the tested updated source in this same repository. They do not replace or rewrite the original Git history.

| Snapshot | Package version | Git tag |
| --- | --- | --- |
| Old source baseline | 1.1.0.9017 | [before-swat62-update](https://github.com/MR-Eini/SWATrunR-swat62/tree/before-swat62-update) |
| Updated development version | 1.1.0.9019 | [swat62-v1.1.0.9019](https://github.com/MR-Eini/SWATrunR-swat62/tree/swat62-v1.1.0.9019) |

The old tag points to commit [`c66a60eb767d5b8c8f1790959a195cbd08a97259`](https://github.com/MR-Eini/SWATrunR-swat62/commit/c66a60eb767d5b8c8f1790959a195cbd08a97259), the exact upstream source commit used before these edits. It is a source baseline for this update, not a claim that every bundled package dates from three years ago.

The baseline is upstream's `remove_legacy` branch, which matches the bundled package version 1.1.0.9017. The bundled workflow had one additional library-path propagation change for parallel workers; equivalent behavior is retained in the update.

## Review the differences on GitHub

1. Open the [old-to-updated comparison](https://github.com/MR-Eini/SWATrunR-swat62/compare/before-swat62-update...swat62-v1.1.0.9019?w=1).
2. Scroll to the changed files. GitHub marks removed lines red and added lines green.
3. Open individual files or commits to inspect each change. Where available, select the split view to see old and new code side by side.

The comparison above hides whitespace-only changes, which is especially useful for files with different Windows line endings. The [complete comparison](https://github.com/MR-Eini/SWATrunR-swat62/compare/before-swat62-update...swat62-v1.1.0.9019) includes every change. The [commit history](https://github.com/MR-Eini/SWATrunR-swat62/commits/main) shows the incremental updates.

Both tags are fixed snapshots. Future versions should receive new version tags; `main` remains the current working branch. These are maintained development versions, not releases issued by the original authors.

## Main changes

- Read and edit named control fields, including revision 62 print options and file.cio calibration entries.
- Use the current readr interface and shared output readers; preserve library paths in parallel workers and clean workers up after execution.
- Check executable exit status and successful completion, validate run indices and integer plant maturity, and preserve calibration-value precision.
- Require SWATreadR 0.1.0.9012 for the corrected average-annual basin reader.

## Tested scope

The updated packages ran the supplied migrated reference model with the Windows Intel SWAT+ revision 62 executable. The supplied verification, discharge calibration/validation, sensitivity, crop and water-yield workflows produced outputs. The final source test run covered all seven package test directories and passed 78 expectations. These results do not establish compatibility for every model, executable or optional process; scientific calibration acceptance has not been achieved.

See [COMPATIBILITY.md](COMPATIBILITY.md) and [the workflow results](compatibility/workflow-summary.json) for the tests and limitations. Model input migration and updating the old project-generation layer are separate from these package source comparisons.
