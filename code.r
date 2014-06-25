library(xtable)

# annotations
annos = read.delim('annos_belrus.tab', sep=';', header=F)

ds = read.delim('possession.tab', header=T, sep='\t')
ds$ts = strptime(ds$ts, format='%H:%M')

starttime = strptime('18:00', format='%H:%M')
stoptime = strptime('19:55', format='%H:%M')

ds = subset(ds, ts > starttime & 
                ts < stoptime)
                
ds = ds[order(ds$ts), ]

pwr = 2

png('ballpossession.png', width=3000, height=1000, res=200)
plot(ds$ts, ds$bel, type='n', ylim=c(-max(ds$bel*ds$bel, ds$rs*ds$res)-50^pwr, max(ds$bel*ds$bel, ds$rs*ds$res)+50^pwr), xlab='', 
  ylab='Ball possession (15 minute average, polled every 5 minutes from fifa.com',
  cex.axis=0.7, cex.lab=0.6, axes=F)
axis.POSIXct(1, x=ds$ts, 
             at=seq(from=starttime,to=stoptime,by=600), 
             cex.axis=0.7)
hlines = c(0,30,50,65)
pwr = 2
axis(2, at=c( -rev(hlines^pwr), hlines^pwr), labels=c(rev(hlines), hlines), las=1, cex.axis=0.7)

abline(h=c(-(hlines^pwr), hlines^pwr), lty=3, col='darkgrey')
polygon( x=c(ds$ts, rev(ds$ts)),
         y=c(smooth.spline(ds$bel*ds$bel)$y, rep(0, length(ds$bel))),
         col=rgb(1,0,0, 0.5), border=NA
       )
polygon( x=c(ds$ts, rev(ds$ts)),
         y=c(0-smooth.spline(ds$res*ds$res)$y, rep(0, length(ds$res))),
         col=rgb(0,1,1, 0.5), border=NA
       )
legend('topright', y=95, fill=c(rgb(1,0,0,0.5), rgb(0,1,1,0.5)), 
  legend=c('Belgium', 'Russia'), bg='white') 

# create annotations
for (i in 1:nrow(annos)){
  t = starttime + (annos[i,1] * 60) + (annos[i,2] * 60)
  abline(v=t, lty=3, col='darkgrey')
  text(t, 0, annos[i,3], srt=90, pos=3, cex=0.7)
}

dev.off()

