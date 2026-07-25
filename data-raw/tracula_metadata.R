# TRACULA tract metadata
#
# One row per raw FreeSurfer TRACULA tract label. `label` is the untouched atlas
# identifier; `hemi` and `region` are derived mechanically from it (the lh./rh.
# prefix becomes `hemi`, the remainder with the .bbr.prep suffix stripped and
# dots spaced becomes `region`); `names` is the fully spelled-out label; `group`
# classifies tracts.
#
# Based on: https://surfer.nmr.mgh.harvard.edu/fswiki/Tracula

tracula_metadata <- data.frame(
  label = c(
    # Corpus callosum segments
    "cc.rostrum.bbr.prep",
    "cc.genu.bbr.prep",
    "cc.bodyc.bbr.prep",
    "cc.bodypf.bbr.prep",
    "cc.bodypm.bbr.prep",
    "cc.bodyp.bbr.prep",
    "cc.bodyt.bbr.prep",
    "cc.splenium.bbr.prep",
    # Anterior commissure
    "acomm.bbr.prep",
    # Middle cerebellar peduncle
    "mcp.bbr.prep",
    # Left hemisphere tracts
    "lh.cst.bbr.prep",
    "lh.af.bbr.prep",
    "lh.ar.bbr.prep",
    "lh.atr.bbr.prep",
    "lh.cbd.bbr.prep",
    "lh.cbv.bbr.prep",
    "lh.emc.bbr.prep",
    "lh.fat.bbr.prep",
    "lh.fx.bbr.prep",
    "lh.ilf.bbr.prep",
    "lh.mlf.bbr.prep",
    "lh.or.bbr.prep",
    "lh.slf1.bbr.prep",
    "lh.slf2.bbr.prep",
    "lh.slf3.bbr.prep",
    "lh.uf.bbr.prep",
    # Right hemisphere tracts
    "rh.cst.bbr.prep",
    "rh.af.bbr.prep",
    "rh.ar.bbr.prep",
    "rh.atr.bbr.prep",
    "rh.cbd.bbr.prep",
    "rh.cbv.bbr.prep",
    "rh.emc.bbr.prep",
    "rh.fat.bbr.prep",
    "rh.fx.bbr.prep",
    "rh.ilf.bbr.prep",
    "rh.mlf.bbr.prep",
    "rh.or.bbr.prep",
    "rh.slf1.bbr.prep",
    "rh.slf2.bbr.prep",
    "rh.slf3.bbr.prep",
    "rh.uf.bbr.prep"
  ),
  names = c(
    # CC segments
    "corpus callosum rostrum",
    "corpus callosum genu",
    "corpus callosum body central",
    "corpus callosum body prefrontal",
    "corpus callosum body premotor",
    "corpus callosum body parietal",
    "corpus callosum body temporal",
    "corpus callosum splenium",
    # Commissures
    "anterior commissure",
    # Cerebellar
    "middle cerebellar peduncle",
    # Left tracts
    "corticospinal tract",
    "arcuate fasciculus",
    "acoustic radiation",
    "anterior thalamic radiation",
    "cingulum dorsal",
    "cingulum ventral",
    "extreme capsule",
    "frontal aslant tract",
    "fornix",
    "inferior longitudinal fasciculus",
    "middle longitudinal fasciculus",
    "optic radiation",
    "superior longitudinal fasciculus I",
    "superior longitudinal fasciculus II",
    "superior longitudinal fasciculus III",
    "uncinate fasciculus",
    # Right tracts (same names)
    "corticospinal tract",
    "arcuate fasciculus",
    "acoustic radiation",
    "anterior thalamic radiation",
    "cingulum dorsal",
    "cingulum ventral",
    "extreme capsule",
    "frontal aslant tract",
    "fornix",
    "inferior longitudinal fasciculus",
    "middle longitudinal fasciculus",
    "optic radiation",
    "superior longitudinal fasciculus I",
    "superior longitudinal fasciculus II",
    "superior longitudinal fasciculus III",
    "uncinate fasciculus"
  ),
  group = c(
    rep("corpus callosum", 8),
    "commissure",
    "cerebellar",
    rep("projection", 1),
    rep("association", 3),
    rep("limbic", 3),
    rep("association", 2),
    rep("limbic", 1),
    rep("association", 5),
    rep("limbic", 1),
    rep("projection", 1),
    rep("association", 3),
    rep("limbic", 3),
    rep("association", 2),
    rep("limbic", 1),
    rep("association", 5),
    rep("limbic", 1)
  )
)

tracula_metadata$hemi <- ifelse(
  grepl("^lh\\.", tracula_metadata$label),
  "left",
  ifelse(grepl("^rh\\.", tracula_metadata$label), "right", "midline")
)

tracula_metadata$region <- tracula_metadata$label |>
  sub("^(lh|rh)\\.", "", x = _) |>
  sub("\\.bbr\\.prep$", "", x = _) |>
  gsub("\\.", " ", x = _)

tracula_metadata <- tracula_metadata[,
  c("label", "hemi", "region", "names", "group")
]
