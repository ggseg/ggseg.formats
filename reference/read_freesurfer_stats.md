# Read in raw FreeSurfer stats file

FreeSurfer atlas stats files have a format that can be difficult to
easily read in to R. This function takes a raw stats-file from the
subjects directory and reads it in as a data.frame.

## Usage

``` r
read_freesurfer_stats(path, rename = TRUE)
```

## Arguments

- path:

  path to stats file

- rename:

  logical. rename headers for ggseg compatibility

## Value

tibble with stats information for subjects from FreeSurfer

## Examples

``` r
if (FALSE) { # \dontrun{
subj_dir <- "/path/to/freesurfer/7.2.0/subjects/"
aseg_stats <- file.path(subj_dir, "bert/stats/aseg.stats")
read_freesurfer_stats(aseg_stats)
} # }
```
