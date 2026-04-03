# Create cerebellar atlas data

Creates a data object for cerebellar brain atlases. Cerebellar atlases
use sf polygons from a SUIT flatmap for 2D rendering and vertex indices
into the shared SUIT cerebellar surface mesh for 3D rendering.

## Usage

``` r
ggseg_data_cerebellar(sf = NULL, vertices = NULL, meshes = NULL)
```

## Arguments

- sf:

  sf data.frame with columns label, view, geometry for 2D rendering.
  Surface regions use view "flatmap"; deep structures use other views.

- vertices:

  data.frame with columns label and vertices (list-column of integer
  vectors). Each vector contains 0-based vertex indices into the SUIT
  cerebellar surface (see
  [`get_cerebellar_mesh()`](https://ggsegverse.github.io/ggseg.formats/reference/get_cerebellar_mesh.md)).
  Only for surface regions.

- meshes:

  Optional data.frame with columns label and mesh (list-column of mesh
  objects with vertices and faces). For deep cerebellar structures that
  are not on the cortical surface. Same format as
  [`ggseg_data_subcortical()`](https://ggsegverse.github.io/ggseg.formats/reference/ggseg_data_subcortical.md)
  meshes.

## Value

An object of class c("ggseg_data_cerebellar", "ggseg_atlas_data")

## Details

The shared mesh (see
[`get_cerebellar_mesh()`](https://ggsegverse.github.io/ggseg.formats/reference/get_cerebellar_mesh.md))
includes a cap over the peduncular surface where the cerebellum meets
the brainstem. Vertices on this cap (indices 28,935–30,012) are not
assigned to any atlas region and render as `na_colour` in 3D, analogous
to the medial wall in cortical atlases.

Deep cerebellar structures (e.g. dentate, interposed, fastigial nuclei)
that are not on the cortical surface are stored as individual per-region
meshes in `meshes`, following the same format as subcortical atlases.
Their 2D sf geometries use views other than "flatmap" (e.g. "nuclei").
