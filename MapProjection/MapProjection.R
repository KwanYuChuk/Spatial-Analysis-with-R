# Kwan Yu Chuk
# 26/11/2024

library(sf)
library(ggplot2)
library(dplyr)
library(patchwork)
library(ggspatial)
library(rosm)
library(grid)

au <- st_read("au.shp")

au_50 <- st_transform(au, crs = 32750)
au_55 <- st_transform(au, crs = 32755)

crs50 <- ggplot() +
  geom_sf(data = au_50, fill = NA, color = "blue", linetype = "dashed") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5),
    legend.position = c(0.1, 0.1)) +
  labs(title = "Projection: Zone 50 (EPSG 32750)") +
  annotation_north_arrow(location = "bl", which_north = "true",
                         style = north_arrow_fancy_orienteering(),
                         pad_y = unit(0.5, "cm")) +
  annotation_scale(location = "bl", width_hint = 0.3) 


crs55 <- ggplot() +
  geom_sf(data = au_55, fill = NA, color = "blue", linetype = "dashed") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5),
    legend.position = c(0.1, 0.1)) +
  labs(title = "Projection: Zone 55 (EPSG 32755)") +
  annotation_north_arrow(location = "bl", which_north = "true",
                         style = north_arrow_fancy_orienteering(),
                         pad_y = unit(0.5, "cm")) +
  annotation_scale(location = "bl", width_hint = 0.3) +
  annotation_custom(
    grob = textGrob("Map produced by Kwan Yu Chuk.",
                    x = 0.5, y = 0.01, hjust = 0, vjust = 0, gp = gpar(fontsize = 10)),
    xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf
  )

crs50 + crs55
