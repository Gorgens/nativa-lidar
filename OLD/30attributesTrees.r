require(raster)
require(rgdal)
require(terra)

## 0125

dtm0125 = raster('./0125/dtm/rasterize_terrain.vrt')
aspect0125 = terrain(dtm0125, opt = "aspect", unit = "degrees")
slope0125 = terrain(dtm0125, opt = "slope", unit = "degrees")
tpi0125 = terrain(dtm0125, opt = "TPI", neighbors=8)
tri0125 = terrain(dtm0125, opt = "TRI", neighbors=8)
rough0125 = terrain(dtm0125, opt = "roughness", neighbors=8)
flowdir0125 = terrain(dtm0125, opt = "flowdir", neighbors=8)

trees = shapefile('./treesV2/trees0125.shp')
trees$aspect = extract(aspect0125, trees)
trees$slope = extract(slope0125, trees)
trees$tpi = extract(tpi0125, trees)
trees$tri = extract(tri0125, trees)
trees$rough = extract(rough0125, trees)
trees$flow = extract(flowdir0125, trees)

writeOGR(trees, './treesV2/', 'trees0125terrain', driver="ESRI Shapefile")
rm(dtm0125, aspect0125, slope0125, tpi0125, tri0125, rough0125, flowdir0125)
    
## 0127

dtm0127 = raster('./0127/dtm/rasterize_terrain.vrt')
aspect0127 = terrain(dtm0127, opt = "aspect", unit = "degrees")
slope0127 = terrain(dtm0127, opt = "slope", unit = "degrees")
tpi0127 = terrain(dtm0127, opt = "TPI")
tri0127 = terrain(dtm0127, opt = "TRI")
rough0127 = terrain(dtm0127, opt = "roughness")
flowdir0127 = terrain(dtm0127, opt = "flowdir")

trees = shapefile('./treesV2/trees0127.shp')
trees$aspect = extract(aspect0127, trees)
trees$slope = extract(slope0127, trees)
trees$tpi = extract(tpi0127, trees)
trees$tri = extract(tri0127, trees)
trees$rough = extract(rough0127, trees)
trees$flow = extract(flowdir0127, trees)

writeOGR(trees, './treesV2/', 'trees0127terrain', driver="ESRI Shapefile")
rm(dtm0127, aspect0127, slope0127, tpi0127, tri0127, rough0127, flowdir0127)

## 0128

dtm0128 = raster('./0128/dtm/rasterize_terrain.vrt')
aspect0128 = terrain(dtm0128, opt = "aspect", unit = "degrees")
slope0128 = terrain(dtm0128, opt = "slope", unit = "degrees")
tpi0128 = terrain(dtm0128, opt = "TPI")
tri0128 = terrain(dtm0128, opt = "TRI")
rough0128 = terrain(dtm0128, opt = "roughness")
flowdir0128 = terrain(dtm0128, opt = "flowdir")

trees = shapefile('./treesV2/trees0128.shp')
trees$aspect = extract(aspect0128, trees)
trees$slope = extract(slope0128, trees)
trees$tpi = extract(tpi0128, trees)
trees$tri = extract(tri0128, trees)
trees$rough = extract(rough0128, trees)
trees$flow = extract(flowdir0128, trees)

writeOGR(trees, './treesV2/', 'trees0128terrain', driver="ESRI Shapefile")
rm(dtm0128, aspect0128, slope0128, tpi0128, tri0128, rough0128, flowdir0128)

## 0477

dtm0477 = raster('./0477/dtm/rasterize_terrain.vrt')
aspect0477 = terrain(dtm0477, opt = "aspect", unit = "degrees")
slope0477 = terrain(dtm0477, opt = "slope", unit = "degrees")
tpi0477 = terrain(dtm0477, opt = "TPI")
tri0477 = terrain(dtm0477, opt = "TRI")
rough0477 = terrain(dtm0477, opt = "roughness")
flowdir0477 = terrain(dtm0477, opt = "flowdir")

trees = shapefile('./treesV2/trees0477.shp')
trees$aspect = extract(aspect0477, trees)
trees$slope = extract(slope0477, trees)
trees$tpi = extract(tpi0477, trees)
trees$tri = extract(tri0477, trees)
trees$rough = extract(rough0477, trees)
trees$flow = extract(flowdir0477, trees)

writeOGR(trees, './treesV2/', 'trees0477terrain', driver="ESRI Shapefile")
rm(dtm0477, aspect0477, slope0477, tpi0477, tri0477, rough0477, flowdir0477)

## 0523

dtm0523 = raster('./0523/dtm/rasterize_terrain.vrt')
aspect0523 = terrain(dtm0523, opt = "aspect", unit = "degrees")
slope0523 = terrain(dtm0523, opt = "slope", unit = "degrees")
tpi0523 = terrain(dtm0523, opt = "TPI")
tri0523 = terrain(dtm0523, opt = "TRI")
rough0523 = terrain(dtm0523, opt = "roughness")
flowdir0523 = terrain(dtm0523, opt = "flowdir")

trees = shapefile('./treesV2/trees0523.shp')
trees$aspect = extract(aspect0523, trees)
trees$slope = extract(slope0523, trees)
trees$tpi = extract(tpi0523, trees)
trees$tri = extract(tri0523, trees)
trees$rough = extract(rough0523, trees)
trees$flow = extract(flowdir0523, trees)

writeOGR(trees, './treesV2/', 'trees0523terrain', driver="ESRI Shapefile")
rm(dtm0523, aspect0523, slope0523, tpi0523, tri0523, rough0523, flowdir0523)

## 0599

dtm0599 = raster('./0599/dtm/rasterize_terrain.vrt')
aspect0599 = terrain(dtm0599, opt = "aspect", unit = "degrees")
slope0599 = terrain(dtm0599, opt = "slope", unit = "degrees")
tpi0599 = terrain(dtm0599, opt = "TPI")
tri0599 = terrain(dtm0599, opt = "TRI")
rough0599 = terrain(dtm0599, opt = "roughness")
flowdir0599 = terrain(dtm0599, opt = "flowdir")

trees = shapefile('./treesV2/trees0599.shp')
trees$aspect = extract(aspect0599, trees)
trees$slope = extract(slope0599, trees)
trees$tpi = extract(tpi0599, trees)
trees$tri = extract(tri0599, trees)
trees$rough = extract(rough0599, trees)
trees$flow = extract(flowdir0599, trees)

writeOGR(trees, './treesV2/', 'trees0599terrain', driver="ESRI Shapefile")
rm(dtm0599, aspect0599, slope0599, tpi0599, tri0599, rough0599, flowdir0599)

modeling = c()





## Garbage
#head(trees)
#
#tpiw <- function(x, w=5) {
#	m <- matrix(1/(w^2-1), nc=w, nr=w)
#	m[ceiling(0.5 * length(m))] <- 0
#	f <- focal(x, m)
#	x - f
#}
#tpiw0125 = tpiw(dtm0125, w=25)