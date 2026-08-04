## R CMD check results

0 errors | 0 warnings | 0 notes

## Notes for the reviewer

- This release fixes a `plot()` panelling bug, rebuilds the bundled atlases with
  lighter geometry, and makes all previously guarded examples executable.

- The package is written in British English; `DESCRIPTION` now declares
  `Language: en-GB`. Words remaining in `inst/WORDLIST` are neuroanatomical
  terms, package names, and author initials and titles quoted verbatim from the
  cited publications (which use US spelling, e.g. "labeling").

- There are no published references describing the methods in this package
  itself. The bundled atlases are attributions to existing parcellations, and
  those references are cited on each atlas' help page (`?dk`, `?aseg`,
  `?tracula`, `?suit`).
