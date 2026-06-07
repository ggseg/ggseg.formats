# ggseg_atlas class / print method works

    Code
      print(dk())
    Message
      
      -- dk ggseg atlas --------------------------------------------------------------
      Type: cortical
      Regions: 35
      Hemispheres: left, right
      Views: inferior, lateral, medial, superior
      Palette: v
      Rendering: v ggseg
      v ggseg3d (vertices)
      --------------------------------------------------------------------------------
    Output
         hemi                            region                      label
      1  left banks of superior temporal sulcus                lh_bankssts
      2  left         caudal anterior cingulate lh_caudalanteriorcingulate
      3  left             caudal middle frontal     lh_caudalmiddlefrontal
      4  left                   corpus callosum          lh_corpuscallosum
      5  left                            cuneus                  lh_cuneus
      6  left                        entorhinal              lh_entorhinal
      7  left                          fusiform                lh_fusiform
      8  left                 inferior parietal        lh_inferiorparietal
      9  left                 inferior temporal        lh_inferiortemporal
      10 left                 isthmus cingulate        lh_isthmuscingulate
                 lobe
      1      temporal
      2     cingulate
      3       frontal
      4  white matter
      5     occipital
      6      temporal
      7      temporal
      8      parietal
      9      temporal
      10    cingulate
    Message
      ... with 60 more rows

# print.ggseg_atlas / prints subcortical atlas with meshes

    Code
      print(aseg())
    Message
      
      -- aseg ggseg atlas ------------------------------------------------------------
      Type: subcortical
      Regions: 19
      Hemispheres: left, NA, right
      Views: axial_3, axial_4, axial_5, axial_6, coronal_1, coronal_2, sagittal
      Palette: v
      Rendering: v ggseg
      v ggseg3d (meshes)
      --------------------------------------------------------------------------------
    Output
         hemi          region                  label     structure
      1  left      Cerebellum Left-Cerebellum-Cortex    cerebellum
      2  left      Cerebellum Left-Cerebellum-Cortex    cerebellum
      3  left        Thalamus          Left-Thalamus basal ganglia
      4  left        Thalamus          Left-Thalamus basal ganglia
      5  left Thalamus Proper          Left-Thalamus basal ganglia
      6  left Thalamus Proper          Left-Thalamus basal ganglia
      7  left         Caudate           Left-Caudate basal ganglia
      8  left         Caudate           Left-Caudate basal ganglia
      9  left         Putamen           Left-Putamen basal ganglia
      10 left         Putamen           Left-Putamen basal ganglia
    Message
      ... with 37 more rows

# print.ggseg_atlas / prints tract atlas with centerlines

    Code
      print(tracula())
    Message
      
      -- tracula ggseg atlas ---------------------------------------------------------
      Type: tract
      Regions: 26
      Hemispheres: midline, left, right
      Views: axial_2, axial_4, coronal_3, coronal_4, sagittal_left, sagittal_midline,
      sagittal_right
      Palette: v
      Rendering: v ggseg
      v ggseg3d (centerlines)
      --------------------------------------------------------------------------------
    Output
            hemi              region                label           group
      1  midline anterior commissure       acomm.bbr.prep      commissure
      2  midline     CC body central    cc.bodyc.bbr.prep corpus callosum
      3  midline    CC body parietal    cc.bodyp.bbr.prep corpus callosum
      4  midline  CC body prefrontal   cc.bodypf.bbr.prep corpus callosum
      5  midline    CC body premotor   cc.bodypm.bbr.prep corpus callosum
      6  midline    CC body temporal    cc.bodyt.bbr.prep corpus callosum
      7  midline             CC genu     cc.genu.bbr.prep corpus callosum
      8  midline          CC rostrum  cc.rostrum.bbr.prep corpus callosum
      9  midline         CC splenium cc.splenium.bbr.prep corpus callosum
      10    left  arcuate fasciculus       lh.af.bbr.prep     association
    Message
      ... with 32 more rows

# print.ggseg_atlas / prints atlas without palette or 3D data (render_3d = none)

    Code
      print(atlas)
    Message
      
      -- minimal ggseg atlas ---------------------------------------------------------
      Type: cortical
      Regions: 1
      Hemispheres: left
      Views: lateral
      Palette: x
      Rendering: v ggseg
      x ggseg3d (none)
      --------------------------------------------------------------------------------
    Output
        hemi  region      label
      1 left frontal lh_frontal

