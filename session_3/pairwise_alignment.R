require('jpeg')
require('png')

source("~/R/presentR/presentR.R")
source("~/R/drawinR/drawing_functions.R")
source("~/R/ncbi_R/ncbi_functions.R")
source("~/R/codeR/colorise_R.R")
source("pairwise_alignment/pair_align.R")

blue <- rgb(0,0,0.75)
green <- rgb(0, 0.75, 0)
red <- rgb(0.75, 0, 0)
black <- rgb(0, 0, 0)
purple <- rgb(0.6, 0, 0.6)
grey <- rgb(0.5, 0.5, 0.5, 0.5)
pyel <- rgb(0.5, 0.5, 0, 0.5)
pgrey <- rgb(0.5, 0.5, 0.5, 0.5)
pcyan <- rgb(0, 0.5, 0.5, 0.5)
bul.x <- 10
bul.y <- 80
bul.cex <- c(3,2,1.5)

nuc.col <- c(A=blue, C=green, G=red, T=purple, "-"=black)
nuc.black <- c(A=black, C=black, G=black, T=black, "-"=black)
nuc.bg <- c(A=rgb(0,0,0.8,0.3), C=rgb(0,0.8,0,0.3), G=rgb(0.8,0,0,0.3), T=rgb(0.6,0,0.6,0.3), "-"=rgb(0.5,0.5,0.5,0.4))

sub.y <- 90

grid <- function(v=seq(0,100,10), h=v){
    abline(h=h, lty=3)
    abline(v=v, lty=3)
}

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

## interactive device or not?
int.dev <- function(){ grepl("X11|windows", names(dev.cur())) }

slides <- vector(mode='list', length=0)
source("slides.R")

par(mar=c(5.1, 4.1, 5.1, 4.1))
par(mfrow=c(1,1))
par(oma=c(0,0,0,0))
draw.slides( slides[17:length(slides)] )


## just a check
new.slide()
tmp <- function(x, y, dx, dy, level, max.level){
    print(paste(level, max.level))
    if(level > max.level)
        return()
    segments( x, y, x+dx, c(y-dy, y, y+dy) )
    tmp(x+dx, y+dy, dx, dy/2, level+1, max.level)
    tmp(x+dx, y, dx, dy/2, level+1, max.level)
    tmp(x+dx, y-dy, dx, dy/2, level+1, max.level)
}

tmp(0, 50, 25, 25, 1, 10)

## can I simply make pdfs?
cairo_pdf( "l_05_pairwise_alignment.pdf", width=2*10.24, height=2*7.68, onefile=TRUE)
par(mar=c(5.1, 4.1, 5.1, 4.1))
par(mfrow=c(1,1))
par(oma=c(0,0,0,0))
draw.slides( slides, return.on.last=TRUE )
dev.off()
