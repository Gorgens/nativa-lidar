require(raster)
require(rgdal)
require(terra)
require(ggplot2)
require(gridExtra)

temp = shapefile('./treesClean/trees0125terrain.shp')
trees = temp@data

temp = shapefile('./treesClean/trees0127terrain.shp')
trees = rbind(trees, temp@data)

temp = shapefile('./treesClean/trees0128terrain.shp')
trees = rbind(trees, temp@data)

temp = shapefile('./treesClean/trees0477terrain.shp')
trees = rbind(trees, temp@data)

temp = shapefile('./treesClean/trees0523terrain.shp')
trees = rbind(trees, temp@data)

temp = shapefile('./treesClean/trees0599terrain.shp')
trees = rbind(trees, temp@data)

names(trees)
#'treeID''Z''aspect''slope''tpi''tri''rough''flow'

dim(trees)
trees = na.omit(trees)
dim(trees)

## aspect

ggplot(trees, aes(aspect, Z)) + geom_point(alpha = 0.2)

nbins = 20
bins = seq(floor(min(trees$aspect)), ceiling(max(trees$aspect)), length.out = nbins)
interval = bins[2] - bins[1]
efborder = data.frame(treeID=integer(),
                 Z=double(),
                 aspect=double(),
                 slope=double(),
                 tpi=double(),
                 tri=double(),
                 rough=double(),
                 flow=double())

i = 1
while(i < nbins){
  temp = subset(trees, (aspect > bins[i] & aspect <= (bins[i]+interval))) 
  temp = temp[order(temp$Z, decreasing = TRUE), ]
  efborder = rbind(efborder, head(temp, 3))
  i = i + 1
}

gaspect = ggplot(trees, aes(aspect, Z)) + geom_point(alpha = 0.2) + geom_point(data = efborder, colour='red')


## slope

ggplot(trees, aes(slope, Z)) + geom_point(alpha = 0.2)

nbins = 20
bins = seq(floor(min(trees$slope)), ceiling(max(trees$slope)), length.out = nbins)
interval = bins[2] - bins[1]
efborder = data.frame(treeID=integer(),
                 Z=double(),
                 aspect=double(),
                 slope=double(),
                 tpi=double(),
                 tri=double(),
                 rough=double(),
                 flow=double())

i = 1
while(i < nbins){
  temp = subset(trees, (slope > bins[i] & slope <= (bins[i]+interval))) 
  temp = temp[order(temp$Z, decreasing = TRUE), ]
  efborder = rbind(efborder, head(temp, 3))
  i = i + 1
}

gslope = ggplot(trees, aes(slope, Z)) + geom_point(alpha = 0.2) + geom_point(data = efborder, colour='red')

## tpi

ggplot(trees, aes(tpi, Z)) + geom_point(alpha = 0.2) + xlim(-2,0)

nbins = 20
bins = seq(-2, ceiling(max(trees$tpi)), length.out = nbins)
interval = bins[2] - bins[1]
efborder = data.frame(treeID=integer(),
                 Z=double(),
                 aspect=double(),
                 slope=double(),
                 tpi=double(),
                 tri=double(),
                 rough=double(),
                 flow=double())

i = 1
while(i < nbins){
  temp = subset(trees, (tpi > bins[i] & tpi <= (bins[i]+interval))) 
  temp = temp[order(temp$Z, decreasing = TRUE), ]
  efborder = rbind(efborder, head(temp, 3))
  i = i + 1
}

gtpi = ggplot(trees, aes(tpi, Z)) + geom_point(alpha = 0.2) + xlim(-2,0) + geom_point(data = efborder, colour='red')

## tri

ggplot(trees, aes(tri, Z)) + geom_point(alpha = 0.2) + xlim(0,2)

nbins = 20
bins = seq(floor(min(trees$tri)), 2, length.out = nbins)
interval = bins[2] - bins[1]
efborder = data.frame(treeID=integer(),
                 Z=double(),
                 aspect=double(),
                 slope=double(),
                 tpi=double(),
                 tri=double(),
                 rough=double(),
                 flow=double())

i = 1
while(i < nbins){
  temp = subset(trees, (tri > bins[i] & tri <= (bins[i]+interval))) 
  temp = temp[order(temp$Z, decreasing = TRUE), ]
  efborder = rbind(efborder, head(temp, 3))
  i = i + 1
}

gtri = ggplot(trees, aes(tri, Z)) + geom_point(alpha = 0.2) + xlim(0,2) + geom_point(data = efborder, colour='red')

## rough

ggplot(trees, aes(rough, Z)) + geom_point(alpha = 0.2) + xlim(0,8)

nbins = 20
bins = seq(floor(min(trees$rough)), 8, length.out = nbins)
interval = bins[2] - bins[1]
efborder = data.frame(treeID=integer(),
                 Z=double(),
                 aspect=double(),
                 slope=double(),
                 tpi=double(),
                 tri=double(),
                 rough=double(),
                 flow=double())

i = 1
while(i < nbins){
  temp = subset(trees, (rough > bins[i] & rough <= (bins[i]+interval))) 
  temp = temp[order(temp$Z, decreasing = TRUE), ]
  efborder = rbind(efborder, head(temp, 3))
  i = i + 1
}

grough = ggplot(trees, aes(rough, Z)) + geom_point(alpha = 0.2) + xlim(0,8) + geom_point(data = efborder, colour='red')

grid.arrange(gaspect, gslope, gtpi, gtri,grough, ncol = 2)
