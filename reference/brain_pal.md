# Get brain atlas palette

Retrieves the colour palette from a brain atlas.

## Usage

``` r
brain_pal(name = "dk", ...)
```

## Arguments

- name:

  Character name of atlas (e.g., "dk", "aseg") or a brain_atlas object

- ...:

  Additional arguments (unused)

## Value

Named character vector of colours

## Examples

``` r
brain_pal("dk")
#>                  lh_unknown                 lh_bankssts 
#>                   "#190519"                   "#196428" 
#>      lh_caudalmiddlefrontal                 lh_fusiform 
#>                   "#641900"                   "#B4DC8C" 
#>                 lh_fusiform         lh_inferiorparietal 
#>                   "#B4DC8C"                   "#DC3CDC" 
#>         lh_inferiortemporal         lh_lateraloccipital 
#>                   "#B42878"                   "#141E8C" 
#>         lh_lateraloccipital     lh_lateralorbitofrontal 
#>                   "#141E8C"                   "#234B32" 
#>     lh_lateralorbitofrontal           lh_middletemporal 
#>                   "#234B32"                   "#A06432" 
#>          lh_parsopercularis            lh_parsorbitalis 
#>                   "#DCB48C"                   "#146432" 
#>         lh_parstriangularis              lh_postcentral 
#>                   "#DC3C14"                   "#DC1414" 
#>              lh_postcentral               lh_precentral 
#>                   "#DC1414"                   "#3C14DC" 
#>               lh_precentral     lh_rostralmiddlefrontal 
#>                   "#3C14DC"                   "#4B327D" 
#>          lh_superiorfrontal          lh_superiorfrontal 
#>                   "#14DCA0"                   "#14DCA0" 
#>         lh_superiorparietal         lh_superiorparietal 
#>                   "#14B48C"                   "#14B48C" 
#>         lh_superiortemporal            lh_supramarginal 
#>                   "#8CDCDC"                   "#50A014" 
#>             lh_temporalpole             lh_temporalpole 
#>                   "#464646"                   "#464646" 
#>       lh_transversetemporal                   lh_insula 
#>                   "#9696C8"                   "#FFC020" 
#>                  lh_unknown  lh_caudalanteriorcingulate 
#>                   "#190519"                   "#7D64A0" 
#>           lh_corpuscallosum                   lh_cuneus 
#>                   "#784632"                   "#DC1464" 
#>               lh_entorhinal                 lh_fusiform 
#>                   "#DC140A"                   "#B4DC8C" 
#>                 lh_fusiform         lh_isthmuscingulate 
#>                   "#B4DC8C"                   "#8C148C" 
#>         lh_lateraloccipital         lh_lateraloccipital 
#>                   "#141E8C"                   "#141E8C" 
#>     lh_lateralorbitofrontal     lh_lateralorbitofrontal 
#>                   "#234B32"                   "#234B32" 
#>                  lh_lingual      lh_medialorbitofrontal 
#>                   "#E18C8C"                   "#C8234B" 
#>          lh_parahippocampal              lh_paracentral 
#>                   "#14DC3C"                   "#3CDC3C" 
#>            lh_pericalcarine              lh_postcentral 
#>                   "#78643C"                   "#DC1414" 
#>              lh_postcentral       lh_posteriorcingulate 
#>                   "#DC1414"                   "#DCB4DC" 
#>               lh_precentral               lh_precentral 
#>                   "#3C14DC"                   "#3C14DC" 
#>                lh_precuneus lh_rostralanteriorcingulate 
#>                   "#A08CB4"                   "#50148C" 
#>          lh_superiorfrontal          lh_superiorfrontal 
#>                   "#14DCA0"                   "#14DCA0" 
#>         lh_superiorparietal         lh_superiorparietal 
#>                   "#14B48C"                   "#14B48C" 
#>              lh_frontalpole             lh_temporalpole 
#>                   "#640064"                   "#464646" 
#>             lh_temporalpole                  rh_unknown 
#>                   "#464646"                   "#190519" 
#>  rh_caudalanteriorcingulate           rh_corpuscallosum 
#>                   "#7D64A0"                   "#784632" 
#>                   rh_cuneus               rh_entorhinal 
#>                   "#DC1464"                   "#DC140A" 
#>                 rh_fusiform                 rh_fusiform 
#>                   "#B4DC8C"                   "#B4DC8C" 
#>         rh_isthmuscingulate         rh_lateraloccipital 
#>                   "#8C148C"                   "#141E8C" 
#>         rh_lateraloccipital     rh_lateralorbitofrontal 
#>                   "#141E8C"                   "#234B32" 
#>     rh_lateralorbitofrontal                  rh_lingual 
#>                   "#234B32"                   "#E18C8C" 
#>      rh_medialorbitofrontal          rh_parahippocampal 
#>                   "#C8234B"                   "#14DC3C" 
#>              rh_paracentral            rh_pericalcarine 
#>                   "#3CDC3C"                   "#78643C" 
#>              rh_postcentral              rh_postcentral 
#>                   "#DC1414"                   "#DC1414" 
#>       rh_posteriorcingulate               rh_precentral 
#>                   "#DCB4DC"                   "#3C14DC" 
#>               rh_precentral                rh_precuneus 
#>                   "#3C14DC"                   "#A08CB4" 
#> rh_rostralanteriorcingulate          rh_superiorfrontal 
#>                   "#50148C"                   "#14DCA0" 
#>          rh_superiorfrontal         rh_superiorparietal 
#>                   "#14DCA0"                   "#14B48C" 
#>         rh_superiorparietal              rh_frontalpole 
#>                   "#14B48C"                   "#640064" 
#>             rh_temporalpole             rh_temporalpole 
#>                   "#464646"                   "#464646" 
#>                  rh_unknown                 rh_bankssts 
#>                   "#190519"                   "#196428" 
#>      rh_caudalmiddlefrontal                 rh_fusiform 
#>                   "#641900"                   "#B4DC8C" 
#>                 rh_fusiform         rh_inferiorparietal 
#>                   "#B4DC8C"                   "#DC3CDC" 
#>         rh_inferiortemporal         rh_lateraloccipital 
#>                   "#B42878"                   "#141E8C" 
#>         rh_lateraloccipital     rh_lateralorbitofrontal 
#>                   "#141E8C"                   "#234B32" 
#>     rh_lateralorbitofrontal           rh_middletemporal 
#>                   "#234B32"                   "#A06432" 
#>          rh_parsopercularis            rh_parsorbitalis 
#>                   "#DCB48C"                   "#146432" 
#>         rh_parstriangularis              rh_postcentral 
#>                   "#DC3C14"                   "#DC1414" 
#>              rh_postcentral               rh_precentral 
#>                   "#DC1414"                   "#3C14DC" 
#>               rh_precentral     rh_rostralmiddlefrontal 
#>                   "#3C14DC"                   "#4B327D" 
#>          rh_superiorfrontal          rh_superiorfrontal 
#>                   "#14DCA0"                   "#14DCA0" 
#>         rh_superiorparietal         rh_superiorparietal 
#>                   "#14B48C"                   "#14B48C" 
#>         rh_superiortemporal            rh_supramarginal 
#>                   "#8CDCDC"                   "#50A014" 
#>             rh_temporalpole             rh_temporalpole 
#>                   "#464646"                   "#464646" 
#>       rh_transversetemporal                   rh_insula 
#>                   "#9696C8"                   "#FFC020" 
brain_pal("aseg")
#>        Left-Lateral-Ventricle             Left-Inf-Lat-Vent 
#>                     "#781286"                     "#C43AFA" 
#>  Left-Cerebellum-White-Matter        Left-Cerebellum-Cortex 
#>                     "#DCF8A4"                     "#E69422" 
#>          Left-Thalamus-Proper                  Left-Caudate 
#>                     "#00760E"                     "#7ABADC" 
#>                  Left-Putamen                 Left-Pallidum 
#>                     "#EC0DB0"                     "#0C30FF" 
#>                 3rd-Ventricle                 4th-Ventricle 
#>                     "#CCB68E"                     "#2ACCA4" 
#>                    Brain-Stem              Left-Hippocampus 
#>                     "#779FB0"                     "#DCD814" 
#>                 Left-Amygdala           Left-Accumbens-area 
#>                     "#67FFFF"                     "#FFA500" 
#>                Left-VentralDC       Right-Lateral-Ventricle 
#>                     "#A52A2A"                     "#781286" 
#>            Right-Inf-Lat-Vent Right-Cerebellum-White-Matter 
#>                     "#C43AFA"                     "#DCF8A4" 
#>       Right-Cerebellum-Cortex         Right-Thalamus-Proper 
#>                     "#E69422"                     "#00760E" 
#>                 Right-Caudate                 Right-Putamen 
#>                     "#7ABADC"                     "#EC0DB0" 
#>                Right-Pallidum             Right-Hippocampus 
#>                     "#0D30FF"                     "#DCD814" 
#>                Right-Amygdala          Right-Accumbens-area 
#>                     "#67FFFF"                     "#FFA500" 
#>               Right-VentralDC                  CC_Posterior 
#>                     "#A52A2A"                     "#000040" 
#>              CC_Mid_Posterior                    CC_Central 
#>                     "#000070"                     "#0000A0" 
#>               CC_Mid_Anterior                   CC_Anterior 
#>                     "#0000D0"                     "#0000FF" 
brain_pal(dk)
#>                  lh_unknown                 lh_bankssts 
#>                   "#190519"                   "#196428" 
#>      lh_caudalmiddlefrontal                 lh_fusiform 
#>                   "#641900"                   "#B4DC8C" 
#>                 lh_fusiform         lh_inferiorparietal 
#>                   "#B4DC8C"                   "#DC3CDC" 
#>         lh_inferiortemporal         lh_lateraloccipital 
#>                   "#B42878"                   "#141E8C" 
#>         lh_lateraloccipital     lh_lateralorbitofrontal 
#>                   "#141E8C"                   "#234B32" 
#>     lh_lateralorbitofrontal           lh_middletemporal 
#>                   "#234B32"                   "#A06432" 
#>          lh_parsopercularis            lh_parsorbitalis 
#>                   "#DCB48C"                   "#146432" 
#>         lh_parstriangularis              lh_postcentral 
#>                   "#DC3C14"                   "#DC1414" 
#>              lh_postcentral               lh_precentral 
#>                   "#DC1414"                   "#3C14DC" 
#>               lh_precentral     lh_rostralmiddlefrontal 
#>                   "#3C14DC"                   "#4B327D" 
#>          lh_superiorfrontal          lh_superiorfrontal 
#>                   "#14DCA0"                   "#14DCA0" 
#>         lh_superiorparietal         lh_superiorparietal 
#>                   "#14B48C"                   "#14B48C" 
#>         lh_superiortemporal            lh_supramarginal 
#>                   "#8CDCDC"                   "#50A014" 
#>             lh_temporalpole             lh_temporalpole 
#>                   "#464646"                   "#464646" 
#>       lh_transversetemporal                   lh_insula 
#>                   "#9696C8"                   "#FFC020" 
#>                  lh_unknown  lh_caudalanteriorcingulate 
#>                   "#190519"                   "#7D64A0" 
#>           lh_corpuscallosum                   lh_cuneus 
#>                   "#784632"                   "#DC1464" 
#>               lh_entorhinal                 lh_fusiform 
#>                   "#DC140A"                   "#B4DC8C" 
#>                 lh_fusiform         lh_isthmuscingulate 
#>                   "#B4DC8C"                   "#8C148C" 
#>         lh_lateraloccipital         lh_lateraloccipital 
#>                   "#141E8C"                   "#141E8C" 
#>     lh_lateralorbitofrontal     lh_lateralorbitofrontal 
#>                   "#234B32"                   "#234B32" 
#>                  lh_lingual      lh_medialorbitofrontal 
#>                   "#E18C8C"                   "#C8234B" 
#>          lh_parahippocampal              lh_paracentral 
#>                   "#14DC3C"                   "#3CDC3C" 
#>            lh_pericalcarine              lh_postcentral 
#>                   "#78643C"                   "#DC1414" 
#>              lh_postcentral       lh_posteriorcingulate 
#>                   "#DC1414"                   "#DCB4DC" 
#>               lh_precentral               lh_precentral 
#>                   "#3C14DC"                   "#3C14DC" 
#>                lh_precuneus lh_rostralanteriorcingulate 
#>                   "#A08CB4"                   "#50148C" 
#>          lh_superiorfrontal          lh_superiorfrontal 
#>                   "#14DCA0"                   "#14DCA0" 
#>         lh_superiorparietal         lh_superiorparietal 
#>                   "#14B48C"                   "#14B48C" 
#>              lh_frontalpole             lh_temporalpole 
#>                   "#640064"                   "#464646" 
#>             lh_temporalpole                  rh_unknown 
#>                   "#464646"                   "#190519" 
#>  rh_caudalanteriorcingulate           rh_corpuscallosum 
#>                   "#7D64A0"                   "#784632" 
#>                   rh_cuneus               rh_entorhinal 
#>                   "#DC1464"                   "#DC140A" 
#>                 rh_fusiform                 rh_fusiform 
#>                   "#B4DC8C"                   "#B4DC8C" 
#>         rh_isthmuscingulate         rh_lateraloccipital 
#>                   "#8C148C"                   "#141E8C" 
#>         rh_lateraloccipital     rh_lateralorbitofrontal 
#>                   "#141E8C"                   "#234B32" 
#>     rh_lateralorbitofrontal                  rh_lingual 
#>                   "#234B32"                   "#E18C8C" 
#>      rh_medialorbitofrontal          rh_parahippocampal 
#>                   "#C8234B"                   "#14DC3C" 
#>              rh_paracentral            rh_pericalcarine 
#>                   "#3CDC3C"                   "#78643C" 
#>              rh_postcentral              rh_postcentral 
#>                   "#DC1414"                   "#DC1414" 
#>       rh_posteriorcingulate               rh_precentral 
#>                   "#DCB4DC"                   "#3C14DC" 
#>               rh_precentral                rh_precuneus 
#>                   "#3C14DC"                   "#A08CB4" 
#> rh_rostralanteriorcingulate          rh_superiorfrontal 
#>                   "#50148C"                   "#14DCA0" 
#>          rh_superiorfrontal         rh_superiorparietal 
#>                   "#14DCA0"                   "#14B48C" 
#>         rh_superiorparietal              rh_frontalpole 
#>                   "#14B48C"                   "#640064" 
#>             rh_temporalpole             rh_temporalpole 
#>                   "#464646"                   "#464646" 
#>                  rh_unknown                 rh_bankssts 
#>                   "#190519"                   "#196428" 
#>      rh_caudalmiddlefrontal                 rh_fusiform 
#>                   "#641900"                   "#B4DC8C" 
#>                 rh_fusiform         rh_inferiorparietal 
#>                   "#B4DC8C"                   "#DC3CDC" 
#>         rh_inferiortemporal         rh_lateraloccipital 
#>                   "#B42878"                   "#141E8C" 
#>         rh_lateraloccipital     rh_lateralorbitofrontal 
#>                   "#141E8C"                   "#234B32" 
#>     rh_lateralorbitofrontal           rh_middletemporal 
#>                   "#234B32"                   "#A06432" 
#>          rh_parsopercularis            rh_parsorbitalis 
#>                   "#DCB48C"                   "#146432" 
#>         rh_parstriangularis              rh_postcentral 
#>                   "#DC3C14"                   "#DC1414" 
#>              rh_postcentral               rh_precentral 
#>                   "#DC1414"                   "#3C14DC" 
#>               rh_precentral     rh_rostralmiddlefrontal 
#>                   "#3C14DC"                   "#4B327D" 
#>          rh_superiorfrontal          rh_superiorfrontal 
#>                   "#14DCA0"                   "#14DCA0" 
#>         rh_superiorparietal         rh_superiorparietal 
#>                   "#14B48C"                   "#14B48C" 
#>         rh_superiortemporal            rh_supramarginal 
#>                   "#8CDCDC"                   "#50A014" 
#>             rh_temporalpole             rh_temporalpole 
#>                   "#464646"                   "#464646" 
#>       rh_transversetemporal                   rh_insula 
#>                   "#9696C8"                   "#FFC020" 
```
