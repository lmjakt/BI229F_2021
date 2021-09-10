draw.aligns <- function(al, y1, y2, h1, cols, sp.a=NULL, sp.b=NULL, w.radius=4, w.sd=w.radius/2, sim.h=h1*0.75, sim.sep=h1*0.125,
                        sim.pos=c(1,1), border=cols){
    krn <- dnorm( -w.radius:w.radius, sd=w.sd )
    a.seq <- strsplit( al$seq[1], '' )[[1]]
    b.seq <- strsplit( al$seq[2], '' )[[1]]
    sim <- sapply( 1:length(a.seq), function(i){
        b <- ifelse( i > w.radius, i - w.radius, 1 )
        e <- ifelse( i + w.radius <= length(a.seq), i + w.radius, length(a.seq) )
        k.b <- 1 + w.radius - (i-b)
        k.e <- 1 + w.radius + (e-i)
        sum( as.numeric(a.seq[b:e] == b.seq[b:e]) * krn[k.b:k.e] ) / sum(krn[k.b:k.e])
    })
    ## then draw our rectangles using the colours specified
    x2 <- 1:length(a.seq)
    x1 <- x2 - 1
    rect(x1, y1, x2, y1+h1, col=cols[ a.seq ], border=border[a.seq])
    rect(x1, y2, x2, y2+h1, col=cols[ b.seq ], border=border[b.seq])
    ## then we plot the similarity beneath y1, and at 
    ## sim always has a maximum of 1.
    sim.y.base <- ifelse( sim.pos[1] == 1, y1, y2 )
    sim.y <- sim.y.base + ifelse( sim.pos[2] == 1,  -(sim.h + sim.sep), (h1 + sim.sep) )
    lines( (x1+x2)/2, sim.y + sim * sim.h )
    segments( 0.5, sim.y, length(a.seq)-0.5, sim.y )
    segments( (x1+x2)/2, sim.y, (x1+x2)/2, sim.y + ifelse( a.seq == b.seq, sim * sim.h, 0 ) )
    if(!is.null(sp.a) || !is.null(sp.b))
        text( 0, y2, paste(sp.a, "vs", sp.b), adj=c(0,1.2) )
}

## define some sequences that we can use:
ex.seqs <- c("ACGGATACTAGA", "ACGTACGATAGA")

slides[[1]] <- function(){
    new.slide()
    slide.title("Pairwise alignment")
    sc.text( "Optimal alignment by dynamic programming", cex=4 )
}

slides[[2]] <- function(){
    new.slide()
    slide.title("Why align?")
    get.input()
    sc.text("Given the following sequences of letters:", x=10, y=90, adj=c(0,1), cex=3)
    bullet.list(list("martin", "marvin", "martina", "marina"), t.cex=c(2.5,2), 15, bul.y, bullet=FALSE, prefix.sep=". ")
    get.input()
    sc.text("Determine which pair(s) of sequences are:", x=10, y=40, adj=c(0,1), cex=3)
    bullet.list(list("Most similar to each other", "Most dissimilar to each other"), bullet=FALSE, prefix.style='l', prefix.sep=". ",
                t.cex=c(2.5,2), x=15, y=30)
}

slides[[3]] <- function(){
    new.slide()
    slide.title("Alignment (gap insertion) required:")
    x <- c(5, 50)
    y <- c(85, 60, 35)
    family <- "Mono"
    sc.text("          m mm gap", x=x[1], y=y[1], adj=c(0,0), family=family, cex=3)
    sc.text("          m mm gap", x=x[2], y=y[1], adj=c(0,0), family=family, cex=3)
    sc.text("martin \n|||x||    5  1   0\nmarvin", x=x[1], y=y[1], adj=c(0,1), family=family, cex=3)
    sc.text("martin-\n||||||    6  0   1\nmartina", x=x[2], y=y[1], adj=c(0,1), family=family, cex=3)
    sc.text("martin-\n||| ||    5  0   2\nmar-ina", x=x[1], y=y[2], adj=c(0,1), family=family, cex=3)
    sc.text("marvin-\n|||x||    5  1   1\nmartina", x=x[2], y=y[2], adj=c(0,1), family=family, cex=3)
    sc.text("marvin-\n||| ||    5  0   2\nmar-ina", x=x[1], y=y[3], adj=c(0,1), family=family, cex=3)
    sc.text("martina\n||| |||   6  0   1\nmar-ina", x=x[2], y=y[3], adj=c(0,1), family=family, cex=3)
    sc.text("m=no. of matches, mm=no of mismatches, gap=no. of gaps", x=x[1], y=10, adj=c(0,1), cex=3)
}

slides[[4]] <- function(){
    new.slide()
    slide.title("A scoring system")
    eq.cex <- 3
    terms.cex <- 2.5
    eq.y <- 75
    eq.x <- 10
    terms.x <- eq.x + 5
    line.sep <- 2.5
    h <- strheight("A", cex=eq.cex)
    terms.y <- eq.y - (h + cumsum( rep(h*line.sep, 7)))
    text(eq.x, eq.y, expression(S %<-% (N[m] %*% P[m]) + (N[mm] %*% P[mm]) + (N[gap] %*% P[gap])), cex=eq.cex, pos=4)
    text(terms.x, terms.y, c("S",
                          expression(N[m]), expression(P[m]), expression(N[mm]), expression(P[mm]),
                          expression(N[gap]), expression(P[gap])),
         adj=c(0,1), cex=terms.cex)
    text(terms.x + strwidth("MMMM", cex=terms.cex),
         terms.y, c("Alignment score", "Number of matches", "Match penalty", "Number of mismatches",
                               "Mismatch penalty", "Number of gaps", "Gap penalty"), adj=c(0,1), cex=terms.cex)
}

