WORK.PATH = "E:\\GIS\\ipe\\FUSION\\2015\\"
ORIG.LAS = "E:\\GIS\\ipe\\FUSION\\2015\\original\\"
#ORIG.LAS = "E:\\GIS\\ipe\\2015\\"

# PARAMETROS OBRIGATORIOS -----------

RES.CHM = 1

# PARAMETROS OPCIONAIS -----------
THIN = TRUE
  DEN = 5
  WT = 50

GRID = TRUE
  RES.GRID = 40 
  HEIGHT = 7

TREE = FALSE
  LMF = 30

CHM.PATH = "chm\\"
THIN.PATH = "thin\\"
GRID.PATH = "grid\\"
TREE.PATH = "tree\\"

# TILING -------------------------
TILES.PATH = "tiles\\"
BUFFER =  50    #300    
MINX =   347500  #241045 
MINY =   7497800 #78970  
MAXX =   359000  #241965 
MAXY =   7514000 #79795 
XSTEP = (MAXX - MINX)/4      #5    
YSTEP = (MAXY - MINY)/4
xBounds = seq(MINX, MAXX, by = XSTEP)
yBounds = rev(seq(MINY, MAXY, by = YSTEP))
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

# CLEAN OUTLIER ------------------  
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

# DIGITAL TERRAIN MODEL -------------
GND.PATH = "gnd\\"
DTM.PATH = "dtm\\"
RES.DTM = 1
LAS.FILES = list.files(paste(WORK.PATH, CLEAN.PATH, sep=""), pattern = "*.las")
dir.create("gnd")
dir.create("dtm")
for (i in LAS.FILES){
  LAS = paste(WORK.PATH, CLEAN.PATH, i, sep="")
  GND = paste(WORK.PATH, GND.PATH, tools::file_path_sans_ext(i), "gnd.las", sep="")
  print(paste("c:\\fusion\\GroundFilter", GND, 8, LAS))
  shell(paste("c:\\fusion\\GroundFilter", GND, 8, LAS))
  DTM = paste(WORK.PATH, DTM.PATH, tools::file_path_sans_ext(i), "dtm.dtm", sep="")
  DTM2 = paste(WORK.PATH, DTM.PATH, tools::file_path_sans_ext(i), "dtm.asc", sep="")
  print(paste("c:\\fusion\\GridSurfaceCreate", DTM, RES.DTM,"m m 1 0 0 0", GND))
  shell(paste("c:\\fusion\\GridSurfaceCreate", DTM, RES.DTM,"m m 1 0 0 0", GND))
  print(paste("c:\\fusion\\dtm2ascii",DTM, DTM2))
  shell(paste("c:\\fusion\\dtm2ascii", DTM, DTM2))
}

# CLIP DTM ----------
require(raster)
xBounds = seq(MINX, MAXX, by = XSTEP)
yBounds = rev(seq(MINY, MAXY, by = YSTEP))

for (xCol in seq(1, length(xBounds)-1)){
  for (yLin in seq(1, length(yBounds)-1)){
    print(c(l, c))
    boundary = as(extent(xBounds[c], xBounds[c+1], yBounds[l+1], yBounds[l]), 'SpatialPolygons')
    if(file.exists(paste(WORK.PATH, DTM.PATH, "tile00",c,"x00",l,"Cleandtm.asc", sep=""))){
      chmTemp = tryCatch({
        raster(paste(WORK.PATH, DTM.PATH, "tile00",c,"x00",l,"Cleandtm.asc", sep=""))
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

  # THINNING DATA ---------------
  dir.create("thin")
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

  # CANOPY HEIGHT MODEL --------------
dir.create("chm")
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
  
  # GRID METRICS ------------------
  dir.create("grid")
  if (GRID){
    GRD = paste(WORK.PATH, GRID.PATH, tools::file_path_sans_ext(i), "grid.csv", sep="")
      
    print(paste("c:\\fusion\\gridmetrics", 
                "/nointensity",
                DTM, HEIGHT, RES.GRID, GRD, LAS))
    shell(paste("c:\\fusion\\gridmetrics", 
                "/nointensity",
                DTM, HEIGHT, RES.GRID, GRD, LAS))
  }

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
  
  METRICS = c(38, 9)
  for (col in METRICS){
    GRD = paste(WORK.PATH, GRID.PATH, tools::file_path_sans_ext(i), "grid_all_returns_elevation_stats.csv", sep="")
    GOUT = paste(WORK.PATH, GRID.PATH, tools::file_path_sans_ext(i), col, "grid.asc", sep="")
    print(paste("c:\\fusion\\csv2grid", GRD, col, GOUT))
    shell(paste("c:\\fusion\\csv2grid", GRD, col, GOUT))
  }  
    
  # TREE LOCATION ----------------------
  if (TREE){
    dir.create("tree")

    TR3 = paste(WORK.PATH, TREE.PATH, tools::file_path_sans_ext(i), "tree.csv", sep="")
    
    print(paste(
      "c:\\fusion\\canopymaxima", paste("/ground:", DTM, sep = ""),
      "/threshold:5", paste("/wse:",LMF,",0,0,0", sep=""), "/shape", 
      CHM, TR3))
    shell(paste(
      "c:\\fusion\\canopymaxima", paste("/ground:", DTM, sep = ""),
      "/threshold:5", paste("/wse:",LMF,",0,0,0", sep=""), "/shape", 
      CHM, TR3))
  }
}


# POST PROCESSING ----------
#CLIP CHM ----------
require(raster)
xBounds = seq(MINX, MAXX, by = STP)
yBounds = rev(seq(MINY, MAXY, by = STP))
for (c in seq(1, length(xBounds)-1)){
  for (l in seq(1, length(yBounds)-1)){
    print(c(l, c))
    boundary = as(extent(xBounds[c], xBounds[c+1], yBounds[l+1], yBounds[l]), 'SpatialPolygons')
    plot(boundary)
    if(file.exists(paste(WORK.PATH, CHM.PATH, "tile00",c,"x00",l,"CleanThinchm.asc", sep=""))){
      chmTemp = tryCatch({
        raster(paste(WORK.PATH, CHM.PATH, "tile00",c,"x00",l,"CleanThinchm.asc", sep=""))
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
        plot(boundary)
        plot(chmTemp, add=TRUE)
        plot(boundary, add=TRUE)
      }
    }
  }
}

  
