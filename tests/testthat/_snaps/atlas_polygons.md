# print.brain_polygons() / prints labels, views and total points for a populated object

    Code
      print(p)
    Message
      
      -- brain_polygons --
      
      Labels: 72
      Views: inferior, lateral, medial, superior
      Total points: 5391
    Output
                           label       geometry
      1               lh_unknown <df [113 x 5]>
      2               rh_unknown <df [111 x 5]>
      3            lh_precentral <df [150 x 5]>
      4  lh_lateralorbitofrontal  <df [89 x 5]>
      5      lh_superiortemporal <df [178 x 5]>
      6      lh_lateraloccipital <df [114 x 5]>
      7  lh_rostralmiddlefrontal <df [117 x 5]>
      8                lh_insula <df [132 x 5]>
      9       lh_parsopercularis  <df [69 x 5]>
      10        lh_supramarginal <df [117 x 5]>
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