slides[[5]] <- function(){
    new.slide()
    slide.title("Global alignment scores")
    x <- c(5, 50)
    y <- 5 + c(85, 60, 35)
    cex <- 2.75
    eq.x <- 10
    eq.y <- 15
    eq.cex <- 2.5
    family <- "Mono"
    hdims <- sc.text("          m mm gap score", x=x[1], y=y[1], adj=c(0,0), family=family, cex=cex)
    sc.text("          m mm gap score", x=x[2], y=y[1], adj=c(0,0), family=family, cex=cex)
    tdims <- sc.text("martin \n|||x||    5  1   0\nmarvin", x=x[1], y=y[1], adj=c(0,1), family=family, cex=cex)
    sc.text("martin-\n||||||    6  0   1\nmartina", x=x[2], y=y[1], adj=c(0,1), family=family, cex=cex)
    sc.text("martin-\n||| ||    5  0   2\nmar-ina", x=x[1], y=y[2], adj=c(0,1), family=family, cex=cex)
    sc.text("marvin-\n|||x||    5  1   1\nmartina", x=x[2], y=y[2], adj=c(0,1), family=family, cex=cex)
    sc.text("marvin-\n||| ||    5  0   2\nmar-ina", x=x[1], y=y[3], adj=c(0,1), family=family, cex=cex)
    sc.text("martina\n||| |||   6  0   1\nmar-ina", x=x[2], y=y[3], adj=c(0,1), family=family, cex=cex)
##    text(x + 1.2 * tdims$w, y[1] - tdims$h/2, "16", cex=tdims$cex, col='red', adj=c(0,0.5))
    scores.y <- rep(y - tdims$h/2, 2)
    scores.x <- matrix( x + hdims$w, nrow=3, ncol=2, byrow=TRUE )
    text(scores.x, scores.y, c(16, 4, 4, 16, 12, 16), cex=tdims$cex, col='red', adj=c(1,0.5))
##    sc.text("m=no. of matches, mm=no of mismatches, gap=no. of gaps", x=x[1], y=10, adj=c(0,1), cex=cex)
    text(eq.x, eq.y, expression(S %<-% (N[m] %*% P[m]) + (N[mm] %*% P[mm]) + (N[gap] %*% P[gap])), cex=eq.cex, pos=4)
    text(10, eq.y-10, expression(P[m] %<-% 4), cex=eq.cex*0.8, pos=4)
    text(20, eq.y-10, expression(P[mm] %<-% -4), cex=eq.cex*0.8, pos=4)
    text(30, eq.y-10, expression(P[gap] %<-% -8), cex=eq.cex*0.8, pos=4)
}

slides[[6]] <- function(){
    new.slide()
    slide.title("Local alignment scores")
    x <- c(5, 50)
    y <- 5 + c(85, 60, 35)
    cex <- 2.75
    eq.x <- 10
    eq.y <- 15
    eq.cex <- 2.5
    family <- "Mono"
    hdims <- sc.text("          m mm gap score", x=x[1], y=y[1], adj=c(0,0), family=family, cex=cex)
    sc.text("          m mm gap score", x=x[2], y=y[1], adj=c(0,0), family=family, cex=cex)
    tdims <- sc.text("martin \n|||x||     5  1   0\nmarvin", x=x[1], y=y[1], adj=c(0,1), family=family, cex=cex)
    sc.text("martin\n||||||     6  0   0\nmartin", x=x[2], y=y[1], adj=c(0,1), family=family, cex=cex)
    sc.text("\n\n      a", x=x[2], y=y[1], adj=c(0,1), family=family, cex=cex, col='grey')
    sc.text("martin\n||| ||     5  0   1\nmar-in", x=x[1], y=y[2], adj=c(0,1), family=family, cex=cex)
    sc.text("\n\n      a", x=x[1], y=y[2], adj=c(0,1), family=family, cex=cex, col='grey')
    sc.text("marvin\n|||x||     5  1   0\nmartin", x=x[2], y=y[2], adj=c(0,1), family=family, cex=cex)
    sc.text("\n\n      a", x=x[2], y=y[2], adj=c(0,1), family=family, cex=cex, col='grey')
    sc.text("marvin\n||| ||     5  0   1\nmar-in", x=x[1], y=y[3], adj=c(0,1), family=family, cex=cex)
    sc.text("\n\n      a", x=x[1], y=y[3], adj=c(0,1), family=family, cex=cex, col='grey')
    sc.text("martina\n||| |||    6  0   1\nmar-ina", x=x[2], y=y[3], adj=c(0,1), family=family, cex=cex)
##    text(x + 1.2 * tdims$w, y[1] - tdims$h/2, "16", cex=tdims$cex, col='red', adj=c(0,0.5))
    scores.y <- rep(y - tdims$h/2, 2)
    scores.x <- matrix( x + hdims$w, nrow=3, ncol=2, byrow=TRUE )
    text(scores.x, scores.y, c(16, 12, 12, 24, 16, 16), cex=tdims$cex, col='red', adj=c(1,0.5))
##    sc.text("m=no. of matches, mm=no of mismatches, gap=no. of gaps", x=x[1], y=10, adj=c(0,1), cex=cex)
    text(eq.x, eq.y, expression(S %<-% (N[m] %*% P[m]) + (N[mm] %*% P[mm]) + (N[gap] %*% P[gap])), cex=eq.cex, pos=4)
    text(10, eq.y-10, expression(P[m] %<-% 4), cex=eq.cex*0.8, pos=4)
    text(20, eq.y-10, expression(P[mm] %<-% -4), cex=eq.cex*0.8, pos=4)
    text(30, eq.y-10, expression(P[gap] %<-% -8), cex=eq.cex*0.8, pos=4)
    rect(x[2]-1, y[1]-tdims$h-1, x[2]+hdims$w+1, y[1]+hdims$h+1)
}

slides[[7]] <- function(){
    new.slide()
    slide.title("Global and Local alignment")
    bullet.list( list("Global",
                      list("Includes all residues in both sequences", 
                           "Must include gaps if unequal length"),
                      "Local",
                      list("Highest scoring sub-alignment"),
                      "Others",
                      list("Differential treatment of internal and terminal gaps",
                           "May miss residues at ends of sequences")),
                x=bul.x, y=bul.y, t.cex=bul.cex)
}


