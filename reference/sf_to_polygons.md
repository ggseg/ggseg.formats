# Convert an sf atlas geometry to the sf-optional polygon format

Extracts coordinates from an sf-backed atlas geometry table and returns
a nested tibble keyed by `label`. Each row carries a `geometry`
list-column containing the per-view, per-ring point coordinates needed
to render with
[`ggplot2::geom_polygon()`](https://ggplot2.tidyverse.org/reference/geom_polygon.html)
(using the `subgroup` aesthetic for holes).

## Usage

``` r
sf_to_polygons(sf_data)
```

## Arguments

- sf_data:

  An sf-class data.frame with columns `label`, `view`, `geometry` (sfc
  of MULTIPOLYGON).

## Value

A tibble with one row per `label` and a `geometry` list-column. Each
nested element is a tibble with columns `view`, `x`, `y`, `group`
(disjoint polygon piece within a label/view), `subgroup` (ring within a
piece; first = exterior, rest = holes).

Internal conversion primitive. For the atlas-level public API use
[`as_polygon_atlas()`](https://ggsegverse.github.io/ggseg.formats/reference/as_polygon_atlas.md)
/
[`atlas_polygons()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_polygons.md).
