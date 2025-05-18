library(ncdf4)
library(raster)
library(lubridate)
library(ggplot2)
library(transformr)
library(gganimate)

# Open the NetCDF file
nc_data <- nc_open("2016-2045_pr_aus_ACCESS1-0_rcp45_r1i1p1_CSIRO-DecCh-wrt-1986-2005-Scl_v1_day_2016-2045.nc")
View(nc_data)

# Extract time values
time_vals <- ncvar_get(nc_data, "time")
time_units <- ncatt_get(nc_data, "time", "units")$value 
base_date <- as.Date(substr(time_units, 12, 21)) 
dates <- base_date + time_vals

temp <- brick("2016-2045_pr_aus_ACCESS1-0_rcp45_r1i1p1_CSIRO-DecCh-wrt-1986-2005-Scl_v1_day_2016-2045.nc", varname = "pr")
temp <- setZ(temp, dates)
names(temp) <- as.character(dates)

# Resample to yearly data
year_index <- format(dates, "%Y")
yearly_temp <- zApply(temp, by = year_index, fun = sum, name = "yearly_precip")

# Resample pixel size
yearly_10km <- aggregate(yearly_temp, fact = 2, fun = mean, expand = TRUE)
yearly_10km_df <- as.data.frame(yearly_10km, xy = TRUE)
yearly_10km_long <- reshape2::melt(yearly_10km_df, id.vars = c("x", "y"), variable.name = "year", value.name = "value")
yearly_10km_long

p <- ggplot(yearly_10km_long, aes(x = x, y = y, fill = value)) +
  geom_raster() +
  scale_fill_viridis_c() +
  coord_equal() +
  labs(
    title = 'RCP4.5 Scenario Year: {closest_state}',
    fill = "Precipitation (mm)",
    x = "Longitude",
    y = "Latitude"  # x is longitude, y is latitude
  ) +
  theme_minimal() +
  theme(
    axis.title.x = element_text(size = 14),
    axis.title.y = element_text(size = 14),
    plot.title = element_text(size = 16, face = "bold")
  ) +
  transition_states(year, transition_length = 2, state_length = 1)

animate(p, fps = 4, width = 800, height = 600)
anim_save("rcp45_animation.gif")