slides[[8]] <- function(){
    new.slide()
    slide.title("Why align?")
    t.cex <- 2.5
    text(bul.x, 85, "To determine the similarity of two sequences", adj=c(0,0), cex=t.cex)
    y1 <- 81
    y2 <- 79
    segments( c(10, 10), c(y1, y2), c(92, 92), lty=2 )
    segments(c(10, 60, 14, 51), c(y1, y1, y2, y2), c(50, 90, 40, 92), col=c(blue, blue, red, red), lwd=4, lend=2)
    id.x <- c( 14:20,23,27:40, 60:66,70,73,76,80:90 )
    segments( id.x, y1, id.x, y2 )
    get.input()
    rect( c(14, 27, 60, 80), y1, c(20, 40, 66, 90), y2, lwd=2, col=rgb(0.6, 0.6, 0.6, 0.5) )
    text(bul.x, 74, "To identify similar (conserved) regions. Likely to have function.", adj=c(0,0), cex=t.cex)
    get.input()
    bullet.list(list("Functional Analyses",
                     list("Function of a protein (homology / paralogy)", "Important regions"),
                     "Phylogenetic analyses",
                     list("Evolutionary divergence", "Basis for tree building")), x=bul.x, y=60, t.cex=bul.cex)
}

slides[[9]] <- function(){
    new.slide()
    slide.title("Why align?")
    t.cex <- 2.5
    text(bul.x, 90, "Map locations of short sequences to genomes", adj=c(0,0), cex=t.cex)
    y1 <- 81
    segments( 10, y1, 95, y1, col=blue, lwd=4, lend=2)
    sl <- 3
    s.1 <- 18
    short.x <- c(cumsum(c(s.1, sl+1, sl+1, sl+1)), cumsum(c(s.1+2, sl+1, sl+1, sl+1)), cumsum(c(s.1+3, sl+1, sl+1)))
    short.y <- c(rep(y1-2, 4), rep(y1-3, 4), rep(y1-4, 3))
    segments( short.x, short.y, short.x+sl, col=red, lwd=4)
    s.1 <- 60
    short.x <- c(cumsum(c(s.1, sl+1, sl+1, sl+1)), cumsum(c(s.1+2, sl+1, sl+1, sl+1)), cumsum(c(s.1+3, sl+1, sl+1)))
    short.y <- c(rep(y1-2, 4), rep(y1-3, 4), rep(y1-4, 3))
    segments( short.x, short.y, short.x+sl, col=red, lwd=4)
    bullet.list(list("Identify expressed regions",
                     "Estimate expression from RNA-seq", "Identify sequence variants",
                     "Identify amplified regions", "Evaluate primers and probes", "..."),
                x=bul.x, y=60, t.cex=bul.cex)
}    


dot.plot <- function(seq, x, y, window, cell.margin=1.2, do.plot=TRUE, ...){
    ch <- cell.margin * strheight("A", ...)
    cw <- cell.margin * strwidth("A", ...)
    seq.c <- strsplit(seq, "")
    c.y <- y - cumsum(rep(ch, length(seq.c[[1]])))
    c.x <- x + cumsum(rep(cw, length(seq.c[[2]])))
    l.x <- c(x, c.x) + cw/2
    l.y <- c(y, c.y) - ch/2
    if(do.plot){
        text( x, c.y, seq.c[[1]], ... )
        text( c.x, y, seq.c[[2]], ... )
        segments(l.x, min(l.y), l.x, max(l.y))
        segments(min(l.x), l.y, max(l.x), l.y)
    }
    if(window == 0 || !do.plot){
        return(invisible(list(cx=c.x, cy=c.y, lx=l.x, ly=l.y, ch=ch, cw=cw)))
    }
    get.input()
    for(row in 1:(nchar(seq[1])+1-window)){
        for(column in 1:(nchar(seq[2])+1-window)){
            s1 <- substring(seq[1], row, row+window-1)
            s2 <- substring(seq[2], column, column+window-1)
            if(s1 == s2)
                rect(l.x[column:(column+window-1)], l.y[row:(row+window-1)],
                     l.x[(column+1):(column+window)], l.y[(row+1):(row+window)], col=rgb(0.8, 0, 0, 0.5))
        }
    }
    invisible(list(cx=c.x, cy=c.y, lx=l.x, ly=l.y, ch=ch, cw=cw))
}

slides[[10]] <- function(){
    new.slide()
    slide.title("How to determine an alignment")
    sc.text( "Visualising the alignment space", x=bul.x, y=90, cex=3, adj=c(0,0))
    seq <- ex.seqs[1:2] ## c("ACGGATACTAGA", "ACGTACGATAGA")
    y <- 75
    x1 <- 5
    pos1 <- dot.plot(seq, x1, y, window=1, cex=3, family="Mono")
    text(mean(pos1$cx), min(pos1$ly)-pos1$ch, "window=1", adj=c(0.5, 1), cex=2.5)
    get.input()
    pos2 <- dot.plot(seq, max(pos1$lx+x1), y, window=2, cex=3, family="Mono")
    text(mean(pos2$cx), min(pos2$ly)-pos2$ch, "window=2", adj=c(0.5, 1), cex=2.5)
    get.input()
    pos3 <- dot.plot(seq, max(pos2$lx+x1), y, window=3, cex=3, family="Mono")
    text(mean(pos3$cx), min(pos3$ly)-pos3$ch, "window=3", adj=c(0.5, 1), cex=2.5)
}

