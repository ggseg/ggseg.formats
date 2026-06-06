# Migrate atlas `.rda` files to the sf-optional polygon format

Walks a directory of `.rda` files, finds every `ggseg_atlas` object
inside them, and rewrites their 2D geometry into the single `geom` slot.
By default the geometry is stored as `brain_polygons` (sf-optional); any
legacy `sf` / `polygons` slots are dropped. Pass `keep_sf = TRUE` to
store the geometry as sf instead.

## Usage

``` r
migrate_atlas_files(path = "data", keep_sf = FALSE, quiet = FALSE)
```

## Arguments

- path:

  Directory containing `.rda` files to migrate. Defaults to `"data"`,
  the conventional location in R packages.

- keep_sf:

  If `TRUE`, the geometry is stored in `geom` as sf. Default `FALSE` —
  the geometry is stored as `brain_polygons` (sf-optional).

- quiet:

  If `TRUE`, suppress per-file status messages.

## Value

Invisibly, a character vector of paths to the files that were rewritten.

## Details

Intended for downstream atlas-package maintainers across the ggsegverse
ecosystem: run once against your `data/` directory, then drop `sf` from
DESCRIPTION Imports.

## Examples

``` r
if (FALSE) { # \dontrun{
# In an atlas package, from the package root:
ggseg.formats::migrate_atlas_files("data")
} # }
```
