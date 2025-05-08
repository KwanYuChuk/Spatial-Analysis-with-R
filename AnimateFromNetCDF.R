library(ncdf4)
library(raster)
library(ggplot2)
library(transformr)
install.packages("gganimate", dependencies = TRUE)
library(gganimate)
exists("transition_states")


nc_data <- nc_open("2016-2045_pr_aus_ACCESS1-0_rcp45_r1i1p1_CSIRO-DecCh-wrt-1986-2005-Scl_v1_day_2016-2045.nc")

# Check available variables
print(nc_data)

# Extract a variable (e.g., temperature)
temp <- brick("2016-2045_pr_aus_ACCESS1-0_rcp45_r1i1p1_CSIRO-DecCh-wrt-1986-2005-Scl_v1_day_2016-2045.nc", varname = "pr")

n_frames <- 100
temp_subset <- temp[[1:n_frames]]

# Convert to data frame
temp_df <- as.data.frame(temp_subset, xy = TRUE)
temp_long <- reshape2::melt(temp_df, id.vars = c("x", "y"), variable.name = "time", value.name = "value")

p <- ggplot(temp_long, aes(x = x, y = y, fill = value)) +
  geom_raster() +
  scale_fill_viridis_c() +
  coord_equal() +
  labs(title = 'Time: {closest_state}', fill = "Value") +
  theme_minimal() +
  transition_states(time, transition_length = 2, state_length = 1)

# Save animation
animate(p, nframes = n_frames, fps = 20, width = 800, height = 600)
anim_save("netcdf_animation.gif")
