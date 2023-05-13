require(raster)
require(terra)
require(lidR)

PROJETO = 'NESBSB00172_Valeria_I'
WORK.PATH = "C:\\FUSION\\CENIBRA\\NESBSB00172_Valeria_I\\"
ORIG.LAS = "C:\\FUSION\\CENIBRA\\NESBSB00172_Valeria_I\\NESBSB00172_Valeria_I_NP\\"
setwd(WORK.PATH)

# CATALOG FILE -------------- START 15:44 END 15:53
# Coordenadas Catalog: 667961.2497	7788897.4	675498.2897	7793970.22
INFO.PATH = "info\\"
dir.create("info") 
print(paste("c:\\fusion\\Catalog",
            paste(ORIG.LAS, "*.las", sep=""),
            paste(WORK.PATH, INFO.PATH, "catalog", sep="")))
shell(paste("c:\\fusion\\Catalog",
            paste(ORIG.LAS, "*.las", sep=""),
            paste(WORK.PATH, INFO.PATH, "catalog", sep="")))

# PARAMETROS OPCIONAIS -----------
THIN = FALSE
  DEN = 5
  WT = 50

GRID = TRUE
  RES.GRID = 40 
  HEIGHT = 3

CHM.PATH = "chm\\"
THIN.PATH = "thin\\"
GRID.PATH = "grid\\"
TREE.PATH = "tree\\"

# TILING -------------------------
TILES.PATH = "tiles\\"
BUFFER =  50    #300    
MINX =   667961
MINY =   7788897  
MAXX =   675499
MAXY =   7793971 
XSTEP = (MAXX - MINX)/4 #1000
YSTEP = (MAXY - MINY)/4 #1000
xBounds = seq(MINX, MAXX, by = XSTEP) #seq(MINX, MAXX+XSTEP/2, by = XSTEP) 
yBounds = rev(seq(MINY, MAXY, by = YSTEP)) #rev(seq(MINY, MAXY+YSTEP/2, by = YSTEP))
dir.create("tiles")  
for (xCol in seq(1, length(xBounds)-1)){
  for (yLin in seq(1, length(yBounds)-1)){
    print(paste("c:\\fusion\\clipdata",
                paste(ORIG.LAS, "*.las", sep=""),
                paste(WORK.PATH, TILES.PATH, "tile00",yLin,"x00",xCol,".las", sep=""),
                xBounds[xCol], yBounds[yLin+1], xBounds[xCol+1], yBounds[yLin]))
    shell(paste("c:\\fusion\\clipdata",
                paste(ORIG.LAS, "*.las", sep=""),
                paste(WORK.PATH, TILES.PATH, "tile00",yLin,"x00",xCol,".las", sep=""),
                xBounds[xCol] - BUFFER, yBounds[yLin+1] - BUFFER, 
                xBounds[xCol+1] + BUFFER, yBounds[yLin] + BUFFER))
  }
}

# CLEAN OUTLIER ------------------  START 16:10 END 16:11
CLEAN.PATH = "clean\\"
SD = 4.5 
WD = 30
LAS.FILES = list.files(paste(WORK.PATH, TILES.PATH, sep=""), pattern = "*.las")
dir.create("clean")
for (i in LAS.FILES){
  LAS = paste(WORK.PATH, TILES.PATH, i, sep="")
  CLN = paste(WORK.PATH, CLEAN.PATH, tools::file_path_sans_ext(i), "Clean.las", sep="")
  print(paste("c:\\fusion\\filterdata outlier", SD, WD, CLN, LAS))
  shell(paste("c:\\fusion\\filterdata outlier", SD, WD, CLN, LAS))
}

