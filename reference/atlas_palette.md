# Get atlas palette

Retrieves the colour palette from a brain atlas.

## Usage

``` r
atlas_palette(name = "dk", ...)
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
atlas_palette(aseg())
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
atlas_palette(dk())
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
#>                   lh_insula                 rh_bankssts 
#>                   "#FFC020"                   "#196428" 
#>  rh_caudalanteriorcingulate      rh_caudalmiddlefrontal 
#>                   "#7D64A0"                   "#641900" 
#>           rh_corpuscallosum                   rh_cuneus 
#>                   "#784632"                   "#DC1464" 
#>               rh_entorhinal                 rh_fusiform 
#>                   "#DC140A"                   "#B4DC8C" 
#>         rh_inferiorparietal         rh_inferiortemporal 
#>                   "#DC3CDC"                   "#B42878" 
#>         rh_isthmuscingulate         rh_lateraloccipital 
#>                   "#8C148C"                   "#141E8C" 
#>     rh_lateralorbitofrontal                  rh_lingual 
#>                   "#234B32"                   "#E18C8C" 
#>      rh_medialorbitofrontal           rh_middletemporal 
#>                   "#C8234B"                   "#A06432" 
#>          rh_parahippocampal              rh_paracentral 
#>                   "#14DC3C"                   "#3CDC3C" 
#>          rh_parsopercularis            rh_parsorbitalis 
#>                   "#DCB48C"                   "#146432" 
#>         rh_parstriangularis            rh_pericalcarine 
#>                   "#DC3C14"                   "#78643C" 
#>              rh_postcentral       rh_posteriorcingulate 
#>                   "#DC1414"                   "#DCB4DC" 
#>               rh_precentral                rh_precuneus 
#>                   "#3C14DC"                   "#A08CB4" 
#> rh_rostralanteriorcingulate     rh_rostralmiddlefrontal 
#>                   "#50148C"                   "#4B327D" 
#>          rh_superiorfrontal         rh_superiorparietal 
#>                   "#14DCA0"                   "#14B48C" 
#>         rh_superiortemporal            rh_supramarginal 
#>                   "#8CDCDC"                   "#50A014" 
#>              rh_frontalpole             rh_temporalpole 
#>                   "#640064"                   "#464646" 
#>       rh_transversetemporal                   rh_insula 
#>                   "#9696C8"                   "#FFC020" 
```
