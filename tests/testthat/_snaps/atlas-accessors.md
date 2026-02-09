# atlas_sf: prints a compact summary

    Code
      print(sf_data)
    Message
      -- <ggseg_sf> data: 183 × 7 ----------------------------------------------------
      Views: inferior, lateral, superior, medial
    Output
      Simple feature collection with 183 features and 6 fields
      Geometry type: MULTIPOLYGON
      Dimension:     XY
      Bounding box:  xmin: 27.18247 ymin: 0 xmax: 1712.035 ymax: 137.8149
      CRS:           NA
      First 10 features:
                              label     view hemi                            region
      1                 lh_bankssts inferior left banks of superior temporal sulcus
      2                 lh_bankssts  lateral left banks of superior temporal sulcus
      3                 lh_bankssts superior left banks of superior temporal sulcus
      4  lh_caudalanteriorcingulate   medial left         caudal anterior cingulate
      5      lh_caudalmiddlefrontal  lateral left             caudal middle frontal
      6      lh_caudalmiddlefrontal superior left             caudal middle frontal
      7      lh_caudalmiddlefrontal inferior left             caudal middle frontal
      8           lh_corpuscallosum   medial left                   corpus callosum
      9                   lh_cuneus superior left                            cuneus
      10                  lh_cuneus   medial left                            cuneus
                 lobe                       geometry  colour
      1      temporal MULTIPOLYGON (((171.1363 68... #196428
      2      temporal MULTIPOLYGON (((358.0961 41... #196428
      3      temporal MULTIPOLYGON (((808.4086 13... #196428
      4     cingulate MULTIPOLYGON (((614.028 65.... #7D64A0
      5       frontal MULTIPOLYGON (((292.9792 78... #641900
      6       frontal MULTIPOLYGON (((724.0058 33... #641900
      7       frontal MULTIPOLYGON (((87.29372 71... #641900
      8  white matter MULTIPOLYGON (((598.9115 40... #784632
      9     occipital MULTIPOLYGON (((847.2415 78... #DC1464
      10    occipital MULTIPOLYGON (((454.3746 53... #DC1464

# atlas_vertices: prints a compact summary

    Code
      print(result)
    Message
      -- <ggseg_vertices> data: 72 × 6 -----------------------------------------------
      Vertices per region: 18 –840
    Output
      # A tibble: 72 x 6
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
      # i 62 more rows

# atlas_meshes: prints a compact summary

    Code
      print(result)
    Message
      -- <ggseg_meshes> data: 27 × 6 -------------------------------------------------
    Output
      # A tibble: 27 x 3
         label               vertices faces
         <chr>                  <int> <int>
       1 Left-Thalamus           1864  3724
       2 Left-Caudate            1512  3028
       3 Left-Putamen            1998  3992
       4 Left-Pallidum            723  1442
       5 Brain-Stem              4608  9212
       6 Left-Hippocampus        1892  3780
       7 Left-Amygdala            710  1416
       8 Left-Accumbens-area      432   860
       9 Left-VentralDC          1683  3366
      10 Left-vessel               77   150
      # i 17 more rows

