#' Desikan-Killiany Cortical Atlas
#'
#' Brain atlas for the Desikan-Killiany cortical parcellation with 34 regions
#' per hemisphere (68 total) on the cortical surface.
#'
#' This atlas is based on the FreeSurfer `aparc` annotation and is one of the
#' most widely used cortical parcellations in neuroimaging research.
#'
#' The atlas works with both ggseg (2D polygon plots) and ggseg3d (3D mesh
#' visualizations) from a single object.
#'
#' @format A `brain_atlas` object with components:
#' \describe{
#'   \item{atlas}{Character. Atlas name ("dk")}
#'   \item{type}{Character. Atlas type ("cortical")}
#'   \item{palette}{Named character vector of colours for each region}
#'   \item{data}{A `cortical_data` object containing:
#'     \describe{
#'       \item{vertices}{Data frame with `label` and `vertices` columns}
#'       \item{sf}{Simple features data frame for 2D rendering}
#'     }
#'   }
#' }
#'
#' @section Regions:
#' The atlas contains 34 regions per hemisphere including:
#' banks of superior temporal sulcus, caudal anterior cingulate,
#' caudal middle frontal, cuneus, entorhinal, fusiform, inferior parietal,
#' inferior temporal, isthmus cingulate, lateral occipital,
#' lateral orbitofrontal, lingual, medial orbitofrontal, middle temporal,
#' parahippocampal, paracentral, pars opercularis, pars orbitalis,
#' pars triangularis, pericalcarine, postcentral, posterior cingulate,
#' precentral, precuneus, rostral anterior cingulate, rostral middle frontal,
#' superior frontal, superior parietal, superior temporal, supramarginal,
#' frontal pole, temporal pole, transverse temporal, and insula.
#'
#' @section Usage:
#' ```
#' # 2D plot with ggseg
#' library(ggseg)
#' plot(dk)
#'
#' # 3D plot with ggseg3d
#' library(ggseg3d)
#' ggseg3d(atlas = dk)
#' ```
#'
#' @references
#' Desikan RS, Ségonne F, Fischl B, et al. (2006).
#' An automated labeling system for subdividing the human cerebral cortex
#' on MRI scans into gyral based regions of interest.
#' NeuroImage, 31(3):968-980.
#' \doi{10.1016/j.neuroimage.2006.01.021}
#'
#' Fischl B, van der Kouwe A, Destrieux C, et al. (2004).
#' Automatically parcellating the human cerebral cortex.
#' Cerebral Cortex, 14(1):11-22.
#' \doi{10.1093/cercor/bhg087}
#'
#' @seealso
#' [aseg] for subcortical structures,
#' [brain_atlas()] for the atlas class constructor
#'
#' @family ggseg_atlases
#' @docType data
#' @name dk
#' @usage data(dk)
#' @keywords datasets
#' @examples
#' data(dk)
#' dk
#'
#' # List regions
#' brain_regions(dk)
#'
#' # List labels
#' brain_labels(dk)
"dk"


#' FreeSurfer Automatic Subcortical Segmentation Atlas
#'
#' Brain atlas for FreeSurfer's automatic subcortical segmentation (aseg),
#' containing deep brain structures including the thalamus, caudate, putamen,
#' pallidum, hippocampus, amygdala, accumbens, and ventricles.
#'
#' This atlas is derived from FreeSurfer's `aseg.mgz` volumetric segmentation.
#' It works with both ggseg (2D slice views) and ggseg3d (3D mesh
#' visualizations) from a single object.
#'
#' @format A `brain_atlas` object with components:
#' \describe{
#'   \item{atlas}{Character. Atlas name ("aseg")}
#'   \item{type}{Character. Atlas type ("subcortical")}
#'   \item{palette}{Named character vector of colours for each region}
#'   \item{data}{A `subcortical_data` object containing:
#'     \describe{
#'       \item{meshes}{Data frame with `label` and `mesh` columns}
#'       \item{sf}{Simple features data frame for 2D rendering}
#'     }
#'   }
#' }
#'
#' @section Structures:
#' The atlas contains bilateral structures:
#' \itemize{
#'   \item Thalamus
#'   \item Caudate
#'   \item Putamen
#'   \item Pallidum (globus pallidus)
#'   \item Hippocampus
#'   \item Amygdala
#'   \item Accumbens (nucleus accumbens)
#'   \item Ventral diencephalon
#' }
#'
#' Plus midline and ventricular structures:
#' \itemize{
#'   \item Lateral ventricles
#'   \item Third ventricle
#'   \item Fourth ventricle
#'   \item Brain stem
#'   \item Cerebellar cortex
#'   \item Cerebellar white matter
#' }
#'
#' @section Usage:
#' ```
#' # 2D plot with ggseg
#' library(ggseg)
#' plot(aseg)
#'
#' # 3D plot with ggseg3d
#' library(ggseg3d)
#' ggseg3d(atlas = aseg, hemisphere = "subcort") |>
#'   add_glassbrain()
#' ```
#'
#' @references
#' Fischl B, Salat DH, Busa E, et al. (2002).
#' Whole brain segmentation: automated labeling of neuroanatomical
#' structures in the human brain.
#' Neuron, 33(3):341-355.
#' \doi{10.1016/S0896-6273(02)00569-X}
#'
#' @seealso
#' [dk] for cortical parcellation,
#' [brain_atlas()] for the atlas class constructor
#'
#' @family ggseg_atlases
#' @docType data
#' @name aseg
#' @usage data(aseg)
#' @keywords datasets
#' @examples
#' data(aseg)
#' aseg
#'
#' # List regions
#' brain_regions(aseg)
"aseg"
