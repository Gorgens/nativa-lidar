require(lidR)
require(raster)

# digital terrain model creation
ctg = readLAScatalog("./gnd/")
opt_chunk_buffer(ctg) = 30
opt_chunk_size(ctg) = 500
opt_output_files(ctg) = "./dtm/tile{ID}_dtm"

dtm_ctg = grid_terrain(ctg, res = 1, algorithm = knnidw(), na.rm = TRUE)

plot_dtm3d(dtm_ctg, bg = "white") 