# DIGITAL TERRAIN MODEL ------------- START 16:18  END 16:22
GND.PATH = "gnd\\"
DTM.PATH = "dtm\\"
RES.DTM = 1
WIN.DTM = 5
LAS.FILES = list.files(paste(WORK.PATH, CLEAN.PATH, sep=""), pattern = "*.las")
dir.create("gnd")
dir.create("dtm")
for (i in LAS.FILES){
  LAS = paste(WORK.PATH, CLEAN.PATH, i, sep="")
  GND = paste(WORK.PATH, GND.PATH, tools::file_path_sans_ext(i), "gnd.las", sep="")
  print(paste("c:\\fusion\\GroundFilter", GND, WIN.DTM, LAS))
  shell(paste("c:\\fusion\\GroundFilter", GND, WIN.DTM, LAS))
  DTM = paste(WORK.PATH, DTM.PATH, tools::file_path_sans_ext(i), "dtm.dtm", sep="")
  DTM2 = paste(WORK.PATH, DTM.PATH, tools::file_path_sans_ext(i), "dtm.asc", sep="")
  print(paste("c:\\fusion\\GridSurfaceCreate", DTM, RES.DTM,"m m 1 0 0 0", GND))
  shell(paste("c:\\fusion\\GridSurfaceCreate", DTM, RES.DTM,"m m 1 0 0 0", GND))
  print(paste("c:\\fusion\\dtm2ascii",DTM, DTM2))
  shell(paste("c:\\fusion\\dtm2ascii", DTM, DTM2))
}

# CLIP DTM ----------   START 16:28  END 16:30
require(raster)
for (c in seq(1, length(xBounds)-1)){
  for (l in seq(1, length(yBounds)-1)){
    print(c(l, c))
    boundary = as(extent(xBounds[c], xBounds[c+1], yBounds[l+1], yBounds[l]), 'SpatialPolygons')
    if(file.exists(paste(WORK.PATH, DTM.PATH, "tile00",l,"x00",c,"Cleandtm.asc", sep=""))){
      chmTemp = tryCatch({
        raster(paste(WORK.PATH, DTM.PATH, "tile00",l,"x00",c,"Cleandtm.asc", sep=""))
      }, warning = function(w) {
        hasCHM = FALSE
      }, error = function(e) {
        hasCHM = FALSE
      }, finally = {
        hasCHM = TRUE
      })
      
      if(is.null(intersect(extent(chmTemp), boundary))){
        
      }else{
        chmTemp = crop(chmTemp, boundary)
        writeRaster(chmTemp, paste(WORK.PATH, DTM.PATH, "tile00",l,"x00",c,"CleanDtmCrop.tif", sep=""))
      }
    }
  }
}

img = list.files(paste(WORK.PATH, DTM.PATH, sep=""), pattern = "*.tif", full.names=TRUE)
ic = sprc(lapply(img, rast))
r = mosaic(ic)
writeRaster(r, paste0(WORK.PATH, DTM.PATH, PROJETO,".asc"))
print(paste("c:\\fusion\\ASCII2DTM", paste0(WORK.PATH, DTM.PATH, PROJETO,".dtm"), "m m 1 0 0 0", paste0(WORK.PATH, DTM.PATH, PROJETO,".asc")))
shell(paste("c:\\fusion\\ASCII2DTM", paste0(WORK.PATH, DTM.PATH, PROJETO,".dtm"), "m m 1 0 0 0", paste0(WORK.PATH, DTM.PATH, PROJETO,".asc")))

# THINNING DATA ---------------
dir.create("thin")
for (i in LAS.FILES){
	if (THIN){
	  if (CLEAN){
		LAS = paste(WORK.PATH, CLEAN.PATH, tools::file_path_sans_ext(i), ".las", sep="")
	  } else {
		LAS = paste(WORK.PATH, TILES.PATH, tools::file_path_sans_ext(i), ".las", sep="")
	  }
	  THN = paste(WORK.PATH, THIN.PATH, tools::file_path_sans_ext(i), "Thin.las", sep = "")
	  print(paste("c:\\fusion\\ThinData", 
				  THN, DEN, WT, LAS))
	  shell(paste("c:\\fusion\\ThinData", 
				  THN, DEN, WT, LAS))
	  LAS = paste(WORK.PATH, THIN.PATH, tools::file_path_sans_ext(i), "Thin.las", sep="")
	}
}
# CANOPY HEIGHT MODEL --------------  START 16:53  END 16:55
RES.CHM = 1
dir.create("chm")
for (i in LAS.FILES){
  LAS = paste(WORK.PATH, CLEAN.PATH, i, sep="")
  if(THIN){
    CHM = paste(WORK.PATH, CHM.PATH, tools::file_path_sans_ext(i), "Thinchm.dtm", sep="")
    CHM2 = paste(WORK.PATH, CHM.PATH, tools::file_path_sans_ext(i), "Thinchm.tif", sep="")
  } else {
    CHM = paste(WORK.PATH, CHM.PATH, tools::file_path_sans_ext(i), "chm.dtm", sep="")
    CHM2 = paste(WORK.PATH, CHM.PATH, tools::file_path_sans_ext(i), "chm.tif", sep="")
  }
  DTM = paste(WORK.PATH, DTM.PATH, tools::file_path_sans_ext(i), "dtm.dtm", sep="")
  
  print(paste("c:\\fusion\\CanopyModel", 
              paste("/ground:", DTM, sep = ""),
              "/ascii", CHM, RES.CHM, "m m 1 0 0 0", LAS))
  shell(paste("c:\\fusion\\CanopyModel", 
              paste("/ground:", DTM, sep = ""),
              "/ascii", CHM, RES.CHM, "m m 1 0 0 0", LAS))
}
  
