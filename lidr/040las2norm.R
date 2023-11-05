require(lidR)
require(raster)

ctg = readLAScatalog("./gnd/")
opt_chunk_buffer(ctg) = 30
opt_chunk_size(ctg) = 500
opt_output_files(ctg) = "./norm/tile{ID}_norm"

norm_ctg = normalize_height(ctg, dtm_ctg)

plot(norm_ctg, bg = "white")