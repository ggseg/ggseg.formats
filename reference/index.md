# Package index

## ggseg atlas

Create and inspect ggseg atlas objects.

- [`is_ggseg3d_atlas()`](https://ggseg.github.io/ggseg.formats/reference/is_ggseg3d_atlas.md)
  : Check if object is a legacy ggseg3d atlas

## Legacy conversion

Convert old ggseg/ggseg3d atlases to the unified ggseg_atlas format.

- [`convert_legacy_brain_atlas()`](https://ggseg.github.io/ggseg.formats/reference/convert_legacy_brain_atlas.md)
  [`unify_legacy_atlases()`](https://ggseg.github.io/ggseg.formats/reference/convert_legacy_brain_atlas.md)
  **\[superseded\]** : Convert legacy ggseg atlases to ggseg_atlas
  format

## Accessors

Query atlas contents without reaching into slots directly.

- [`atlas_region_remove()`](https://ggseg.github.io/ggseg.formats/reference/atlas_manipulation.md)
  [`atlas_region_contextual()`](https://ggseg.github.io/ggseg.formats/reference/atlas_manipulation.md)
  [`atlas_region_rename()`](https://ggseg.github.io/ggseg.formats/reference/atlas_manipulation.md)
  [`atlas_region_keep()`](https://ggseg.github.io/ggseg.formats/reference/atlas_manipulation.md)
  [`atlas_core_add()`](https://ggseg.github.io/ggseg.formats/reference/atlas_manipulation.md)
  [`atlas_view_remove()`](https://ggseg.github.io/ggseg.formats/reference/atlas_manipulation.md)
  [`atlas_view_keep()`](https://ggseg.github.io/ggseg.formats/reference/atlas_manipulation.md)
  [`atlas_view_remove_region()`](https://ggseg.github.io/ggseg.formats/reference/atlas_manipulation.md)
  [`atlas_view_remove_small()`](https://ggseg.github.io/ggseg.formats/reference/atlas_manipulation.md)
  [`atlas_view_gather()`](https://ggseg.github.io/ggseg.formats/reference/atlas_manipulation.md)
  [`atlas_view_reorder()`](https://ggseg.github.io/ggseg.formats/reference/atlas_manipulation.md)
  : Manipulate brain atlas regions and views
- [`atlas_meshes()`](https://ggseg.github.io/ggseg.formats/reference/atlas_meshes.md)
  : Get atlas meshes for 3D rendering
- [`atlas_sf()`](https://ggseg.github.io/ggseg.formats/reference/atlas_sf.md)
  : Get atlas data for 2D rendering
- [`atlas_vertices()`](https://ggseg.github.io/ggseg.formats/reference/atlas_vertices.md)
  : Get atlas vertices for 3D rendering

## Atlas manipulation

Pipe-friendly functions for subsetting regions, managing views, and
enriching metadata. All return a new `ggseg_atlas`.

- [`atlas_region_remove()`](https://ggseg.github.io/ggseg.formats/reference/atlas_manipulation.md)
  [`atlas_region_contextual()`](https://ggseg.github.io/ggseg.formats/reference/atlas_manipulation.md)
  [`atlas_region_rename()`](https://ggseg.github.io/ggseg.formats/reference/atlas_manipulation.md)
  [`atlas_region_keep()`](https://ggseg.github.io/ggseg.formats/reference/atlas_manipulation.md)
  [`atlas_core_add()`](https://ggseg.github.io/ggseg.formats/reference/atlas_manipulation.md)
  [`atlas_view_remove()`](https://ggseg.github.io/ggseg.formats/reference/atlas_manipulation.md)
  [`atlas_view_keep()`](https://ggseg.github.io/ggseg.formats/reference/atlas_manipulation.md)
  [`atlas_view_remove_region()`](https://ggseg.github.io/ggseg.formats/reference/atlas_manipulation.md)
  [`atlas_view_remove_small()`](https://ggseg.github.io/ggseg.formats/reference/atlas_manipulation.md)
  [`atlas_view_gather()`](https://ggseg.github.io/ggseg.formats/reference/atlas_manipulation.md)
  [`atlas_view_reorder()`](https://ggseg.github.io/ggseg.formats/reference/atlas_manipulation.md)
  : Manipulate brain atlas regions and views

## Bundled atlases

Ready-to-use atlases shipped with the package.

- [`dk`](https://ggseg.github.io/ggseg.formats/reference/dk.md) :
  Desikan-Killiany Cortical Atlas
- [`aseg`](https://ggseg.github.io/ggseg.formats/reference/aseg.md) :
  FreeSurfer Automatic Subcortical Segmentation Atlas
- [`tracula`](https://ggseg.github.io/ggseg.formats/reference/tracula.md)
  : TRACULA White Matter Tract Atlas

## FreeSurfer I/O

Read FreeSurfer statistics files into R.

- [`read_atlas_files()`](https://ggseg.github.io/ggseg.formats/reference/read_atlas_files.md)
  : Read in atlas data from all subjects
- [`read_freesurfer_stats()`](https://ggseg.github.io/ggseg.formats/reference/read_freesurfer_stats.md)
  : Read in raw FreeSurfer stats file
- [`read_freesurfer_table()`](https://ggseg.github.io/ggseg.formats/reference/read_freesurfer_table.md)
  : Read in stats table from FreeSurfer