# GRID METRICS ------------------   START 15:08  END 15:11
dir.create("grid")
if (GRID){
	for (i in LAS.FILES){
		LAS = paste(WORK.PATH, CLEAN.PATH, i, sep="")
		GRD = paste(WORK.PATH, GRID.PATH, tools::file_path_sans_ext(i), "grid.csv", sep="")
		  
		print(paste("c:\\fusion\\gridmetrics", 
					"/nointensity",
					DTM, HEIGHT, RES.GRID, GRD, LAS))
		shell(paste("c:\\fusion\\gridmetrics", 
					"/nointensity",
					DTM, HEIGHT, RES.GRID, GRD, LAS))

# Metrics in csv    
#   1 Row Row
#   2 Col Col
#   3 Center X Center X
#   4 Center Y Center Y
#   5 Total return count above htmin Total return coun
#   6 Elev minimum Int minimum
#   7 Elev maximum Int maximum
#   8 Elev mean Int mean
#   9 Elev mode Int mode
#   10 Elev stddev Int stddev
#   11 Elev variance Int variance
#   12 Elev CV Int CV
#   13 Elev IQ Int IQ
#   14 Elev skewness Int skewness
#   15 Elev kurtosis Int kurtosis
#   16 Elev AAD Int AAD
#   17 Elev L1 Int L1
#   18 Elev L2 Int L2
#   19 Elev L3 Int L3
#   20 Elev L4 Int L4
#   21 Elev L CV Int L CV
#   22 Elev L skewness Int L skewness
#   23 Elev L kurtosis Int L kurtosis
#   24 Elev P01 Int P01
#   25 Elev P05 Int P05
#   26 Elev P10 Int P10
#   27 Elev P20 Int P20
#   28 Elev P25 Int P25
#   29 Elev P30 Int P30
#   30 Elev P40 Int P40
#   31 Elev P50 Int P50
#   32 Elev P60 Int P60
#   33 Elev P70 Int P70
#   34 Elev P75 Int P75
#   35 Elev P80 Int P80
#   36 Elev P90 Int P90
#   37 Elev P95 Int P95
#   38 Elev P99 Int P99
#   39 Return 1 count above htmin
#   40 Return 2 count above htmin
#   41 Return 3 count above htmin
#   42 Return 4 count above htmin
#   43 Return 5 count above htmin
#   44 Return 6 count above htmin
#   45 Return 7 count above htmin
#   46 Return 8 count above htmin
#   47 Return 9 count above htmin
#   48 Other return count above htmin
#   49 Percentage first returns above heightbreak
#   50 Percentage all returns above heightbreak
#   51 (All returns above heightbreak) / (Total first returns) * 100
#   52 First returns above heightbreak
#   53 All returns above heightbreak
#   54 Percentage first returns above mean
#   55 Percentage first returns above mode
#   56 Percentage all returns above mean
#   57 Percentage all returns above mode
#   58 (All returns above mean) / (Total first returns) * 100
#   59 (All returns above mode) / (Total first returns) * 100
#   60 First returns above mean
#   61 First returns above mode
#   62 All returns above mean
#   63 All returns above mode
#   64 Total first returns
#   65 Total all returns
#   66 Elev MAD median
#   67 Elev MAD mode
#   68 Canopy relief ratio ((mean - min) / (max – min))
#   69 Elev quadratic mean
#   70 Elev cubic mean
#   71 KDE elev modes
#   72 KDE elev min mode
#   73 KDE elev max mode
#   74 KDE elev mode range

		METRICS = c(8, 29, 50)
		for (col in METRICS){
			GRD = paste(WORK.PATH, GRID.PATH, tools::file_path_sans_ext(i), "grid_all_returns_elevation_stats.csv", sep="")
			GOUT = paste(WORK.PATH, GRID.PATH, tools::file_path_sans_ext(i), col, "grid.asc", sep="")
			print(paste("c:\\fusion\\csv2grid", GRD, col, GOUT))
			shell(paste("c:\\fusion\\csv2grid", GRD, col, GOUT))
		}
	}
}