slides[[11]] <- function(){
    new.slide()
    slide.title("How to determine an alignment")
    sc.text( "How to choose a path through the matrix", x=bul.x, y=90, cex=3, adj=c(0,0))
    seq <- ex.seqs[1:2]
    y <- 75
    x1 <- 5
    pos1 <- dot.plot(seq, x1, y, window=3, cex=3, family="Mono")
    text(mean(pos1$cx), min(pos1$ly)-pos1$ch, "window=3", adj=c(0.5, 1), cex=2.5)
    get.input()
    with(pos1, arrows(cx[1], cy[1], cx[3], cy[3], lwd=2))
    with(pos1, arrows(cx[4], cy[6], cx[6], cy[8], lwd=2))
    with(pos1, arrows(cx[9], cy[9], cx[12], cy[12], lwd=2))
    get.input()
    with(pos1, arrows(cx[3], cy[4], cx[3], cy[5], lwd=2))
    with(pos1, arrows(cx[7], cy[9], cx[8], cy[9], lwd=2))
###
    get.input()
    text(max(pos1$lx)+5, 60,
         "ACG--TACGATAGA\n|||  |||  ||||\nACGGATAC--TAGA",
         cex=3, adj=c(0,0), family="Mono")
    get.input()
    with(pos1, arrows(max(lx)+5, 55, max(lx)+5+cw, 55, lwd=2))
    with(pos1, text( max(lx)+5+cw, 55, "Gap inserted into vertical sequence", cex=2, pos=4))
    with(pos1, arrows(max(lx)+5, 50, max(lx)+5, 50-ch, lwd=2))
    with(pos1, text(max(lx)+5+cw, 50-ch/2, "Gap inserted into horizontal sequence", cex=2, pos=4))
    with(pos1, arrows(max(lx)+5, 43, max(lx)+5+cw, 43-ch, lwd=2))
    with(pos1, text(max(lx)+5+cw, 43-ch/2, "character added from both sequences", cex=2, pos=4))
}

slides[[12]] <- function(){
    new.slide()
    slide.title("How to determine an alignment")
    sc.text( "How to choose a path through the matrix", x=bul.x, y=90, cex=3, adj=c(0,0))
    seq <- ex.seqs[1:2]
    y <- 75
    x1 <- 5
    pos <- dot.plot(seq, x1, y, window=0, cex=3, family="Mono")
    pos.l <- max(pos$lx)
    text( pos.l + 5, 70, "What is the optimal alignment\nto position 1,1 in the matrix?", cex=2, pos=4 )
    with(pos, rect(lx[1], ly[1], lx[2], ly[2], col=rgb(0.5, 0, 0, 0.5)))
    text( pos.l + 5, 60, "-   A   A\nA   A   -", cex=2, family="Mono", pos=4)
    get.input()
    text( pos.l + 5, 50, "What is the optimal alignment\nto position 1,2 in the matrix?", cex=2, pos=4 )
    with(pos, rect(lx[2], ly[1], lx[3], ly[2], col=rgb(0.5, 0, 0, 0.5)))
    text( pos.l + 5, 40, "AC   AC   AC\n-A   A-   --", cex=2, family="Mono", pos=4)
    get.input()
    text( pos.l + 5, 30, "What is the optimal alignment\nto position 2,2 in the matrix?", cex=2, pos=4 )
    with(pos, rect(lx[2], ly[2], lx[3], ly[3], col=rgb(0.5, 0, 0, 0.5)))
    text( pos.l + 5, 22, "depends on scores in (1,1), (1,2), (2,1)", cex=2, pos=4, font=3)
    with(pos, arrows( cx[2], cy[2], c(cx[1], cx[1], cx[2]), c(cy[1], cy[2], cy[1]), lwd=2))
}

slides[[13]] <- function(){
    new.slide()
    slide.title("How to determine an alignment")
    sc.text( "How to choose a path through the matrix", x=bul.x, y=90, cex=3, adj=c(0,0))
    seq <- ex.seqs[1:2]
    y <- 75
    x1 <- 5
    pos <- dot.plot(seq, x1, y, window=0, cex=3, family="Mono")
    pos.l <- max(pos$lx)
    text( pos.l + 5, 70, "What is the optimal alignment\nto position 2,2 in the matrix?", cex=2, pos=4 )
    with(pos, rect(lx[2], ly[2], lx[3], ly[3], col=rgb(0.5, 0, 0, 0.5)))
    with(pos, arrows( cx[2], cy[2], c(cx[1], cx[1], cx[2]), c(cy[1], cy[2], cy[1]), lwd=2))
    text( pos.l + 5, 56, "The optimal alignment to position (2,2)\nmust include one of:",
         cex=2, pos=4, font=3)
    bullet.list(list("optimal alignment to (1,2)", "optimal alignment to (1,1)", "optimal alignment to (2,1)"),
                t.cex=2, bullet=FALSE, x=pos.l+5, 50)
}

slides[[14]] <- function(){
    new.slide()
    slide.title("How to determine an alignment")
    sc.text( "How to choose a path through the matrix", x=bul.x, y=90, cex=3, adj=c(0,0))
    seq <- ex.seqs[1:2]
    y <- 75
    x1 <- 5
    pos <- dot.plot(seq, x1, y, window=0, cex=3, family="Mono")
    pos.l <- max(pos$lx)
    text( pos.l + 5, 70, "What is the score of the optimal\nalignment to position 2,2 in the matrix?", cex=2, pos=4 )
    with(pos, rect(lx[2], ly[2], lx[3], ly[3], col=rgb(0.5, 0, 0, 0.5)))
    with(pos, arrows( cx[2], cy[2], c(cx[1], cx[1], cx[2]), c(cy[1], cy[2], cy[1]), lwd=2))
    text( pos.l + 5, 56, "The optimal score at position (2,2)\nmust be one of:",
         cex=2, pos=4, font=3)
    bullet.list(list("optimal score at (1,2) + ?", "optimal score at (1,1) + ?", "optimal score at (2,1) + ?"),
                t.cex=2, bullet=FALSE, x=pos.l+5, 50)
    get.input()
    sc.text("Right and left moves introduce gaps\nDiagonal moves align residues to each other", cex=2.5, x=x1, y=1, adj=c(0,0))
}

