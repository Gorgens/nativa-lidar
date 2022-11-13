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

ctg = raster(paste0("./chm/", chm.files[1]))
trees = locate_trees(ctg, lmf(ws = 30))

trees = as(trees, 'Spatial')
writeOGR(trees, dsn = "./chm/", layer = file_path_sans_ext(chm.files[1]) , driver = "ESRI Shapefile")
