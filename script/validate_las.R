setwd('/home/gorgens/Downloads/validate_R')

require(lidR) 
require(raster) 
require(rgdal) 
require(sf)
# ref: https://jean-romain.github.io/lidRbook/tba.html 

PROJETO = 'ST3_A01_ID7'
EPSG = 31982

SHAPE = shapefile('/home/gorgens/Downloads/validate_R/shape/LiDAR 2021 Paisagens Sustentáveis.shp')
SHAPE = spTransform(SHAPE, crs("+init=epsg:31981"))
SHAPE = subset(SHAPE, id = 7)

NP_FOLDER = paste0("/home/gorgens/Downloads/validate_R/", PROJETO, "/5 - Las Files")
DTM_FOLDER = paste0("/home/gorgens/Downloads/validate_R/", PROJETO, "/6 - MDT - GRD")
VALIDA_FOLDER = paste0("/home/gorgens/Downloads/validate_R/_validacao/", PROJETO)

dir.create(VALIDA_FOLDER)

# las check
ctg = readLAScatalog(NP_FOLDER) 
opt_chunk_buffer(ctg) = 100 
opt_chunk_size(ctg) = 1000 
opt_output_files(ctg) = paste0(VALIDA_FOLDER,"/checkReport")
sink(file = paste0(VALIDA_FOLDER,"/lasCheck.txt"))
las_check(ctg, print=TRUE)
sink(file = NULL)

# low density regions
ctg = readLAScatalog(NP_FOLDER) 
opt_chunk_buffer(ctg) = 100 
opt_chunk_size(ctg) = 1000 
dir.create(paste0(VALIDA_FOLDER,"/density"))
opt_output_files(ctg) = paste0(VALIDA_FOLDER,"/density/density_{ID}")
density = grid_density(ctg, 1)
crs(density) = crs("+init=epsg:31981")

lowDensity = (density < 4)
lowDensity = crop(lowDensity, SHAPE)
lowDensity = mask(lowDensity, SHAPE)
writeRaster(lowDensity, paste0(VALIDA_FOLDER,"/lowDensity.tif"))

# unir tiles de terreno
grds = list.files(DTM_FOLDER, pattern = "\\.grd$")
mdtEntregue = raster(paste0(DTM_FOLDER, "/", grds[1]))
for(r in grds[-1]){
	rtemp = raster(paste0(DTM_FOLDER, "/", r))
	mdtEntregue = raster::merge(mdtEntregue, rtemp)
}
crs(mdtEntregue) = crs("+init=epsg:31981")
writeRaster(mdtEntregue, paste0(VALIDA_FOLDER,"/mdtEntregue.tif"))
slope <- terrain(mdtEntregue, opt='slope')
aspect <- terrain(mdtEntregue, opt='aspect')
mdtHill <- hillShade(slope, aspect, 
                      angle=40, 
                      direction=270)
writeRaster(mdtHill, paste0(VALIDA_FOLDER,"/mdtHill.tif"))

# ground classification 
ctg = readLAScatalog(NP_FOLDER) 
opt_chunk_buffer(ctg) = 100 
opt_chunk_size(ctg) = 1000 
dir.create(paste0(VALIDA_FOLDER,"/class"))
opt_output_files(ctg) = paste0(VALIDA_FOLDER,"/class/gndClass_{ID}")
mycsf = csf(sloop_smooth = TRUE, class_threshold = 1, cloth_resolution = 1, time_step = 1) 
classified_ctg = classify_ground(ctg, mycsf) 

# digital terrain model creation 
ctg = readLAScatalog(paste0(VALIDA_FOLDER,"/class")) 
opt_chunk_buffer(ctg) = 30 
opt_chunk_size(ctg) = 1000 
dir.create(paste0(VALIDA_FOLDER,"/mdt"))
opt_output_files(ctg) = paste0(VALIDA_FOLDER,"/mdt/mdt_{ID}")
dtm_ctg = grid_terrain(ctg, res = 1, algorithm = knnidw(k = 10L, p = 2)) 

# normalize cloud 
ctg = readLAScatalog(paste0(VALIDA_FOLDER,"/class")) 
opt_chunk_buffer(ctg) = 30 
opt_chunk_size(ctg) = 1000 
dir.create(paste0(VALIDA_FOLDER,"/norm"))
opt_output_files(ctg) = paste0(VALIDA_FOLDER,"/norm/norm_{ID}")
norm_ctg = normalize_height(ctg, dtm_ctg) 

# canopy height model creation 
ctg = readLAScatalog(paste0(VALIDA_FOLDER,"/norm")) 
opt_chunk_buffer(ctg) = 30 
opt_chunk_size(ctg) = 1000 
dir.create(paste0(VALIDA_FOLDER,"/chm"))
opt_output_files(ctg) = paste0(VALIDA_FOLDER,"/chm/chm_{ID}")
chm_ctg = grid_canopy(ctg, 0.5, pitfree(subcircle = 0.2))

# histogram terrain differences
rtemp = crop(mdtEntregue, SHAPE)
rtemp = mask(rtemp, SHAPE)
rtemp2 = crop(dtm_ctg, SHAPE)
rtemp2 = mask(rtemp2, SHAPE)
hist(rtemp - rtemp2)
