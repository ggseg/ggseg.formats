# ASEG (Automatic Subcortical Segmentation) metadata
#
# Full names and structure groupings for FreeSurfer aseg regions.
# Based on: https://surfer.nmr.mgh.harvard.edu/fswiki/FsTutorial/AnatomicalROI/FreeSurferColorLUT

aseg_metadata <- data.frame(
  label = c(
    # Cortical (used as context, not primary regions)
    "Left-Cerebral-Cortex", "Right-Cerebral-Cortex",
    # White matter
    "Left-Cerebral-White-Matter", "Right-Cerebral-White-Matter",
    # Lateral ventricles
    "Left-Lateral-Ventricle", "Right-Lateral-Ventricle",
    "Left-Inf-Lat-Vent", "Right-Inf-Lat-Vent",
    # Third and fourth ventricles
    "3rd-Ventricle", "4th-Ventricle",
    # CSF
    "CSF",
    # Deep gray matter
    "Left-Thalamus", "Right-Thalamus",
    "Left-Caudate", "Right-Caudate",
    "Left-Putamen", "Right-Putamen",
    "Left-Pallidum", "Right-Pallidum",
    # Hippocampal formation
    "Left-Hippocampus", "Right-Hippocampus",
    "Left-Amygdala", "Right-Amygdala",
    # Accumbens
    "Left-Accumbens-area", "Right-Accumbens-area",
    # Ventral diencephalon
    "Left-VentralDC", "Right-VentralDC",
    # Brainstem
    "Brain-Stem",
    # Cerebellum
    "Left-Cerebellum-Cortex", "Right-Cerebellum-Cortex",
    "Left-Cerebellum-White-Matter", "Right-Cerebellum-White-Matter",
    # Other
    "Left-Thalamus-Proper", "Right-Thalamus-Proper",
    "WM-hypointensities", "non-WM-hypointensities",
    "Optic-Chiasm",
    "CC_Posterior", "CC_Mid_Posterior", "CC_Central", "CC_Mid_Anterior", "CC_Anterior"
  ),
  region = c(
    "Cerebral Cortex", "Cerebral Cortex",
    "Cerebral White Matter", "Cerebral White Matter",
    "Lateral Ventricle", "Lateral Ventricle",
    "Inferior Lateral Ventricle", "Inferior Lateral Ventricle",
    "Third Ventricle", "Fourth Ventricle",
    "CSF",
    "Thalamus", "Thalamus",
    "Caudate", "Caudate",
    "Putamen", "Putamen",
    "Pallidum", "Pallidum",
    "Hippocampus", "Hippocampus",
    "Amygdala", "Amygdala",
    "Accumbens", "Accumbens",
    "Ventral Diencephalon", "Ventral Diencephalon",
    "Brain Stem",
    "Cerebellum Cortex", "Cerebellum Cortex",
    "Cerebellum White Matter", "Cerebellum White Matter",
    "Thalamus", "Thalamus",
    "WM Hypointensities", "Non-WM Hypointensities",
    "Optic Chiasm",
    "Corpus Callosum", "Corpus Callosum", "Corpus Callosum", "Corpus Callosum", "Corpus Callosum"
  ),
  label_pretty = c(
    "Cortex", "Cortex",
    "White Matter", "White Matter",
    "Lateral Ventricle", "Lateral Ventricle",
    "Inferior Lateral Ventricle", "Inferior Lateral Ventricle",
    "3rd Ventricle", "4th Ventricle",
    "CSF",
    "Thalamus", "Thalamus",
    "Caudate", "Caudate",
    "Putamen", "Putamen",
    "Pallidum", "Pallidum",
    "Hippocampus", "Hippocampus",
    "Amygdala", "Amygdala",
    "Accumbens", "Accumbens",
    "Ventral DC", "Ventral DC",
    "Brain Stem",
    "Cerebellum", "Cerebellum",
    "Cerebellum WM", "Cerebellum WM",
    "Thalamus Proper", "Thalamus Proper",
    "WM Hypointensities", "Non-WM Hypointensities",
    "Optic Chiasm",
    "CC Posterior", "CC Mid-Posterior", "CC Central", "CC Mid-Anterior", "CC Anterior"
  ),
  structure = c(
    "cortex", "cortex",
    "white matter", "white matter",
    "ventricle", "ventricle",
    "ventricle", "ventricle",
    "ventricle", "ventricle",
    "csf",
    "basal ganglia", "basal ganglia",
    "basal ganglia", "basal ganglia",
    "basal ganglia", "basal ganglia",
    "basal ganglia", "basal ganglia",
    "limbic", "limbic",
    "limbic", "limbic",
    "basal ganglia", "basal ganglia",
    "diencephalon", "diencephalon",
    "brainstem",
    "cerebellum", "cerebellum",
    "cerebellum", "cerebellum",
    "basal ganglia", "basal ganglia",
    "white matter", "other",
    "other",
    "corpus callosum", "corpus callosum", "corpus callosum", "corpus callosum", "corpus callosum"
  ),
  stringsAsFactors = FALSE
)
