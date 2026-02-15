# Package index

## ggseg atlas

Create and inspect ggseg atlas objects.

- [`ggseg_atlas()`](https://ggsegverse.github.io/ggseg.formats/reference/ggseg_atlas.md)
  [`brain_atlas()`](https://ggsegverse.github.io/ggseg.formats/reference/ggseg_atlas.md)
  : Constructor for ggseg atlas
- [`ggseg_data_cortical()`](https://ggsegverse.github.io/ggseg.formats/reference/ggseg_data_cortical.md)
  [`brain_data_cortical()`](https://ggsegverse.github.io/ggseg.formats/reference/ggseg_data_cortical.md)
  : Create cortical atlas data
- [`ggseg_data_subcortical()`](https://ggsegverse.github.io/ggseg.formats/reference/ggseg_data_subcortical.md)
  [`brain_data_subcortical()`](https://ggsegverse.github.io/ggseg.formats/reference/ggseg_data_subcortical.md)
  : Create subcortical atlas data
- [`ggseg_data_tract()`](https://ggsegverse.github.io/ggseg.formats/reference/ggseg_data_tract.md)
  [`brain_data_tract()`](https://ggsegverse.github.io/ggseg.formats/reference/ggseg_data_tract.md)
  : Create tract atlas data
- [`is_ggseg3d_atlas()`](https://ggsegverse.github.io/ggseg.formats/reference/is_ggseg3d_atlas.md)
  : Check if object is a legacy ggseg3d atlas
- [`is_ggseg_atlas()`](https://ggsegverse.github.io/ggseg.formats/reference/is_ggseg_atlas.md)
  [`is_cortical_atlas()`](https://ggsegverse.github.io/ggseg.formats/reference/is_ggseg_atlas.md)
  [`is_subcortical_atlas()`](https://ggsegverse.github.io/ggseg.formats/reference/is_ggseg_atlas.md)
  [`is_tract_atlas()`](https://ggsegverse.github.io/ggseg.formats/reference/is_ggseg_atlas.md)
  [`is_brain_atlas()`](https://ggsegverse.github.io/ggseg.formats/reference/is_ggseg_atlas.md)
  : Check ggseg atlas class
- [`as_ggseg_atlas()`](https://ggsegverse.github.io/ggseg.formats/reference/as_ggseg_atlas.md)
  [`as_brain_atlas()`](https://ggsegverse.github.io/ggseg.formats/reference/as_ggseg_atlas.md)
  : Coerce to ggseg atlas

## Legacy conversion

Convert old ggseg/ggseg3d atlases to the unified ggseg_atlas format.

- [`convert_legacy_brain_atlas()`](https://ggsegverse.github.io/ggseg.formats/reference/convert_legacy_brain_atlas.md)
  [`unify_legacy_atlases()`](https://ggsegverse.github.io/ggseg.formats/reference/convert_legacy_brain_atlas.md)
  **\[superseded\]** : Convert legacy ggseg atlases to ggseg_atlas
  format
- [`as_ggseg_atlas()`](https://ggsegverse.github.io/ggseg.formats/reference/as_ggseg_atlas.md)
  [`as_brain_atlas()`](https://ggsegverse.github.io/ggseg.formats/reference/as_ggseg_atlas.md)
  : Coerce to ggseg atlas
- [`atlas_labels()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_labels.md)
  [`brain_labels()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_labels.md)
  : Extract unique labels from an atlas
- [`atlas_regions()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_regions.md)
  [`brain_regions()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_regions.md)
  : Extract unique region names from an atlas
- [`atlas_views()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_views.md)
  [`brain_views()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_views.md)
  : Get available views in atlas
- [`get_brain_mesh()`](https://ggsegverse.github.io/ggseg.formats/reference/get_brain_mesh.md)
  : Get brain surface mesh
- [`ggseg_atlas()`](https://ggsegverse.github.io/ggseg.formats/reference/ggseg_atlas.md)
  [`brain_atlas()`](https://ggsegverse.github.io/ggseg.formats/reference/ggseg_atlas.md)
  : Constructor for ggseg atlas
- [`ggseg_data_cortical()`](https://ggsegverse.github.io/ggseg.formats/reference/ggseg_data_cortical.md)
  [`brain_data_cortical()`](https://ggsegverse.github.io/ggseg.formats/reference/ggseg_data_cortical.md)
  : Create cortical atlas data
- [`ggseg_data_subcortical()`](https://ggsegverse.github.io/ggseg.formats/reference/ggseg_data_subcortical.md)
  [`brain_data_subcortical()`](https://ggsegverse.github.io/ggseg.formats/reference/ggseg_data_subcortical.md)
  : Create subcortical atlas data
- [`ggseg_data_tract()`](https://ggsegverse.github.io/ggseg.formats/reference/ggseg_data_tract.md)
  [`brain_data_tract()`](https://ggsegverse.github.io/ggseg.formats/reference/ggseg_data_tract.md)
  : Create tract atlas data
- [`is_ggseg_atlas()`](https://ggsegverse.github.io/ggseg.formats/reference/is_ggseg_atlas.md)
  [`is_cortical_atlas()`](https://ggsegverse.github.io/ggseg.formats/reference/is_ggseg_atlas.md)
  [`is_subcortical_atlas()`](https://ggsegverse.github.io/ggseg.formats/reference/is_ggseg_atlas.md)
  [`is_tract_atlas()`](https://ggsegverse.github.io/ggseg.formats/reference/is_ggseg_atlas.md)
  [`is_brain_atlas()`](https://ggsegverse.github.io/ggseg.formats/reference/is_ggseg_atlas.md)
  : Check ggseg atlas class

## Accessors

Query atlas contents without reaching into slots directly.

- [`atlas_labels()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_labels.md)
  [`brain_labels()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_labels.md)
  : Extract unique labels from an atlas
- [`atlas_region_remove()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_manipulation.md)
  [`atlas_region_contextual()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_manipulation.md)
  [`atlas_region_rename()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_manipulation.md)
  [`atlas_region_keep()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_manipulation.md)
  [`atlas_core_add()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_manipulation.md)
  [`atlas_view_remove()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_manipulation.md)
  [`atlas_view_keep()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_manipulation.md)
  [`atlas_view_remove_region()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_manipulation.md)
  [`atlas_view_remove_small()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_manipulation.md)
  [`atlas_view_gather()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_manipulation.md)
  [`atlas_view_reorder()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_manipulation.md)
  : Manipulate brain atlas regions and views
- [`atlas_meshes()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_meshes.md)
  : Get atlas meshes for 3D rendering
- [`atlas_palette()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_palette.md)
  : Get atlas palette
- [`atlas_regions()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_regions.md)
  [`brain_regions()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_regions.md)
  : Extract unique region names from an atlas
- [`atlas_sf()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_sf.md)
  : Get atlas data for 2D rendering
- [`atlas_type()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_type.md)
  : Detect atlas type
- [`atlas_vertices()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_vertices.md)
  : Get atlas vertices for 3D rendering
- [`atlas_views()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_views.md)
  [`brain_views()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_views.md)
  : Get available views in atlas

## Atlas manipulation

Pipe-friendly functions for subsetting regions, managing views, and
enriching metadata. All return a new `ggseg_atlas`.

- [`atlas_region_remove()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_manipulation.md)
  [`atlas_region_contextual()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_manipulation.md)
  [`atlas_region_rename()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_manipulation.md)
  [`atlas_region_keep()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_manipulation.md)
  [`atlas_core_add()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_manipulation.md)
  [`atlas_view_remove()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_manipulation.md)
  [`atlas_view_keep()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_manipulation.md)
  [`atlas_view_remove_region()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_manipulation.md)
  [`atlas_view_remove_small()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_manipulation.md)
  [`atlas_view_gather()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_manipulation.md)
  [`atlas_view_reorder()`](https://ggsegverse.github.io/ggseg.formats/reference/atlas_manipulation.md)
  : Manipulate brain atlas regions and views

## Bundled atlases

Ready-to-use atlases shipped with the package.

- [`dk()`](https://ggsegverse.github.io/ggseg.formats/reference/dk.md) :
  Desikan-Killiany Cortical Atlas
- [`aseg()`](https://ggsegverse.github.io/ggseg.formats/reference/aseg.md)
  : FreeSurfer Automatic Subcortical Segmentation Atlas
- [`tracula()`](https://ggsegverse.github.io/ggseg.formats/reference/tracula.md)
  : TRACULA White Matter Tract Atlas

## FreeSurfer I/O

Read FreeSurfer statistics files into R.

- [`read_atlas_files()`](https://ggsegverse.github.io/ggseg.formats/reference/read_atlas_files.md)
  : Read in atlas data from all subjects
- [`read_freesurfer_stats()`](https://ggsegverse.github.io/ggseg.formats/reference/read_freesurfer_stats.md)
  : Read in raw FreeSurfer stats file
- [`read_freesurfer_table()`](https://ggsegverse.github.io/ggseg.formats/reference/read_freesurfer_table.md)
  : Read in stats table from FreeSurfer