slides[[15]] <- function(){
    new.slide()
    slide.title("How to determine an alignment")
    sc.text( "How to choose a path through the matrix", x=bul.x, y=90, cex=3, adj=c(0,0))
    seq <- ex.seqs[1:2]
    y <- 75
    x1 <- 5
    pos <- dot.plot(seq, x1, y, window=0, cex=3, family="Mono")
    pos.l <- max(pos$lx)
    text( pos.l + 5, 70, "What is the score of the optimal\nalignment to position 2,2 in the matrix?", cex=2, pos=4 )
    with(pos, rect(lx[2], ly[2], lx[3], ly[3], col=rgb(0.5, 0, 0, 0.5)))
    with(pos, arrows( cx[2], cy[2], c(cx[1], cx[1], cx[2]), c(cy[1], cy[2], cy[1]), lwd=2))
    text( pos.l + 5, 56, "The optimal score at position (2,2)\nis the maximum of:",
         cex=2, pos=4, font=3)
    bullet.list(list("optimal score at (1,2) + gap",
                     "optimal score at (1,1) + match/mismatch", "optimal score at (2,1) + gap"),
                t.cex=2, bullet=FALSE, x=pos.l+5, 50)
    get.input()
    sc.text("This is the basis for sequence alignment by dynamic programming", cex=2.5, x=x1, y=1, adj=c(0,0))
}

slides[[16]] <- function(){
    new.slide()
    slide.title("How to determine an alignment")
    sc.text( "How to choose a path through the matrix", x=bul.x, y=90, cex=3, adj=c(0,0))
    seq <- ex.seqs[1:2]
    y <- 75
    x1 <- 5
    pos <- dot.plot(seq, x1, y, window=0, cex=3, family="Mono")
    pos.l <- max(pos$lx)
    text( pos.l + 5, 70, "What is the score of the optimal\nalignment to position i,j in the matrix?", cex=2, pos=4 )
    i <- 8
    j <- 7
    with(pos, rect(lx[j], ly[i], lx[j+1], ly[i+1], col=rgb(0.5, 0, 0, 0.5)))
    with(pos, arrows( cx[j], cy[i], c(cx[j], cx[j-1], cx[j-1]), c(cy[i-1], cy[i-1], cy[i]), lwd=2))
    text( pos.l + 5, 56, "The optimal score at position (i,j)\nis the maximum of:",
         cex=2, pos=4, font=3)
    bullet.list(list("optimal score at (i-1,j) + gap",
                     "optimal score at (i-1,j-1) + match/mismatch", "optimal score at (i,j-1) + gap"),
                t.cex=2, bullet=FALSE, x=pos.l+5, 50)
    get.input()
    sc.text("This is the Needleman-Wunsch equation", cex=2.5, x=x1, y=1, adj=c(0,0))
}

dna.sm <- diag(4, 4, 4)
dna.sm[ dna.sm == 0 ] <- -4
rownames(dna.sm) <- c("A", "C", "T", "G")
colnames(dna.sm) <- rownames(dna.sm)

## pos is a list returned by dot.plot()
draw.arrows <- function(pos, ptr, i, j, length=0.1, ...){
    x1 <- ifelse(bitwAnd(1, ptr[i,j]), pos$cx[j] - pos$cw/4, pos$cx[j])
    y1 <- ifelse(bitwAnd(2, ptr[i,j]), pos$cy[i] + pos$ch/4, pos$cy[i])
    x2 <- ifelse(bitwAnd(1, ptr[i,j]), x1 - pos$cw/2, x1)
    y2 <- ifelse(bitwAnd(2, ptr[i,j]), y1 + pos$ch/2, y1)
    arrows(x1, y1, x2, y2, length=length, ...)
}

trace.ptr <- function(pos, ptr, i, j, col=rgb(0.5, 0.5, 0, 0.5)){
    with(pos, rect(lx[j], ly[i], lx[j+1], ly[j+1], col=col))
    i2 <- ifelse(bitwAnd(1, ptr[i,j]), i-1, i)
    j2 <- ifelse(bitwAnd(2, ptr[i,j]), j-1, j)
    c(i2, j2)
}

nmw.1 <- nm.align(ex.seqs[1:2], dna.sm, -8)

slides[[17]] <- function(){
    new.slide()
    slide.title("The Needleman-Wunsch algorithm")
    seq <- ex.seqs[1:2]
    nm <- nmw.1
    pos <- dot.plot( paste(" ", seq, sep=""), 10, 80, window=0, cex=3, family="Mono")
    ##    pos1 <- dot.plot( paste(" ", seq, sep=""), 10, 80, window=0, cex=2, family="Mono")
    pos.l <- max(pos$lx) + 5
    ch <- strheight("A", cex=2)
    bullet.list(list("Set up a score matrix with an additional row and column",
                     "Set the score at (1,1) to 0",
                     "Fill the first row and column with gap penalties",
                     "Cell by cell:",
                     list("Determine maximum score",
                          "Record score",
                          "Record the cell from which the alignment was extended"),
                     "Trace alignment from bottom right to top left"
                     ),
                bullet=FALSE, t.cex=c(2.5,2), x=pos.l, y=80)
    get.input()
    text(pos$cx, pos$cy[1], nm$sc[1,], cex=1)
    text(pos$cx[1], pos$cy, nm$sc[,1], cex=1)
    draw.arrows( pos, nm$pt, 1, 2:ncol(nm$pt), col=red)
    draw.arrows( pos, nm$pt, 2:nrow(nm$pt), 1, col=red)
    get.input()
    text(pos$cx[-1], pos$cy[2], nm$sc[2,-1], cex=1)
    draw.arrows( pos, nm$pt, 2, 2:ncol(nm$pt), col=red)
    get.input()
    for(i in 3:nrow(nm$pt)){
        text(pos$cx[-1], pos$cy[i], nm$sc[i,-1], cex=1)
        draw.arrows( pos, nm$pt, i, 2:ncol(nm$pt), col=red)
    }
    cell <- c(nrow(nm$pt), ncol(nm$pt))
    while(sum(cell) > 2){
        cat(cell, "\n")
        cell <- trace.ptr( pos, nm$pt, cell[1], cell[2])
    }
    sc.text("End of new presentation. Move to old one.", x=10, y=1, cex=2, adj=c(0,0))
}

