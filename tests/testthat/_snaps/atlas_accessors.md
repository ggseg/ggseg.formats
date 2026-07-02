# atlas_sf / prints without error and keeps its classes

    Code
      print(sf_data)
    Message
      -- <ggseg_sf> data: 2 × 3 ------------------------------------------------------
      Views: lateral, medial
    Output
      Simple feature collection with 2 features and 2 fields
      Geometry type: POLYGON
      Dimension:     XY
      Bounding box:  xmin: 0 ymin: 0 xmax: 3 ymax: 1
      CRS:           NA
        label    view                       geometry
      1  lh_a lateral POLYGON ((0 0, 1 0, 1 1, 0 0))
      2  lh_b  medial POLYGON ((2 0, 3 0, 3 1, 2 0))

# atlas_vertices / prints without error and keeps its classes

    Code
      print(result)
    Message
      -- <ggseg_vertices> data: 70 × 6 -----------------------------------------------
      Vertices per region: 18 –759
    Output
                              label    vertices hemi
      1                 lh_bankssts <int [126]> left
      2  lh_caudalanteriorcingulate  <int [67]> left
      3      lh_caudalmiddlefrontal <int [232]> left
      4           lh_corpuscallosum <int [198]> left
      5                   lh_cuneus <int [102]> left
      6               lh_entorhinal  <int [48]> left
      7                 lh_fusiform <int [308]> left
      8         lh_inferiorparietal <int [484]> left
      9         lh_inferiortemporal <int [271]> left
      10        lh_isthmuscingulate <int [123]> left
                                    region         lobe  colour
      1  banks of superior temporal sulcus     temporal #196428
      2          caudal anterior cingulate    cingulate #7D64A0
      3              caudal middle frontal      frontal #641900
      4                    corpus callosum white matter #784632
      5                             cuneus    occipital #DC1464
      6                         entorhinal     temporal #DC140A
      7                           fusiform     temporal #B4DC8C
      8                  inferior parietal     parietal #DC3CDC
      9                  inferior temporal     temporal #B42878
      10                 isthmus cingulate    cingulate #8C148C
    Message
      ... with 60 more rows

# atlas_meshes / prints without error and keeps its classes

    Code
      print(result)
    Message
      -- <ggseg_meshes> data: 47 × 6 -------------------------------------------------
    Output
                          label vertices faces
      1  Left-Cerebellum-Cortex    21232 42456
      2  Left-Cerebellum-Cortex    21232 42456
      3           Left-Thalamus     3726  7448
      4           Left-Thalamus     3726  7448
      5           Left-Thalamus     3726  7448
      6           Left-Thalamus     3726  7448
      7            Left-Caudate     3026  6056
      8            Left-Caudate     3026  6056
      9            Left-Putamen     3994  7984
      10           Left-Putamen     3994  7984
    Message
      ... with 37 more rows

