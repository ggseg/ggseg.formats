# print.brain_polygons() / prints labels, views and total points for a populated object

    Code
      print(p)
    Message
      
      -- brain_polygons --
      
      Labels: 72
      Views: inferior, lateral, superior, medial
      Total points: 6254
    Output
                          label       geometry
      1             lh_bankssts  <df [58 x 5]>
      2  lh_caudalmiddlefrontal <df [105 x 5]>
      3       lh_corpuscallosum  <df [55 x 5]>
      4           lh_entorhinal  <df [36 x 5]>
      5          lh_frontalpole  <df [22 x 5]>
      6             lh_fusiform <df [110 x 5]>
      7     lh_inferiorparietal <df [137 x 5]>
      8     lh_inferiortemporal <df [189 x 5]>
      9               lh_insula  <df [74 x 5]>
      10    lh_isthmuscingulate  <df [50 x 5]>
    Message
      ... with 62 more rows

# print.brain_polygons() / prints without error for a zero-row object

    Code
      print(p)
    Message
      
      -- brain_polygons --
      
      Labels: 0
    Output
      [1] label    geometry
      <0 rows> (or 0-length row.names)