slides[[18]] <- function(...){
    new.slide(...)
    slide.title("The Needleman-Wunsch algorithm")
    seq <- ex.seqs[1:2]
    nm <- nmw.1
    pos <- dot.plot( paste(" ", seq, sep=""), 10, 80, window=0, cex=3, family="Mono")
    ##    pos1 <- dot.plot( paste(" ", seq, sep=""), 10, 80, window=0, cex=2, family="Mono")
    pos.r <- max(pos$lx) + 5
    ch <- strheight("A", cex=2)
    invisible(list(nm=nm, pos=pos, pos.r=pos.r, ch=ch))
}

slides[[19]] <- function(){
    obj <- slides[[18]]()
##    obj <- slides[[18]](clear = !int.dev())
    nm <- nmw.1
    al.x <- obj$pos.r + 5
    ch <- strheight("A", cex=3)
    cw <- strwidth("A", cex=3)
    with(obj$pos, {
        rect(lx[2], ly[1], lx[3], ly[2], col=pyel)
        arrows(cx[2], cy[1], cx[1], cy[1], lwd=2)
    })
    get.input()
    al.1 <- nm.extract(nm$pt, nm$seq, 1, 2)
    al1.p <- draw.aligns( al.1, al.x, 80, cex=3, draw.char=TRUE, draw.rect=TRUE, bg.col=nuc.bg, col=nuc.black, family='Mono', font=1 )
    text(al.x - cw*2, (al1.p$bottom + al1.p$top)/2, "1,2", cex=2)
    ##
    get.input()
    with(obj$pos, {
        rect(lx[1], ly[2], lx[2], ly[3], col=pyel)
        arrows(cx[1], cy[2], cx[1], cy[1], lwd=2)
    })
    get.input()
    al.2 <- nm.extract(nm$pt, nm$seq, 2, 1)
    al2.p <- draw.aligns( al.2, al.x, al1.p$bottom - ch*4, cex=3, draw.char=TRUE, draw.rect=TRUE,
                         bg.col=nuc.bg, col=nuc.black, family='Mono', font=1 )
    text(al.x - cw*2, (al2.p$bottom + al2.p$top)/2, "2,1", cex=2)
}

slides[[20]] <- function(){
    obj <- slides[[18]]()
    nm <- nmw.1
    al.x <- obj$pos.r + 5
    ch <- strheight("A", cex=3)
    cw <- strwidth("A", cex=3)
    with(obj$pos, {
        rect(lx[2], ly[1], lx[3], ly[2], col=pgrey)
    })
    al.1 <- nm.extract(nm$pt, nm$seq, 1, 2)
    al1.p <- draw.aligns( al.1, al.x, 80, cex=3, draw.char=TRUE, draw.rect=TRUE, bg.col=nuc.bg, col=nuc.black, family='Mono', font=1 )
    text(al.x - cw*2, (al1.p$bottom + al1.p$top)/2, "1,2", cex=2)
    ##
    with(obj$pos, {
        rect(lx[1], ly[2], lx[2], ly[3], col=pgrey)
    })
    al.2 <- nm.extract(nm$pt, nm$seq, 2, 1)
    al2.p <- draw.aligns( al.2, al.x, al1.p$bottom - ch*4, cex=3, draw.char=TRUE, draw.rect=TRUE,
                         bg.col=nuc.bg, col=nuc.black, family='Mono', font=1 )
    text(al.x - cw*2, (al2.p$bottom + al2.p$top)/2, "2,1", cex=2)
    with(obj$pos, {
        rect(lx[2], ly[2], lx[3], ly[3], col=pyel)
        arrows(cx[2], cy[2], c(cx[1], cx[1], cx[2]), c(cy[2], cy[1], cy[1]), lwd=2, length=0.1)
    })
    yd <- al1.p$top - al2.p$top
    text(al.x - cw*2, (al2.p$bottom + al2.p$top)/2 - yd, "1,1", cex=2)
    ## manually construct as the nm.extract will only give use the best alignment
    al.3 <- strsplit(c("-A", "A-"), "")
    al.4 <- strsplit(c("A-", "-A"), "")
    al.5 <- list("A", "A")
    al.x <- al1.p$right + 5
    get.input()
    al3.p <- draw.aligns( al.3, al.x, 80, cex=3, draw.char=TRUE, draw.rect=TRUE, bg.col=nuc.bg, col=nuc.black, family='Mono', font=1 )
    get.input()
    al4.p <- draw.aligns( al.4, al.x, al1.p$bottom - ch*4, cex=3,
                         draw.char=TRUE, draw.rect=TRUE, bg.col=nuc.bg, col=nuc.black, family='Mono', font=1 )
    get.input()
    al5.p <- draw.aligns( al.5, al.x, al2.p$bottom - ch*4, cex=3,
                         draw.char=TRUE, draw.rect=TRUE, bg.col=nuc.bg, col=nuc.black, family='Mono', font=1 )
}