#CLIP CHM ---------- START 14:45  END 14:46
require(raster)
if(THIN){
	for (c in seq(1, length(xBounds)-1)){
	  for (l in seq(1, length(yBounds)-1)){
		print(c(l, c))
		boundary = as(extent(xBounds[c], xBounds[c+1], yBounds[l+1], yBounds[l]), 'SpatialPolygons')
		if(file.exists(paste(WORK.PATH, CHM.PATH, "tile00",l,"x00",c,"CleanThinchm.asc", sep=""))){
		  chmTemp = tryCatch({
			raster(paste(WORK.PATH, CHM.PATH, "tile00",l,"x00",c,"CleanThinchm.asc", sep=""))
		  }, warning = function(w) {
			hasCHM = FALSE
		  }, error = function(e) {
			hasCHM = FALSE
		  }, finally = {
			hasCHM = TRUE
		  })
		  
		  if(is.null(intersect(extent(chmTemp), boundary))){
			
		  }else{
			chmTemp = crop(chmTemp, boundary)
			writeRaster(chmTemp, paste(WORK.PATH, CHM.PATH, "tile00",l,"x00",c,"CleanThinChmCrop.tif", sep=""))
		  }
		}
	  }
	}
} else {
	for (c in seq(1, length(xBounds)-1)){
	  for (l in seq(1, length(yBounds)-1)){
		print(c(l, c))
		boundary = as(extent(xBounds[c], xBounds[c+1], yBounds[l+1], yBounds[l]), 'SpatialPolygons')
		if(file.exists(paste(WORK.PATH, CHM.PATH, "tile00",l,"x00",c,"Cleanchm.asc", sep=""))){
		  chmTemp = tryCatch({
			raster(paste(WORK.PATH, CHM.PATH, "tile00",l,"x00",c,"Cleanchm.asc", sep=""))
		  }, warning = function(w) {
			hasCHM = FALSE
		  }, error = function(e) {
			hasCHM = FALSE
		  }, finally = {
			hasCHM = TRUE
		  })
		  
		  if(is.null(intersect(extent(chmTemp), boundary))){
			
		  }else{
			chmTemp = crop(chmTemp, boundary)
			writeRaster(chmTemp, paste(WORK.PATH, CHM.PATH, "tile00",l,"x00",c,"CleanChmCrop.tif", sep=""))
		  }
		}
	  }
	}
}

