# Teste planetary computer
require(raster)
require(tidyverse)
require(terra)
require(lidR)
require(sf)
require(rgdal)
require(tools)

chm.files = list.files("./chm/")
chm.files

chm.files = raster(paste0("./chm/", chm.files[1]))
trees = locate_trees(chm.files, lmf(ws = 30))

trees = as(trees, 'Spatial')
trees70 = subset(trees, Z > 70)

#writeOGR(trees, dsn = "./trees/", layer = file_path_sans_ext(chm.files[1]), driver = "ESRI Shapefile")
writeOGR(trees, "./trees/", file_path_sans_ext(chm.files[1]), driver="ESRI Shapefile")