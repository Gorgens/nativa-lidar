require(lidR)
require(raster)

# Load data and check extention
ctg = readLAScatalog("./las/")
plot(ctg)

# if necessary retile
opt_chunk_buffer(ctg) = 0
opt_chunk_size(ctg) = 1000
opt_output_files(ctg) = "./las2/NP_T-403_tile{ID}"
newctg = catalog_retile(ctg)

