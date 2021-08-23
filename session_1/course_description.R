require('jpeg')
require('png')

source("~/R/presentR/presentR.R")
source("~/R/drawinR/drawing_functions.R")
source("~/R/ncbi_R/ncbi_functions.R")
source("~/R/codeR/colorise_R.R")

blue <- rgb(0,0,0.75)
green <- rgb(0, 0.75, 0)
red <- rgb(0.75, 0, 0)
bul.x <- 10
bul.y <- 80
bul.cex <- c(3,2,1.5)

sub.y <- 90

slide.title <- function(txt, cex=4, at=0, adj=0, col=blue, ...){
    ## adjust cex if too wide
    uh <- with(par(), diff(usr)[3])
    uw <- with(par(), diff(usr)[1])
    tw <- strwidth(txt, cex=cex / par('cex'))
    if( tw > uw ){
        cex <- cex * uw / tw
    }
    mtext(txt, cex=cex, at=at, col=col, adj=adj, ...)
}

## prepare some publication trends data:
py.range <- 1990:2020
ncbi.url <- urlInfo()
py.counts <- cbind('year'=py.range, 'nucleotide'=NA)
for(i in 1:length(py.range)){
    tmp <- search.ncbi.py(ncbi.url, py.range[i], db='nucleotide', "")
    py.counts[i,2] <- extract.count( tmp[[1]] )
}

## lets also look at the genome counts
py.counts <- cbind(py.counts, 'genome'=NA)
for(i in 1:length(py.range)){
    tmp <- search.ncbi.py(ncbi.url, py.range[i], db='genome', "")
    py.counts[i,3] <- extract.count( tmp[[1]] )
}

py.counts <- cbind(py.counts, 'sra'=NA)
for(i in 1:length(py.range)){
    tmp <- search.ncbi.py(ncbi.url, py.range[i], db='sra', "")
    py.counts[i,4] <- extract.count( tmp[[1]] )
}

py.counts <- cbind(py.counts, 'assembly'=NA)
for(i in 1:length(py.range)){
    tmp <- search.ncbi.py(ncbi.url, py.range[i], db='assembly', "")
    py.counts[i,5] <- extract.count( tmp[[1]] )
}


slides <- vector(mode='list', length=0)
int.dev <- function(){ grepl("X11|windows", names(dev.cur())) }

source("slides.R")

par(mar=c(5.1, 4.1, 5.1, 4.1))
par(mfrow=c(1,1))
par(oma=c(0,0,0,0))
draw.slides( slides )

## can I simply make pdfs?
cairo_pdf( "l_01_course_introduction.pdf", width=2*10.24, height=2*7.68, onefile=TRUE)
par(mar=c(5.1, 4.1, 5.1, 4.1))
par(mfrow=c(1,1))
par(oma=c(0,0,0,0))
draw.slides( slides, return.on.last=TRUE )
dev.off()

