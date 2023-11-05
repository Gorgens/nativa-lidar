require(lidR)
require(raster)

# canopy height model creation
ctg = readLAScatalog("./norm/")
opt_chunk_buffer(ctg) = 30
opt_chunk_size(ctg) = 500
opt_output_files(ctg) = "./chm/tile{ID}_chm"
chm_ctg = grid_canopy(ctg, res = 1, p2r())

col <- height.colors(25)
plot(chm_ctg, col=col)