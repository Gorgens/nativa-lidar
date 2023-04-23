
REM Pontos de terreno
REM c:\fusion\GroundFilter C:\FUSION\OUTPUT\DUCKE\ducke_filtered.LAZ 8 "C:\Users\gorge\OneDrive\Documentos\GitHub\nativa-lidar\las\ducke.laz"


REM Criar modelo digital de terreno
REM c:\fusion\GridSurfaceCreate C:\FUSION\OUTPUT\DUCKE\ducke_mdt.dtm 1 m m 1 0 0 0 C:\FUSION\OUTPUT\DUCKE\ducke_filtered.LAZ
REM c:\fusion\dtm2ascii C:\FUSION\OUTPUT\DUCKE\ducke_mdt.dtm C:\FUSION\OUTPUT\DUCKE\ducke_mdt.asc

REM Criar modelo digital altura de dossel
REM c:\fusion\CanopyModel /ground:C:\FUSION\OUTPUT\DUCKE\ducke_mdt.dtm /ascii C:\FUSION\OUTPUT\DUCKE\ducke_chm.dtm 1 m m 1 0 0 0 "C:\Users\gorge\OneDrive\Documentos\GitHub\nativa-lidar\las\ducke.laz"

