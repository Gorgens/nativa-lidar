# LiDAR in planetary computer
require(raster)
require(tidyverse)
require(terra)
require(lidR)
require(sf)
require(rgdal)
library(future)

plan(multisession)

ctg = readLAScatalog("./las/NP_T-0599.laz")
opt_chunk_buffer(ctg) = 30
opt_chunk_size(ctg) = 2000
opt_output_files(ctg) = "./0599/gnd/gnd{ID}"
ws = seq(3, 12, 3)
th = seq(0.1, 1.5, length.out = length(ws))
classified_ctg = classify_ground(ctg, algorithm = pmf(ws = ws, th = th))

classified_ctg = readLAScatalog("./0599/gnd/")
opt_output_files(classified_ctg) = "./0599/dtm/mdt{ID}"
dtm_ctg = grid_terrain(classified_ctg, res = 1, algorithm = knnidw(k = 10L, p = 2), na.rm = TRUE)
#plot(raster('./0599/dtm/rasterize_terrain.vrt'))

classified_ctg = readLAScatalog("./0599/gnd/")
opt_output_files(classified_ctg) = "./0599/norm/norm{ID}"
norm_ctg = normalize_height(classified_ctg, knnidw())

norm_ctg = readLAScatalog("./0599/norm/")
opt_output_files(norm_ctg) = "./0599/filtered/filtered{ID}"
#filter_ctg = classify_noise(norm_ctg, sor(30, 3.5))
filter_ctg = classify_noise(norm_ctg, ivf(5, 2))

filter_ctg = readLAScatalog("./0599/filtered/")
opt_output_files(filter_ctg) = "./0599/chm/chm{ID}"
#chm_ctg = rasterize_canopy(filter_ctg, res = 1, algorithm = p2r(subcircle = 0.15, na.fill = tin()))
#plot(raster('./0125/chm/rasterize_canopy.vrt'))
w = matrix(1, 3, 3)
chm_ctg = rasterize_canopy(filter_ctg, res = 1, algorithm = p2r(subcircle = 0.15), na.fill = tin(), pkg = "terra")
smoothed = terra::focal(chm_ctg, w, fun = median, na.rm = TRUE)
writeRaster(smoothed, './0599/chm/chmSmoothed.tif')

#filter_ctg = readLAScatalog("./0125/filtered/")
#opt_output_files(filter_ctg) = "./0125/tree/tree{ID}"
#trees = locate_trees(filter_ctg, lmf(ws = 50))
trees = locate_trees(smoothed, lmf(ws = 50))
writeOGR(as_Spatial(trees), './treesV2/', 'trees0599', driver="ESRI Shapefile")
