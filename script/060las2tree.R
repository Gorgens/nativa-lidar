require(lidR)
require(raster)
require(sf)


# extrair árvores baseado no máximo local
ctg = readLAScatalog("./norm/")
opt_chunk_buffer(ctg) = 30
opt_chunk_size(ctg) = 500
opt_output_files(ctg) = "./tree/tile{ID}_tree"

ttops = locate_trees(ctg, lmf(ws = 5))

plot(chm_ctg, col = height.colors(50))
tree1 = shapefile('./tree/tile1_tree.shp')
tree2 = shapefile('./tree/tile2_tree.shp')
tree3 = shapefile('./tree/tile3_tree.shp')
tree4 = shapefile('./tree/tile4_tree.shp')
tree5 = shapefile('./tree/tile5_tree.shp')
tree6 = shapefile('./tree/tile6_tree.shp')
tree7 = shapefile('./tree/tile7_tree.shp')
tree8 = shapefile('./tree/tile8_tree.shp')
tree9 = shapefile('./tree/tile9_tree.shp')
tree = union(tree1, tree2)
tree = union(tree, tree3)
tree = union(tree, tree4)
tree = union(tree, tree5)
tree = union(tree, tree6)
tree = union(tree, tree7)
tree = union(tree, tree8)
tree = union(tree, tree9)
plot(tree, add=TRUE)
