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
      # A tibble: 70 x 4
         hemi  region                            label                       lobe     
         <chr> <chr>                             <chr>                       <chr>    
       1 left  banks of superior temporal sulcus lh_bankssts                 temporal 
       2 left  caudal anterior cingulate         lh_caudalanteriorcingulate  cingulate
       3 left  caudal middle frontal             lh_caudalmiddlefrontal      frontal  
       4 left  corpus callosum                   lh_corpuscallosum           white ma~
       5 left  cuneus                            lh_cuneus                   occipital
       6 left  entorhinal                        lh_entorhinal               temporal 
       7 left  fusiform                          lh_fusiform                 temporal 
       8 left  inferior parietal                 lh_inferiorparietal         parietal 
       9 left  inferior temporal                 lh_inferiortemporal         temporal 
      10 left  isthmus cingulate                 lh_isthmuscingulate         cingulate
      11 left  lateral occipital                 lh_lateraloccipital         occipital
      12 left  lateral orbitofrontal             lh_lateralorbitofrontal     frontal  
      13 left  lingual                           lh_lingual                  occipital
      14 left  medial orbitofrontal              lh_medialorbitofrontal      frontal  
      15 left  middle temporal                   lh_middletemporal           temporal 
      16 left  parahippocampal                   lh_parahippocampal          temporal 
      17 left  paracentral                       lh_paracentral              frontal  
      18 left  pars opercularis                  lh_parsopercularis          frontal  
      19 left  pars orbitalis                    lh_parsorbitalis            frontal  
      20 left  pars triangularis                 lh_parstriangularis         frontal  
      21 left  pericalcarine                     lh_pericalcarine            occipital
      22 left  postcentral                       lh_postcentral              parietal 
      23 left  posterior cingulate               lh_posteriorcingulate       cingulate
      24 left  precentral                        lh_precentral               frontal  
      25 left  precuneus                         lh_precuneus                parietal 
      26 left  rostral anterior cingulate        lh_rostralanteriorcingulate cingulate
      27 left  rostral middle frontal            lh_rostralmiddlefrontal     frontal  
      28 left  superior frontal                  lh_superiorfrontal          frontal  
      29 left  superior parietal                 lh_superiorparietal         parietal 
      30 left  superior temporal                 lh_superiortemporal         temporal 
      31 left  supramarginal                     lh_supramarginal            parietal 
      32 left  frontal pole                      lh_frontalpole              frontal  
      33 left  temporal pole                     lh_temporalpole             temporal 
      34 left  transverse temporal               lh_transversetemporal       temporal 
      35 left  insula                            lh_insula                   insula   
      36 right banks of superior temporal sulcus rh_bankssts                 temporal 
      37 right caudal anterior cingulate         rh_caudalanteriorcingulate  cingulate
      38 right caudal middle frontal             rh_caudalmiddlefrontal      frontal  
      39 right corpus callosum                   rh_corpuscallosum           white ma~
      40 right cuneus                            rh_cuneus                   occipital
      41 right entorhinal                        rh_entorhinal               temporal 
      42 right fusiform                          rh_fusiform                 temporal 
      43 right inferior parietal                 rh_inferiorparietal         parietal 
      44 right inferior temporal                 rh_inferiortemporal         temporal 
      45 right isthmus cingulate                 rh_isthmuscingulate         cingulate
      46 right lateral occipital                 rh_lateraloccipital         occipital
      47 right lateral orbitofrontal             rh_lateralorbitofrontal     frontal  
      48 right lingual                           rh_lingual                  occipital
      49 right medial orbitofrontal              rh_medialorbitofrontal      frontal  
      50 right middle temporal                   rh_middletemporal           temporal 
      51 right parahippocampal                   rh_parahippocampal          temporal 
      52 right paracentral                       rh_paracentral              frontal  
      53 right pars opercularis                  rh_parsopercularis          frontal  
      54 right pars orbitalis                    rh_parsorbitalis            frontal  
      55 right pars triangularis                 rh_parstriangularis         frontal  
      56 right pericalcarine                     rh_pericalcarine            occipital
      57 right postcentral                       rh_postcentral              parietal 
      58 right posterior cingulate               rh_posteriorcingulate       cingulate
      59 right precentral                        rh_precentral               frontal  
      60 right precuneus                         rh_precuneus                parietal 
      61 right rostral anterior cingulate        rh_rostralanteriorcingulate cingulate
      62 right rostral middle frontal            rh_rostralmiddlefrontal     frontal  
      63 right superior frontal                  rh_superiorfrontal          frontal  
      64 right superior parietal                 rh_superiorparietal         parietal 
      65 right superior temporal                 rh_superiortemporal         temporal 
      66 right supramarginal                     rh_supramarginal            parietal 
      67 right frontal pole                      rh_frontalpole              frontal  
      68 right temporal pole                     rh_temporalpole             temporal 
      69 right transverse temporal               rh_transversetemporal       temporal 
      70 right insula                            rh_insula                   insula   

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
      # A tibble: 47 x 4
         hemi  region           label                   structure    
         <chr> <chr>            <chr>                   <chr>        
       1 left  Cerebellum       Left-Cerebellum-Cortex  cerebellum   
       2 left  Cerebellum       Left-Cerebellum-Cortex  cerebellum   
       3 left  Thalamus         Left-Thalamus           basal ganglia
       4 left  Thalamus         Left-Thalamus           basal ganglia
       5 left  Thalamus Proper  Left-Thalamus           basal ganglia
       6 left  Thalamus Proper  Left-Thalamus           basal ganglia
       7 left  Caudate          Left-Caudate            basal ganglia
       8 left  Caudate          Left-Caudate            basal ganglia
       9 left  Putamen          Left-Putamen            basal ganglia
      10 left  Putamen          Left-Putamen            basal ganglia
      11 left  Pallidum         Left-Pallidum           basal ganglia
      12 left  Pallidum         Left-Pallidum           basal ganglia
      13 <NA>  Brain Stem       Brain-Stem              brainstem    
      14 left  Hippocampus      Left-Hippocampus        limbic       
      15 left  Hippocampus      Left-Hippocampus        limbic       
      16 left  Amygdala         Left-Amygdala           limbic       
      17 left  Amygdala         Left-Amygdala           limbic       
      18 left  accumbens area   Left-Accumbens-area     <NA>         
      19 left  ventraldc        Left-VentralDC          <NA>         
      20 left  vessel           Left-vessel             <NA>         
      21 left  choroid plexus   Left-choroid-plexus     <NA>         
      22 right Cerebellum       Right-Cerebellum-Cortex cerebellum   
      23 right Cerebellum       Right-Cerebellum-Cortex cerebellum   
      24 right Thalamus         Right-Thalamus          basal ganglia
      25 right Thalamus         Right-Thalamus          basal ganglia
      26 right Thalamus Proper  Right-Thalamus          basal ganglia
      27 right Thalamus Proper  Right-Thalamus          basal ganglia
      28 right Caudate          Right-Caudate           basal ganglia
      29 right Caudate          Right-Caudate           basal ganglia
      30 right Putamen          Right-Putamen           basal ganglia
      31 right Putamen          Right-Putamen           basal ganglia
      32 right Pallidum         Right-Pallidum          basal ganglia
      33 right Pallidum         Right-Pallidum          basal ganglia
      34 right Hippocampus      Right-Hippocampus       limbic       
      35 right Hippocampus      Right-Hippocampus       limbic       
      36 right Amygdala         Right-Amygdala          limbic       
      37 right Amygdala         Right-Amygdala          limbic       
      38 right accumbens area   Right-Accumbens-area    <NA>         
      39 right ventraldc        Right-VentralDC         <NA>         
      40 right vessel           Right-vessel            <NA>         
      41 right choroid plexus   Right-choroid-plexus    <NA>         
      42 <NA>  Optic Chiasm     Optic-Chiasm            other        
      43 <NA>  cc posterior     CC_Posterior            <NA>         
      44 <NA>  cc mid posterior CC_Mid_Posterior        <NA>         
      45 <NA>  cc central       CC_Central              <NA>         
      46 <NA>  cc mid anterior  CC_Mid_Anterior         <NA>         
      47 <NA>  cc anterior      CC_Anterior             <NA>         

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
      # A tibble: 42 x 4
         hemi    region                           label                group          
         <chr>   <chr>                            <chr>                <chr>          
       1 midline anterior commissure              acomm.bbr.prep       commissure     
       2 midline CC body central                  cc.bodyc.bbr.prep    corpus callosum
       3 midline CC body parietal                 cc.bodyp.bbr.prep    corpus callosum
       4 midline CC body prefrontal               cc.bodypf.bbr.prep   corpus callosum
       5 midline CC body premotor                 cc.bodypm.bbr.prep   corpus callosum
       6 midline CC body temporal                 cc.bodyt.bbr.prep    corpus callosum
       7 midline CC genu                          cc.genu.bbr.prep     corpus callosum
       8 midline CC rostrum                       cc.rostrum.bbr.prep  corpus callosum
       9 midline CC splenium                      cc.splenium.bbr.prep corpus callosum
      10 left    arcuate fasciculus               lh.af.bbr.prep       association    
      11 left    acoustic radiation               lh.ar.bbr.prep       association    
      12 left    anterior thalamic radiation      lh.atr.bbr.prep      association    
      13 left    cingulum dorsal                  lh.cbd.bbr.prep      limbic         
      14 left    cingulum ventral                 lh.cbv.bbr.prep      limbic         
      15 left    corticospinal tract              lh.cst.bbr.prep      projection     
      16 left    extreme capsule                  lh.emc.bbr.prep      limbic         
      17 left    frontal aslant tract             lh.fat.bbr.prep      association    
      18 left    fornix                           lh.fx.bbr.prep       association    
      19 left    inferior longitudinal fasciculus lh.ilf.bbr.prep      limbic         
      20 left    middle longitudinal fasciculus   lh.mlf.bbr.prep      association    
      21 left    optic radiation                  lh.or.bbr.prep       association    
      22 left    SLF I                            lh.slf1.bbr.prep     association    
      23 left    SLF II                           lh.slf2.bbr.prep     association    
      24 left    SLF III                          lh.slf3.bbr.prep     association    
      25 left    uncinate fasciculus              lh.uf.bbr.prep       limbic         
      26 midline middle cerebellar peduncle       mcp.bbr.prep         cerebellar     
      27 right   arcuate fasciculus               rh.af.bbr.prep       association    
      28 right   acoustic radiation               rh.ar.bbr.prep       association    
      29 right   anterior thalamic radiation      rh.atr.bbr.prep      association    
      30 right   cingulum dorsal                  rh.cbd.bbr.prep      limbic         
      31 right   cingulum ventral                 rh.cbv.bbr.prep      limbic         
      32 right   corticospinal tract              rh.cst.bbr.prep      projection     
      33 right   extreme capsule                  rh.emc.bbr.prep      limbic         
      34 right   frontal aslant tract             rh.fat.bbr.prep      association    
      35 right   fornix                           rh.fx.bbr.prep       association    
      36 right   inferior longitudinal fasciculus rh.ilf.bbr.prep      limbic         
      37 right   middle longitudinal fasciculus   rh.mlf.bbr.prep      association    
      38 right   optic radiation                  rh.or.bbr.prep       association    
      39 right   SLF I                            rh.slf1.bbr.prep     association    
      40 right   SLF II                           rh.slf2.bbr.prep     association    
      41 right   SLF III                          rh.slf3.bbr.prep     association    
      42 right   uncinate fasciculus              rh.uf.bbr.prep       limbic         

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
      # A tibble: 1 x 3
        hemi  region  label     
        <chr> <chr>   <chr>     
      1 left  frontal lh_frontal