## this will work only if i and j are larger than 1
extend.alignment <- function(obj, nm, i, j){
    al.x <- obj$pos.r + 5
    ch <- strheight("A", cex=3)
    cw <- strwidth("A", cex=3)
    with(obj$pos, {
        rect(lx[j], ly[i], lx[j+1], ly[i+1], col=pyel)
    })
    get.input()
    with(obj$pos, {
        rect(lx[j-1], ly[i-1], lx[j], ly[i], col=pgrey)
        rect(lx[j], ly[i-1], lx[j+1], ly[i], col=pgrey)
        rect(lx[j-1], ly[i], lx[j], ly[i+1], col=pgrey)
        arrows(cx[j], cy[i], c(cx[j-1], cx[j-1], cx[j]), c(cy[i], cy[i-1], cy[i-1]), length=0.1, lwd=2)
    })
    al.1 <- with(obj$pos, strsplit( nm.extract(nm$pt, nm$seq, i-1, j, cx, cy, length=0.1, col='red'), ""))
    al.2 <- with(obj$pos, strsplit( nm.extract(nm$pt, nm$seq, i, j-1, cx, cy, length=0.1, col='red'), ""))
    al.3 <- with(obj$pos, strsplit( nm.extract(nm$pt, nm$seq, i-1, j-1, cx, cy, length=0.1, col='red'), ""))
    labs <- paste(c(i-1,i,i-1), c(j,j-1,j-1), sep=",")
    al1.p <- draw.aligns( al.1, al.x, 80, cex=3, draw.char=TRUE, draw.rect=TRUE, bg.col=nuc.bg, col=nuc.black, family='Mono', font=1 )
    text(al.x - cw*2, (al1.p$bottom + al1.p$top)/2, labs[1], cex=2)
    al2.p <- draw.aligns( al.2, al.x, al1.p$bottom - ch*4, cex=3, draw.char=TRUE, draw.rect=TRUE,
                         bg.col=nuc.bg, col=nuc.black, family='Mono', font=1 )
    text(al.x - cw*2, (al2.p$bottom + al2.p$top)/2, labs[2], cex=2)
    al3.p <- draw.aligns( al.3, al.x, al2.p$bottom - ch*4, cex=3,
                         draw.char=TRUE, draw.rect=TRUE, bg.col=nuc.bg, col=nuc.black, family='Mono', font=1 )
    text(al.x - cw*2, (al3.p$bottom + al3.p$top)/2, labs[3], cex=2)
    ## to extend the alignment add a gap or appropriate character
    al.1 <- list( c(al.1[[1]], nm$seq[[1]][i-1]), c(al.1[[2]], "-") )
    al.2 <- list( c(al.2[[1]], "-"), c(al.2[[2]], nm$seq[[2]][j-1]) )
    al.3 <- list( c(al.3[[1]], nm$seq[[1]][i-1]), c(al.3[[2]], nm$seq[[2]][j-1]) )
    al.x <- al1.p$right + 5
    get.input()
    al3.p <- draw.aligns( al.1, al.x, 80, cex=3, draw.char=TRUE, draw.rect=TRUE, bg.col=nuc.bg, col=nuc.black, family='Mono', font=1 )
    get.input()
    al4.p <- draw.aligns( al.2, al.x, al1.p$bottom - ch*4, cex=3,
                         draw.char=TRUE, draw.rect=TRUE, bg.col=nuc.bg, col=nuc.black, family='Mono', font=1 )
    get.input()
    al5.p <- draw.aligns( al.3, al.x, al2.p$bottom - ch*4, cex=3,
                         draw.char=TRUE, draw.rect=TRUE, bg.col=nuc.bg, col=nuc.black, family='Mono', font=1 )
}

slides[[21]] <- function(){
    obj <- slides[[18]]()
    nm <- nmw.1
    al.x <- obj$pos.r + 5
    ch <- strheight("A", cex=3)
    cw <- strwidth("A", cex=3)
    with(obj$pos, {
        rect(lx[3], ly[2], lx[4], ly[3], col=pyel)
    })
    get.input()
    with(obj$pos, {
        rect(lx[2], ly[1], lx[3], ly[2], col=pgrey)
        rect(lx[3], ly[1], lx[4], ly[2], col=pgrey)
        rect(lx[2], ly[2], lx[3], ly[3], col=pgrey)
        arrows(cx[3], cy[2], c(cx[2], cx[2], cx[3]), c(cy[2], cy[1], cy[1]), length=0.1, lwd=2)
    })
    al.1 <- strsplit( nm.extract(nm$pt, nm$seq, 1, 3), "")
    al.2 <- strsplit( nm.extract(nm$pt, nm$seq, 2, 2), "")
    al.3 <- strsplit( nm.extract(nm$pt, nm$seq, 1, 2), "")
    al1.p <- draw.aligns( al.1, al.x, 80, cex=3, draw.char=TRUE, draw.rect=TRUE, bg.col=nuc.bg, col=nuc.black, family='Mono', font=1 )
    text(al.x - cw*2, (al1.p$bottom + al1.p$top)/2, "1,3", cex=2)
    al2.p <- draw.aligns( al.2, al.x, al1.p$bottom - ch*4, cex=3, draw.char=TRUE, draw.rect=TRUE,
                         bg.col=nuc.bg, col=nuc.black, family='Mono', font=1 )
    text(al.x - cw*2, (al2.p$bottom + al2.p$top)/2, "2,2", cex=2)
    al3.p <- draw.aligns( al.3, al.x, al2.p$bottom - ch*4, cex=3,
                         draw.char=TRUE, draw.rect=TRUE, bg.col=nuc.bg, col=nuc.black, family='Mono', font=1 )
    text(al.x - cw*2, (al3.p$bottom + al3.p$top)/2, "1,2", cex=2)
    ## to extend the alignment add a gap or appropriate character
    al.1 <- list( c(al.1[[1]], nm$seq[[1]][1]), c(al.1[[2]], "-") )
    al.2 <- list( c(al.2[[1]], "-"), c(al.2[[2]], nm$seq[[2]][2]) )
    al.3 <- list( c(al.3[[1]], nm$seq[[1]][1]), c(al.3[[2]], nm$seq[[2]][2]) )
    al.x <- al1.p$right + 5
    get.input()
    al3.p <- draw.aligns( al.1, al.x, 80, cex=3, draw.char=TRUE, draw.rect=TRUE, bg.col=nuc.bg, col=nuc.black, family='Mono', font=1 )
    get.input()
    al4.p <- draw.aligns( al.2, al.x, al1.p$bottom - ch*4, cex=3,
                         draw.char=TRUE, draw.rect=TRUE, bg.col=nuc.bg, col=nuc.black, family='Mono', font=1 )
    get.input()
    al5.p <- draw.aligns( al.3, al.x, al2.p$bottom - ch*4, cex=3,
                         draw.char=TRUE, draw.rect=TRUE, bg.col=nuc.bg, col=nuc.black, family='Mono', font=1 )
    return()
    with(obj$pos, {
        rect(lx[2], ly[2], lx[3], ly[3], col=pyel)
        arrows(cx[2], cy[2], c(cx[1], cx[1], cx[2]), c(cy[2], cy[1], cy[1]), lwd=2, length=0.1)
    })
    yd <- al1.p$top - al2.p$top
    text(al.x - cw*2, (al2.p$bottom + al2.p$top)/2 - yd, "1,1", cex=2)
    ## manually construct as the nm.extract will only give use the best alignment
    al.3 <- strsplit(c("-A", "A-"), "")
    al.4 <- strsplit(c("A-", "-A"), "")
    al.5 <- list("A", "A")
    al.x <- al1.p$right + 5
    get.input()
    al3.p <- draw.aligns( al.3, al.x, 80, cex=3, draw.char=TRUE, draw.rect=TRUE, bg.col=nuc.bg, col=nuc.black, family='Mono', font=1 )
    get.input()
    al4.p <- draw.aligns( al.4, al.x, al1.p$bottom - ch*4, cex=3,
                         draw.char=TRUE, draw.rect=TRUE, bg.col=nuc.bg, col=nuc.black, family='Mono', font=1 )
    get.input()
    al5.p <- draw.aligns( al.5, al.x, al2.p$bottom - ch*4, cex=3,
                         draw.char=TRUE, draw.rect=TRUE, bg.col=nuc.bg, col=nuc.black, family='Mono', font=1 )
}

