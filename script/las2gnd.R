require(lidR)
require(raster)
require(RCSF)

# ground classification
ctg = readLAScatalog("./las/")
opt_chunk_buffer(ctg) = 30
opt_chunk_size(ctg) = 500
opt_output_files(ctg) = "./gnd/tile{ID}_gnd"
classified_ctg = classify_ground(ctg, csf())
