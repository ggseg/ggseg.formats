# Migrating atlas packages to sf-optional

``` r

library(ggseg.formats)
```

Since the **sf-optional** milestone (ggseg 2.2), a `ggseg_atlas` stores
its 2D geometry in a single `geom` slot that can hold either an `sf`
table or the sf-optional `brain_polygons` representation. The polygon
form renders identically through the `geom_polygon`-based path in ggseg,
but carries no dependency on the sf class machinery — so atlases keep
working on wasm builds and air-gapped installs where sf (and its
GDAL/GEOS/PROJ system libraries) cannot be installed.

This vignette is for maintainers of downstream atlas packages
(`ggsegFreeSurfer`, `ggsegSchaefer`, `ggsegGlasser`, …). Your package
ships `brain_atlas`/`ggseg_atlas` objects as `.rda` files under `data/`.
Migrating means rewriting those files once so the geometry is stored as
polygons, then dropping sf from your `DESCRIPTION`.

## The recipe

From the root of your atlas package, run:

``` r

# 1. rewrite every atlas in data/ into the polygon format
ggseg.formats::migrate_atlas_files("data")

# 2. drop sf from DESCRIPTION (it is no longer needed at install or run time)
usethis::use_package("sf", type = "Suggests")

# 3. rebuild the package data documentation and reinstall
devtools::document()
```

That is the whole migration. Commit the rewritten `data/*.rda`, push,
and release.

## What `migrate_atlas_files()` does

It walks the directory, loads each `.rda`, finds every atlas object
inside, converts its `geom` to `brain_polygons`, drops any legacy
`sf`/`polygons` slots, and saves the file back with `xz` compression.
Files with nothing to migrate are left untouched, and it reports what it
changed:

``` r

ggseg.formats::migrate_atlas_files("data")
#> ✔ Migrated `dk.rda`.
#> ✔ Migrated `aseg.rda`.
#> ℹ Skipped `palette.rda` (nothing to migrate).
```

The conversion reads sf coordinates, so **sf must be installed on the
machine you run the migration from**. This is a one-time maintainer
step; the published package no longer needs sf.

It is idempotent — running it twice is a no-op on already-migrated
files, so it is safe to wire into a `data-raw/` build script.

### Keeping sf instead

If your atlas package genuinely needs sf geometry (for example it
exposes geometric operations), pass `keep_sf = TRUE` to normalise
everything into the single `geom` slot as sf rather than polygons:

``` r

ggseg.formats::migrate_atlas_files("data", keep_sf = TRUE)
```

## Verifying the result

After migrating, the geometry is sf-optional and round-trips losslessly.
You can rehydrate sf on demand with
[`as_sf_atlas()`](https://ggsegverse.github.io/ggseg.formats/reference/as_sf_atlas.md),
and go back with
[`as_polygon_atlas()`](https://ggsegverse.github.io/ggseg.formats/reference/as_polygon_atlas.md):

``` r

poly <- as_polygon_atlas(dk())
is_atlas_polygon(poly)
#> [1] TRUE

atlas_labels(poly) |>
  head()
#> [1] "lh_bankssts"                "lh_caudalanteriorcingulate"
#> [3] "lh_caudalmiddlefrontal"     "lh_corpuscallosum"         
#> [5] "lh_cuneus"                  "lh_entorhinal"
```

A migrated atlas plots through ggseg with no sf installed. If a
lite-only install meets an atlas that is *still* sf-backed,
[`as_polygon_atlas()`](https://ggsegverse.github.io/ggseg.formats/reference/as_polygon_atlas.md)
converts it on the fly when sf is available, and otherwise aborts with a
message naming
[`migrate_atlas_files()`](https://ggsegverse.github.io/ggseg.formats/reference/migrate_atlas_files.md)
— the signal that the atlas package itself needs the one-time migration
above.
