rem C:\FUSION\GroundFilter C:\FUSION\NATIVA\ducke_grd.laz 8 C:\FUSION\NATIVA\las\ducke.laz
rem pause rem Useful for debuging within DOS environment
rem C:\FUSION\GridSurfaceCreate C:\FUSION\NATIVA\ducke_surface.dtm 1 M M 1 0 0 0 C:\FUSION\NATIVA\ducke_grd.laz
rem pause
rem C:\FUSION\DTM2ASCII C:\FUSION\NATIVA\ducke_surface.dtm C:\FUSION\NATIVA\ducke_surface.asc
rem pause
rem C:\FUSION\CanopyModel /ground:C:\FUSION\NATIVA\ducke_surface.dtm C:\FUSION\NATIVA\ducke_chm.dtm 1 M M 1 0 0 0 C:\FUSION\NATIVA\las\ducke.laz
rem pause
C:\FUSION\DTM2ASCII C:\FUSION\NATIVA\ducke_chm.dtm C:\FUSION\NATIVA\ducke_chm.asc
pause