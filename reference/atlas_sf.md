# Get atlas data for 2D rendering

Returns sf data joined with core region info and palette colours.

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
sf_data <- atlas_sf(dk)
head(sf_data)
#> Simple feature collection with 6 features and 6 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 252.3839 ymin: 20.30279 xmax: 2552.774 ymax: 375.349
#> CRS:           NA
#>                        label     view hemi                            region
#> 1                lh_bankssts inferior left banks of superior temporal sulcus
#> 2                lh_bankssts  lateral left banks of superior temporal sulcus
#> 3                lh_bankssts superior left banks of superior temporal sulcus
#> 4 lh_caudalanteriorcingulate   medial left         caudal anterior cingulate
#> 5     lh_caudalmiddlefrontal inferior left             caudal middle frontal
#> 6     lh_caudalmiddlefrontal  lateral left             caudal middle frontal
#>        lobe                       geometry  colour
#> 1  temporal MULTIPOLYGON (((534.4782 21... #196428
#> 2  temporal MULTIPOLYGON (((1121.478 12... #196428
#> 3  temporal MULTIPOLYGON (((2448.464 20... #196428
#> 4 cingulate MULTIPOLYGON (((1921.971 20... #7D64A0
#> 5   frontal MULTIPOLYGON (((272.7879 22... #641900
#> 6   frontal MULTIPOLYGON (((911.758 248... #641900
```
