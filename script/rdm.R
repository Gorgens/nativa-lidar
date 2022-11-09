func = function(h, i){ 3.3*max(h)^2 * mean(i)/max(i) }
funcgrid = grid_metrics(las, func(Z, Intensity), 10)
plot(funcgrid)

rdm = function(z){
  zbase = z[z < 5]
  n = length(zbase)
  density = ifelse(n == 0, 2, length(zbase[zbase > 1]) / n )
  return(density)
}
rdmgrid = grid_metrics(las, rdm(Z), 1)
plot(rdmgrid, main='rdm')