#CLIP GRIDS ---------- START   END 
require(raster)
if(THIN){
	for (f in c(8, 29, 50)){
		for (c in seq(1, length(xBounds)-1)){
		  for (l in seq(1, length(yBounds)-1)){
			print(c(l, c))
			boundary = as(extent(xBounds[c], xBounds[c+1], yBounds[l+1], yBounds[l]), 'SpatialPolygons')
			if(file.exists(paste(WORK.PATH, GRID.PATH, "tile00",l,"x00",c,"CleanThin",f,"grid.asc", sep=""))){
			  gridTemp = tryCatch({
				raster(paste(WORK.PATH, GRID.PATH, "tile00",l,"x00",c,"CleanThin",f,"grid.asc", sep=""))
			  }, warning = function(w) {
				hasCHM = FALSE
			  }, error = function(e) {
				hasCHM = FALSE
			  }, finally = {
				hasCHM = TRUE
			  })
			  
			  if(is.null(intersect(extent(gridTemp), boundary))){
				
			  }else{
				gridTemp = crop(gridTemp, boundary)
				writeRaster(gridTemp, paste(WORK.PATH, GRID.PATH, "tile00",l,"x00",c,"CleanThin",f,"gridCrop.tif", sep=""))
			  }
			}
		  }
		}
	}
} else {
	for (f in c(8, 29, 50)){
		for (c in seq(1, length(xBounds)-1)){
		  for (l in seq(1, length(yBounds)-1)){
			print(c(l, c))
			boundary = as(extent(xBounds[c], xBounds[c+1], yBounds[l+1], yBounds[l]), 'SpatialPolygons')
			if(file.exists(paste(WORK.PATH, GRID.PATH, "tile00",l,"x00",c,"Clean",f,"grid.asc", sep=""))){
			  gridTemp = tryCatch({
				raster(paste(WORK.PATH, GRID.PATH, "tile00",l,"x00",c,"Clean",f,"grid.asc", sep=""))
			  }, warning = function(w) {
				hasCHM = FALSE
			  }, error = function(e) {
				hasCHM = FALSE
			  }, finally = {
				hasCHM = TRUE
			  })
			  
			  if(is.null(intersect(extent(gridTemp), boundary))){
				
			  }else{
				gridTemp = crop(gridTemp, boundary)
				writeRaster(gridTemp, paste(WORK.PATH, GRID.PATH, "tile00",l,"x00",c,"Clean",f,"gridCrop.tif", sep=""))
			  }
			}
		  }
		}
	}
}
  
#EXTRACT PLOTS ---------- START 14:53  END 14:54
SHP.PLOTS = 'NESBSB00172_Valeria_I_PARCELAS\\'
LAS.PLOTS = 'plots\\'
dir.create("plots")

PLT = paste0(WORK.PATH, SHP.PLOTS, "NESBSB00172_Valeria_I_PARCELAS.shp")
POUT = paste0(WORK.PATH, LAS.PLOTS, "plot.las")

print(paste("c:\\fusion\\PolyClipData", "/shape:2,* /multifile", PLT, POUT, 
	  paste(ORIG.LAS, "*.las", sep="")))
shell(paste("c:\\fusion\\PolyClipData", "/shape:2,* /multifile", PLT, POUT, 
	  paste(ORIG.LAS, "*.las", sep="")))

  
# NORMALIZA PARCELAS ---------- START 16:38 END 16:39

GROUND = paste0("/ground:", paste0(WORK.PATH, DTM.PATH, PROJETO,".dtm"))
LAS.FILES = list.files(paste(WORK.PATH, LAS.PLOTS, sep=""), pattern = "*.las")

for (i in LAS.FILES){
	PLOT_IN = paste0(WORK.PATH, LAS.PLOTS, i)
	PLOT_OUT = paste0(WORK.PATH, LAS.PLOTS, tools::file_path_sans_ext(i), "norm.las")
	print(paste("c:\\fusion\\ClipData", GROUND, "/height", PLOT_IN, PLOT_OUT, 
		extent(readLAS(paste0(WORK.PATH, LAS.PLOTS, i)))[1],
		extent(readLAS(paste0(WORK.PATH, LAS.PLOTS, i)))[3],
		extent(readLAS(paste0(WORK.PATH, LAS.PLOTS, i)))[2],
		extent(readLAS(paste0(WORK.PATH, LAS.PLOTS, i)))[4]))
	shell(paste("c:\\fusion\\ClipData", GROUND, "/height", PLOT_IN, PLOT_OUT, 
		extent(readLAS(paste0(WORK.PATH, LAS.PLOTS, i)))[1],
		extent(readLAS(paste0(WORK.PATH, LAS.PLOTS, i)))[3],
		extent(readLAS(paste0(WORK.PATH, LAS.PLOTS, i)))[2],
		extent(readLAS(paste0(WORK.PATH, LAS.PLOTS, i)))[4]))
}

# PLOTS METRICS ---------- START 14:53  END 14:54

PLOT = paste0(WORK.PATH, LAS.PLOTS, "*norm.las")
MET = paste0(WORK.PATH, LAS.PLOTS, "metrics.csv")
print(paste("c:\\fusion\\CloudMetrics", "/above:3", PLOT, MET))
shell(paste("c:\\fusion\\CloudMetrics", "/above:3", PLOT, MET))