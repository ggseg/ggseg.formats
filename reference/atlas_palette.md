# Get atlas palette

Retrieves the colour palette from a brain atlas.

## Usage

``` r
atlas_palette(name = "dk", ...)

brain_pal(name = "dk", ...)
```

## Arguments

- name:

  Character name of atlas (e.g., "dk", "aseg") or a ggseg_atlas object

- ...:

  Additional arguments (unused)

## Value

Named character vector of colours

## Examples

``` r
atlas_palette("dk")
#>                 lh_bankssts  lh_caudalanteriorcingulate 
#>                   "#196428"                   "#7D64A0" 
#>      lh_caudalmiddlefrontal           lh_corpuscallosum 
#>                   "#641900"                   "#784632" 
#>                   lh_cuneus               lh_entorhinal 
#>                   "#DC1464"                   "#DC140A" 
#>                 lh_fusiform         lh_inferiorparietal 
#>                   "#B4DC8C"                   "#DC3CDC" 
#>         lh_inferiortemporal         lh_isthmuscingulate 
#>                   "#B42878"                   "#8C148C" 
#>         lh_lateraloccipital     lh_lateralorbitofrontal 
#>                   "#141E8C"                   "#234B32" 
#>                  lh_lingual      lh_medialorbitofrontal 
#>                   "#E18C8C"                   "#C8234B" 
#>           lh_middletemporal          lh_parahippocampal 
#>                   "#A06432"                   "#14DC3C" 
#>              lh_paracentral          lh_parsopercularis 
#>                   "#3CDC3C"                   "#DCB48C" 
#>            lh_parsorbitalis         lh_parstriangularis 
#>                   "#146432"                   "#DC3C14" 
#>            lh_pericalcarine              lh_postcentral 
#>                   "#78643C"                   "#DC1414" 
#>       lh_posteriorcingulate               lh_precentral 
#>                   "#DCB4DC"                   "#3C14DC" 
#>                lh_precuneus lh_rostralanteriorcingulate 
#>                   "#A08CB4"                   "#50148C" 
#>     lh_rostralmiddlefrontal          lh_superiorfrontal 
#>                   "#4B327D"                   "#14DCA0" 
#>         lh_superiorparietal         lh_superiortemporal 
#>                   "#14B48C"                   "#8CDCDC" 
#>            lh_supramarginal              lh_frontalpole 
#>                   "#50A014"                   "#640064" 
#>             lh_temporalpole       lh_transversetemporal 
#>                   "#464646"                   "#9696C8" 
#>                   lh_insula                  lh_unknown 
#>                   "#FFC020"                   "#BEBEBE" 
#>                 rh_bankssts  rh_caudalanteriorcingulate 
#>                   "#196428"                   "#7D64A0" 
#>      rh_caudalmiddlefrontal           rh_corpuscallosum 
#>                   "#641900"                   "#784632" 
#>                   rh_cuneus               rh_entorhinal 
#>                   "#DC1464"                   "#DC140A" 
#>                 rh_fusiform         rh_inferiorparietal 
#>                   "#B4DC8C"                   "#DC3CDC" 
#>         rh_inferiortemporal         rh_isthmuscingulate 
#>                   "#B42878"                   "#8C148C" 
#>         rh_lateraloccipital     rh_lateralorbitofrontal 
#>                   "#141E8C"                   "#234B32" 
#>                  rh_lingual      rh_medialorbitofrontal 
#>                   "#E18C8C"                   "#C8234B" 
#>           rh_middletemporal          rh_parahippocampal 
#>                   "#A06432"                   "#14DC3C" 
#>              rh_paracentral          rh_parsopercularis 
#>                   "#3CDC3C"                   "#DCB48C" 
#>            rh_parsorbitalis         rh_parstriangularis 
#>                   "#146432"                   "#DC3C14" 
#>            rh_pericalcarine              rh_postcentral 
#>                   "#78643C"                   "#DC1414" 
#>       rh_posteriorcingulate               rh_precentral 
#>                   "#DCB4DC"                   "#3C14DC" 
#>                rh_precuneus rh_rostralanteriorcingulate 
#>                   "#A08CB4"                   "#50148C" 
#>     rh_rostralmiddlefrontal          rh_superiorfrontal 
#>                   "#4B327D"                   "#14DCA0" 
#>         rh_superiorparietal         rh_superiortemporal 
#>                   "#14B48C"                   "#8CDCDC" 
#>            rh_supramarginal              rh_frontalpole 
#>                   "#50A014"                   "#640064" 
#>             rh_temporalpole       rh_transversetemporal 
#>                   "#464646"                   "#9696C8" 
#>                   rh_insula                  rh_unknown 
#>                   "#FFC020"                   "#BEBEBE" 
atlas_palette("aseg")
#>        Left-Thalamus         Left-Caudate         Left-Putamen 
#>            "#00760E"            "#7ABADC"            "#EC0DB0" 
#>        Left-Pallidum           Brain-Stem     Left-Hippocampus 
#>            "#0C30FF"            "#779FB0"            "#DCD814" 
#>        Left-Amygdala  Left-Accumbens-area       Left-VentralDC 
#>            "#67FFFF"            "#FFA500"            "#A52A2A" 
#>          Left-vessel  Left-choroid-plexus       Right-Thalamus 
#>            "#A020F0"            "#00C8C8"            "#00760E" 
#>        Right-Caudate        Right-Putamen       Right-Pallidum 
#>            "#7ABADC"            "#EC0DB0"            "#0D30FF" 
#>    Right-Hippocampus       Right-Amygdala Right-Accumbens-area 
#>            "#DCD814"            "#67FFFF"            "#FFA500" 
#>      Right-VentralDC         Right-vessel Right-choroid-plexus 
#>            "#A52A2A"            "#A020F0"            "#00C8DD" 
#>         Optic-Chiasm         CC_Posterior     CC_Mid_Posterior 
#>            "#EAA91E"            "#000040"            "#000070" 
#>           CC_Central      CC_Mid_Anterior          CC_Anterior 
#>            "#0000A0"            "#0000D0"            "#0000FF" 
atlas_palette(dk)
#>                 lh_bankssts  lh_caudalanteriorcingulate 
#>                   "#196428"                   "#7D64A0" 
#>      lh_caudalmiddlefrontal           lh_corpuscallosum 
#>                   "#641900"                   "#784632" 
#>                   lh_cuneus               lh_entorhinal 
#>                   "#DC1464"                   "#DC140A" 
#>                 lh_fusiform         lh_inferiorparietal 
#>                   "#B4DC8C"                   "#DC3CDC" 
#>         lh_inferiortemporal         lh_isthmuscingulate 
#>                   "#B42878"                   "#8C148C" 
#>         lh_lateraloccipital     lh_lateralorbitofrontal 
#>                   "#141E8C"                   "#234B32" 
#>                  lh_lingual      lh_medialorbitofrontal 
#>                   "#E18C8C"                   "#C8234B" 
#>           lh_middletemporal          lh_parahippocampal 
#>                   "#A06432"                   "#14DC3C" 
#>              lh_paracentral          lh_parsopercularis 
#>                   "#3CDC3C"                   "#DCB48C" 
#>            lh_parsorbitalis         lh_parstriangularis 
#>                   "#146432"                   "#DC3C14" 
#>            lh_pericalcarine              lh_postcentral 
#>                   "#78643C"                   "#DC1414" 
#>       lh_posteriorcingulate               lh_precentral 
#>                   "#DCB4DC"                   "#3C14DC" 
#>                lh_precuneus lh_rostralanteriorcingulate 
#>                   "#A08CB4"                   "#50148C" 
#>     lh_rostralmiddlefrontal          lh_superiorfrontal 
#>                   "#4B327D"                   "#14DCA0" 
#>         lh_superiorparietal         lh_superiortemporal 
#>                   "#14B48C"                   "#8CDCDC" 
#>            lh_supramarginal              lh_frontalpole 
#>                   "#50A014"                   "#640064" 
#>             lh_temporalpole       lh_transversetemporal 
#>                   "#464646"                   "#9696C8" 
#>                   lh_insula                  lh_unknown 
#>                   "#FFC020"                   "#BEBEBE" 
#>                 rh_bankssts  rh_caudalanteriorcingulate 
#>                   "#196428"                   "#7D64A0" 
#>      rh_caudalmiddlefrontal           rh_corpuscallosum 
#>                   "#641900"                   "#784632" 
#>                   rh_cuneus               rh_entorhinal 
#>                   "#DC1464"                   "#DC140A" 
#>                 rh_fusiform         rh_inferiorparietal 
#>                   "#B4DC8C"                   "#DC3CDC" 
#>         rh_inferiortemporal         rh_isthmuscingulate 
#>                   "#B42878"                   "#8C148C" 
#>         rh_lateraloccipital     rh_lateralorbitofrontal 
#>                   "#141E8C"                   "#234B32" 
#>                  rh_lingual      rh_medialorbitofrontal 
#>                   "#E18C8C"                   "#C8234B" 
#>           rh_middletemporal          rh_parahippocampal 
#>                   "#A06432"                   "#14DC3C" 
#>              rh_paracentral          rh_parsopercularis 
#>                   "#3CDC3C"                   "#DCB48C" 
#>            rh_parsorbitalis         rh_parstriangularis 
#>                   "#146432"                   "#DC3C14" 
#>            rh_pericalcarine              rh_postcentral 
#>                   "#78643C"                   "#DC1414" 
#>       rh_posteriorcingulate               rh_precentral 
#>                   "#DCB4DC"                   "#3C14DC" 
#>                rh_precuneus rh_rostralanteriorcingulate 
#>                   "#A08CB4"                   "#50148C" 
#>     rh_rostralmiddlefrontal          rh_superiorfrontal 
#>                   "#4B327D"                   "#14DCA0" 
#>         rh_superiorparietal         rh_superiortemporal 
#>                   "#14B48C"                   "#8CDCDC" 
#>            rh_supramarginal              rh_frontalpole 
#>                   "#50A014"                   "#640064" 
#>             rh_temporalpole       rh_transversetemporal 
#>                   "#464646"                   "#9696C8" 
#>                   rh_insula                  rh_unknown 
#>                   "#FFC020"                   "#BEBEBE" 
```
