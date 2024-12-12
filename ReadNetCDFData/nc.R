library(ncdf4)   
library(raster) 
library(sf)      
library(ggplot2)

# Open the NetCDF file
file_path <- "CFSR_sst.nc"
nc_data <- nc_open(file_path)
nc_data

# another way to open NetCDF file
r <- brick(file_path)  # Load NetCDF as a raster brick
r

# Convert to data frame
r_df <- as.data.frame(r[[1]], xy = TRUE)

# Plot
ggplot(r_df, aes(x = x, y = y, fill = X0)) +
  geom_raster() +
  scale_fill_viridis_c() +
  theme_minimal() +
  labs(title = "SST", x = "Longitude", y = "Latitude")


