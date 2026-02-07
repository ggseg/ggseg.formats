# TRACULA tract metadata
#
# Full names and groupings for FreeSurfer TRACULA tracts.
# Based on: https://surfer.nmr.mgh.harvard.edu/fswiki/Tracula

tracula_metadata <- data.frame(
  label = c(
    # Corpus callosum segments
    "cc.rostrum.bbr.prep", "cc.genu.bbr.prep", "cc.bodyc.bbr.prep",
    "cc.bodypf.bbr.prep", "cc.bodypm.bbr.prep", "cc.bodyp.bbr.prep",
    "cc.bodyt.bbr.prep", "cc.splenium.bbr.prep",
    # Anterior commissure
    "acomm.bbr.prep",
    # Middle cerebellar peduncle
    "mcp.bbr.prep",
    # Left hemisphere tracts
    "lh.cst.bbr.prep", "lh.af.bbr.prep", "lh.ar.bbr.prep",
    "lh.atr.bbr.prep", "lh.cbd.bbr.prep", "lh.cbv.bbr.prep",
    "lh.emc.bbr.prep", "lh.fat.bbr.prep", "lh.fx.bbr.prep",
    "lh.ilf.bbr.prep", "lh.mlf.bbr.prep", "lh.or.bbr.prep",
    "lh.slf1.bbr.prep", "lh.slf2.bbr.prep", "lh.slf3.bbr.prep",
    "lh.uf.bbr.prep",
    # Right hemisphere tracts
    "rh.cst.bbr.prep", "rh.af.bbr.prep", "rh.ar.bbr.prep",
    "rh.atr.bbr.prep", "rh.cbd.bbr.prep", "rh.cbv.bbr.prep",
    "rh.emc.bbr.prep", "rh.fat.bbr.prep", "rh.fx.bbr.prep",
    "rh.ilf.bbr.prep", "rh.mlf.bbr.prep", "rh.or.bbr.prep",
    "rh.slf1.bbr.prep", "rh.slf2.bbr.prep", "rh.slf3.bbr.prep",
    "rh.uf.bbr.prep"
  ),
  region = c(
    # CC segments
    "CC rostrum", "CC genu", "CC body central",
    "CC body prefrontal", "CC body premotor", "CC body parietal",
    "CC body temporal", "CC splenium",
    # Commissures
    "anterior commissure",
    # Cerebellar
    "middle cerebellar peduncle",
    # Left tracts
    "corticospinal tract", "arcuate fasciculus", "acoustic radiation",
    "anterior thalamic radiation", "cingulum dorsal", "cingulum ventral",
    "extreme capsule", "frontal aslant tract", "fornix",
    "inferior longitudinal fasciculus", "middle longitudinal fasciculus",
    "optic radiation", "SLF I", "SLF II", "SLF III", "uncinate fasciculus",
    # Right tracts (same names)
    "corticospinal tract", "arcuate fasciculus", "acoustic radiation",
    "anterior thalamic radiation", "cingulum dorsal", "cingulum ventral",
    "extreme capsule", "frontal aslant tract", "fornix",
    "inferior longitudinal fasciculus", "middle longitudinal fasciculus",
    "optic radiation", "SLF I", "SLF II", "SLF III", "uncinate fasciculus"
  ),
  group = c(
    rep("corpus callosum", 8),
    "commissure",
    "cerebellar",
    rep("projection", 1), rep("association", 3), rep("limbic", 3),
    rep("association", 2), rep("limbic", 1), rep("association", 5),
    rep("limbic", 1),
    rep("projection", 1), rep("association", 3), rep("limbic", 3),
    rep("association", 2), rep("limbic", 1), rep("association", 5),
    rep("limbic", 1)
  ),
  stringsAsFactors = FALSE
)
