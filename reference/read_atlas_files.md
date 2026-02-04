# Read in atlas data from all subjects

Recursively reads in all stats files for an atlas (given a unique
character string), for all subjects in the subjects directory. Will add
hemisphere and subject id to the data.

## Usage

``` r
read_atlas_files(subjects_dir, atlas)
```

## Arguments

- subjects_dir:

  FreeSurfer subject directory

- atlas:

  unique character combination identifying the atlas

## Value

tibble with stats information for subjects from FreeSurfer

## Examples

``` r
if (FALSE) { # \dontrun{
subj_dir <- "/path/to/freesurfer/7.2.0/subjects/"
read_atlas_files(subj_dir, "aseg.stats")

read_atlas_files(subj_dir, "lh.aparc.stats")
} # }
```
