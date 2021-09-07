
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
    slide.title("No clear answer:")
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
