# author: Kwan Yu Chuk
# date: 10/12/2024

library(terra)

raster <- rast("dem.tif")  
mask <- vect("boundary.shp")    

plot(raster)
plot(mask)

# Clip the raster using the mask
clipped_raster <- mask(raster, mask)

# Save the clipped raster
writeRaster(clipped_raster, "clipped_raster.tif", overwrite = TRUE)

# Plot to visualize
plot(clipped_raster, 
     ext = ext(mask),
     col = terrain.colors(100), 
     main = "Elevation")

plot(mask, add = TRUE, border = "black", lwd = 3, lty = 2) 
