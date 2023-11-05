#Merge extracted trees
require(raster)
require(rgdal)

transecto = '0125'

tree = shapefile(paste0('./',transecto,'/tree/tree',1,'.shp'))
for(i in c(2,3,4,6,7,8,9,11,12,13,14)){
    add.tree = shapefile(paste0('./',transecto,'/tree/tree',i,'.shp'))
    tree = union(tree, add.tree)
    print(i)
}

writeOGR(tree, paste0('./', transecto, '/tree/'), paste0('trees', transecto), driver="ESRI Shapefile")
