# atlas_sf / prints a compact summary

    Code
      print(sf_data)
    Message
      -- <ggseg_sf> data: 191 × 7 ----------------------------------------------------
      Views: inferior, lateral, superior, medial
    Output
      Simple feature collection with 191 features and 6 fields
      Geometry type: MULTIPOLYGON
      Dimension:     XY
      Bounding box:  xmin: 84.2049 ymin: 0 xmax: 5359.689 ymax: 429.9372
      CRS:           NA
      First 10 features:
                              label     view hemi                            region
      1                 lh_bankssts inferior left banks of superior temporal sulcus
      2                 lh_bankssts  lateral left banks of superior temporal sulcus
      3                 lh_bankssts superior left banks of superior temporal sulcus
      4  lh_caudalanteriorcingulate   medial left         caudal anterior cingulate
      5      lh_caudalmiddlefrontal inferior left             caudal middle frontal
      6      lh_caudalmiddlefrontal  lateral left             caudal middle frontal
      7      lh_caudalmiddlefrontal superior left             caudal middle frontal
      8           lh_corpuscallosum   medial left                   corpus callosum
      9           lh_corpuscallosum inferior left                   corpus callosum
      10                  lh_cuneus   medial left                            cuneus
                 lobe                       geometry  colour
      1      temporal MULTIPOLYGON (((534.4782 21... #196428
      2      temporal MULTIPOLYGON (((1121.478 12... #196428
      3      temporal MULTIPOLYGON (((2448.464 20... #196428
      4     cingulate MULTIPOLYGON (((1921.971 20... #7D64A0
      5       frontal MULTIPOLYGON (((272.7879 22... #641900
      6       frontal MULTIPOLYGON (((911.758 248... #641900
      7       frontal MULTIPOLYGON (((2266.635 10... #641900
      8  white matter MULTIPOLYGON (((1873.925 12... #784632
      9  white matter MULTIPOLYGON (((486.2937 40... #784632
      10    occipital MULTIPOLYGON (((1422.294 16... #DC1464

# atlas_vertices / prints a compact summary

    Code
      print(result)
    Message
      -- <ggseg_vertices> data: 70 × 6 -----------------------------------------------
      Vertices per region: 18 –759
    Output
      # A tibble: 70 x 6
         label                      vertices    hemi  region              lobe  colour
         <chr>                      <list>      <chr> <chr>               <chr> <chr> 
       1 lh_bankssts                <int [126]> left  banks of superior ~ temp~ #1964~
       2 lh_caudalanteriorcingulate <int [67]>  left  caudal anterior ci~ cing~ #7D64~
       3 lh_caudalmiddlefrontal     <int [232]> left  caudal middle fron~ fron~ #6419~
       4 lh_corpuscallosum          <int [198]> left  corpus callosum     whit~ #7846~
       5 lh_cuneus                  <int [102]> left  cuneus              occi~ #DC14~
       6 lh_entorhinal              <int [48]>  left  entorhinal          temp~ #DC14~
       7 lh_fusiform                <int [308]> left  fusiform            temp~ #B4DC~
       8 lh_inferiorparietal        <int [484]> left  inferior parietal   pari~ #DC3C~
       9 lh_inferiortemporal        <int [271]> left  inferior temporal   temp~ #B428~
      10 lh_isthmuscingulate        <int [123]> left  isthmus cingulate   cing~ #8C14~
      # i 60 more rows

# atlas_meshes / prints a compact summary

    Code
      print(result)
    Message
      -- <ggseg_meshes> data: 47 × 6 -------------------------------------------------
    Output
      # A tibble: 47 x 3
         label                  vertices faces
         <chr>                     <int> <int>
       1 Left-Cerebellum-Cortex    21232 42456
       2 Left-Cerebellum-Cortex    21232 42456
       3 Left-Thalamus              3726  7448
       4 Left-Thalamus              3726  7448
       5 Left-Thalamus              3726  7448
       6 Left-Thalamus              3726  7448
       7 Left-Caudate               3026  6056
       8 Left-Caudate               3026  6056
       9 Left-Putamen               3994  7984
      10 Left-Putamen               3994  7984
      # i 37 more rows

