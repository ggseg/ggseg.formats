# Check ggseg atlas class

These functions check both the class tag and structural validity by
passing the object through
[`ggseg_atlas()`](https://ggseg.github.io/ggseg.formats/reference/ggseg_atlas.md).
An object that carries the right class but fails validation returns
`FALSE`.

## Usage

``` r
is_ggseg_atlas(x)

is_cortical_atlas(x)

is_subcortical_atlas(x)

is_tract_atlas(x)

is_brain_atlas(x)
```

## Arguments

- x:

  an object

## Value

logical
