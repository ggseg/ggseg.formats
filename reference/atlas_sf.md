# Get atlas data for 2D rendering

Returns sf data joined with core region info and palette colours. This
is the interception point used by ggseg for plotting: it always returns
sf geometry, converting from the polygon representation when needed.

## Usage

``` r
atlas_sf(atlas)
```

## Arguments

- atlas:

  a ggseg_atlas object

## Value

sf data.frame ready for plotting

## Examples

``` r
sf_data <- atlas_sf(dk())
head(sf_data)
#> Simple feature collection with 6 features and 6 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 245.421 ymin: 0 xmax: 4499.276 ymax: 232.5186
#> CRS:           NA
#>          label     view hemi region lobe                       geometry colour
#> 186 lh_unknown  lateral <NA>   <NA> <NA> MULTIPOLYGON (((926.5936 60...   <NA>
#> 187 lh_unknown   medial <NA>   <NA> <NA> MULTIPOLYGON (((1782.84 18....   <NA>
#> 188 rh_unknown  lateral <NA>   <NA> <NA> MULTIPOLYGON (((3849.766 60...   <NA>
#> 189 rh_unknown   medial <NA>   <NA> <NA> MULTIPOLYGON (((4318.844 20...   <NA>
#> 190 lh_unknown inferior <NA>   <NA> <NA> MULTIPOLYGON (((367.1256 13...   <NA>
#> 191 rh_unknown inferior <NA>   <NA> <NA> MULTIPOLYGON (((3190.519 5....   <NA>
```
