# This code is to merge na data
library(ncdf4)
library(raster)
library(lubridate)
library(ggplot2)
library(transformr)
library(gganimate)

# Open the NetCDF file
nc_data1 <- nc_open("2016-2045_pr_aus_ACCESS1-0_rcp45_r1i1p1_CSIRO-DecCh-wrt-1986-2005-Scl_v1_day_2016-2045.nc")
nc_data2 <- nc_open("2036-2065_pr_aus_ACCESS1-0_rcp45_r1i1p1_CSIRO-DecCh-wrt-1986-2005-Scl_v1_day_2036-2065.nc")
nc_data3 <- nc_open("2056-2085_pr_aus_ACCESS1-0_rcp45_r1i1p1_CSIRO-DecCh-wrt-1986-2005-Scl_v1_day_2056-2085.nc")
View(nc_data1)

r1 <- brick("2016-2045_pr_aus_ACCESS1-0_rcp45_r1i1p1_CSIRO-DecCh-wrt-1986-2005-Scl_v1_day_2016-2045.nc", varname = "pr")
r2 <- brick("2036-2065_pr_aus_ACCESS1-0_rcp45_r1i1p1_CSIRO-DecCh-wrt-1986-2005-Scl_v1_day_2036-2065.nc", varname = "pr")
r3 <- brick("2056-2085_pr_aus_ACCESS1-0_rcp45_r1i1p1_CSIRO-DecCh-wrt-1986-2005-Scl_v1_day_2056-2085.nc", varname = "pr")

time1 <- ncvar_get(nc_data1, "time")  
time_units <- ncatt_get(nc_data1, "time", "units")$value
dates1 <- as.Date(time1, origin = sub("days since ", "", time_units))
nc_close(nc_data1)

time2 <- ncvar_get(nc_data2, "time")
time_units2 <- ncatt_get(nc_data2, "time", "units")$value
dates2 <- as.Date(time2, origin = sub("days since ", "", time_units2))
nc_close(nc_data2)

time3 <- ncvar_get(nc_data3, "time")
time_units3 <- ncatt_get(nc_data3, "time", "units")$value
dates3 <- as.Date(time3, origin = sub("days since ", "", time_units3))
nc_close(nc_data3)

all_rasters <- stack(r1, r2, r3)
all_dates <- c(dates1, dates2, dates3)

# Identify unique dates and their first occurrences
unique_idx <- !duplicated(all_dates)
unique_dates <- all_dates[unique_idx]

# Subset raster stack to unique layers
unique_rasters <- all_rasters[[which(unique_idx)]]

names(unique_rasters) <- as.character(unique_dates)

writeRaster(unique_rasters, filename = "2016-2085_pr_aus_ACCESS1-0_rcp45.nc", format = "CDF", overwrite = TRUE)
