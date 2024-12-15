# Kwan Yu Chuk
# 16/12/2024

library(terra)

# Define the folder containing raster files
input_folder <- "D:/1_Documents/carbonsync/proj0009/input"
output_folder <- "D:/1_Documents/carbonsync/proj0009/output"
reference_raster <- rast("PROJ0009_GIS_EVI_CEA1.tif")

# Define the target CRS
target_crs <- "EPSG:4326"

# List all .tif files in the folder
raster_files <- list.files(input_folder, pattern = "\\.tif$", full.names = TRUE)

# Loop 
for (file in raster_files) {
  r <- rast(file)
  
  # Align the resolution and extent with the reference raster
  aligned_raster <- resample(r, reference_raster, method = "bilinear")
  
  # Reproject to the new CRS (EPSG:4326)
  reprojected_raster <- project(aligned_raster, target_crs, method = "bilinear")
  
  output_file <- file.path(output_folder, paste0("reprojected_", basename(file)))
  
  writeRaster(reprojected_raster, output_file, overwrite = TRUE)
  
  cat("Processed:", file, "->", output_file, "\n")
}