slides[[22]] <- function(){
    obj <- slides[[18]]()
    nm <- nmw.1
    extend.alignment(obj, nm, 2, 3)
}

slides[[23]] <- function(){
    obj <- slides[[18]]()
    nm <- nmw.1
    extend.alignment(obj, nm, 3, 3)
}

slides[[24]] <- function(){
    obj <- slides[[18]]()
    nm <- nmw.1
    extend.alignment(obj, nm, 7, 7)
}    

extra.slide <- function(){
    new.slide()
    slide.title("Finding optimal alignments")
    ## only works if length(a) == length(b)
    exhaustive.align <- function(x, y, a, b, dx, dy, al.a, al.b, al.m, cex, family="Mono"){
        if(!length(a) && !length(b))
            return()
        get.input()
        h <- strheight( paste(rep("A", 4), collapse="\n"), cex=cex, family=family )
        w  <- strwidth("A", cex=cex, family=family)
        if(length(a) && length(b)){
            al.a <- paste(al.a, c(a[1], a[1], "-"), sep="")
            al.b <- paste(al.b, c("-", b[1], b[1]), sep="")
            if(a[1] == b[1]){
                al.m <- paste(al.m, c(" ", "|", " "), sep="")
            }else{
                al.m <- paste(al.m, c(" ", "x", " "), sep="")
            }
            text(x, y+h, paste(al.a[1], al.m[1], al.b[1], sep="\n"), cex=cex, family=family, adj=c(0,0.5))
            text(x, y, paste(al.a[2], al.m[2], al.b[2], sep="\n"), cex=cex, family=family, adj=c(0,0.5))
            text(x, y-h, paste(al.a[3], al.m[3], al.b[3], sep="\n"), cex=cex, family=family, adj=c(0,0.5))
            tw <- strwidth(al.a[2], cex=cex, family=family) + w
            if(length(a) > 1 || length(b) > 1){
                arrows(x+tw, y, x+dx-w, y, length=0.1)
##            if(length(a) > 1)
                arrows(x+tw, y+h, x+dx-w, y+dy, length=0.1)
##            if(length(b) > 1)
                arrows(x+tw, y-h, x+dx-w, y-dy, length=0.1)
            }
            exhaustive.align(x+dx, y+dy, a[-1], b, dx, dy/3, al.a[1], al.b[1], al.m[1], cex=cex, family=family)
            exhaustive.align(x+dx, y, a[-1], b[-1], dx, dy/3, al.a[2], al.b[2], al.m[2], cex=cex, family=family)
            exhaustive.align(x+dx, y-dy, a, b[-1], dx, dy/3, al.a[3], al.b[3], al.m[3], cex=cex, family=family)
            return()
        }
        if(length(a)){
            al.a <- paste(al.a, a[1], sep="")
            al.b <- paste(al.b, "-", sep="")
            al.m <- paste(al.m, " ")
            tw <- strwidth(al.a, cex=cex, family=family) + w
            text(x, y, paste(al.a, al.m, al.b, sep="\n"), cex=cex, family=family, adj=c(0,0.5))
            if(length(a) > 1)
                arrows(x+tw, y, x+dx-w, y, length=0.1)
            exhaustive.align(x+dx, y, a[-1], c(), dx, dy/3, al.a, al.b, al.m, cex=cex, family=family)
            return()
        }
        if(length(b)){
            al.a <- paste(al.a, "-", sep="")
            al.b <- paste(al.b, b[1], sep="")
            al.m <- paste(al.m, " ")
            tw <- strwidth(al.a, cex=cex, family=family) + w
            text(x, y, paste(al.a, al.m, al.b, sep="\n"), cex=cex, family=family, adj=c(0,0.5))
            if(length(b) > 1)
                arrows(x+tw, y, x+dx-w, y, length=0.1)
            exhaustive.align(x+dx, y, c(), b[-1], dx, dy/3, al.a, al.b, al.m, cex=cex, family=family)
            return()
        }
    }
    seq <- c("ACT", "ATT")
    seq.sp <- strsplit(seq, "")
    exhaustive.align(0, 50, seq.sp[[1]], seq.sp[[2]], 8, 30, "", "", "", 1)
}

cairo_pdf("test.pdf", width=20, height=256)
slides[[8]]()
dev.off()
