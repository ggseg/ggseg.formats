library(dplyr)
devtools::load_all("../ggsegExtra/")


dt <- make_ggseg_altas(
  "aparc",
  output_dir = here::here("data-raw/dk"),
  steps = 5:6,
  tolerance = 1,
  ncores = 14
)
dk <- ggseg::dk$data[, c("region", "label", "roi")]
dk$geometry <- NULL

dt$data <- dt$data |>
  select(-region) |>
  left_join(dk) |>
  select(names(dt$data), everything())

dk <- dt
dk$atlas <- "dk"
usethis::use_data(
  dk,
  internal = FALSE,
  overwrite = TRUE,
  compress = "xz"
)


# aseg ----
aseg_n <- aseg %>%
  mutate(atlas = "aseg") %>%
  as_brain_atlas()

fs_label <- "/Applications/freesurfer/7.2.0/subjects/fsaverage5/mri/aseg.mgz"
aseg_n <- make_volumetric_ggseg(
  label_file = fs_label,
  output_dir = "data-raw/aseg",
  steps = 8,
  tolerance = 1,
  smoothness = 2,

  vertex_size_limits = c(20, NA),
  ncores = 16,
  slices = dplyr::tribble(
    ~x, ~y, ~z, ~view,
    130, 130, 130, "axial",
    128, 136, 100, "axial",
    127, 135, 128, "coronal"
  )
)

aseg2 <- aseg_n
# # Do some data clean-up
aseg2$data <- aseg_n$data %>%
  filter(!is.na(region)) %>%
  mutate(
    region = gsub("cc ", "CC ", region),
    region = gsub("dc", " DC", region),
    region = ifelse(region == "cerebral cortex", NA, region)
  ) %>%
  filter(!grepl("white|csf", region)) %>%
  filter(side != "sagittal") |>
  rbind(
    aseg$data |>
      filter(side == "sagittal") |>
      mutate(roi = NA),
    all = TRUE
  )


ggseg(
  atlas = aseg2,
  show.legend = TRUE,
  colour = "black",
  mapping = aes(fill = region)
)

plot(aseg2)

ggplot() +
  geom_brain(atlas = aseg2)

aseg <- aseg2
aseg <- ggseg::aseg
usethis::use_data(
  aseg,
  internal = FALSE,
  overwrite = TRUE,
  compress = "xz"
)
