## define the UP DOWN and so on
UP <- 1
LEFT <- 2
DIAG <- 3

## no subsitution matrices used
NMscore <- function(scores, pointers, seq, i, j, match, mismatch, gap.i, gap.e){
    ## special if i or j are 1
    if(i == 1 && j == 1){
        return(c(0, 0))
    }
    if(i == 1){
        sc <- ifelse( j == 2, gap.i, scores[i,j-1] + gap.e )
        return(c(LEFT, sc))
    }
    if(j == 1){
        sc <- ifelse(i == 2, gap.i, scores[i-1,j] + gap.e)
        return(c(UP, sc))
    }
    ## make a vector of scores in order to allow us to use
    ## which.max()
    ## construct a vector of three elements that holds numeric values
    alt.scores <- vector(mode='numeric', length=3)
    M <- ifelse( seq[[1]][i-1] == seq[[2]][j-1], match, mismatch )
    gap.u <- ifelse( pointers[i-1,j] == 1, gap.e, gap.i )
    gap.l <- ifelse( pointers[i,j-1] == 1, gap.e, gap.i )
    alt.scores[1] <- scores[i-1, j] + gap.u
    alt.scores[2] <- scores[i, j-1] + gap.l
    alt.scores[3] <- scores[i-1, j-1] + M
    ## which.max is a convenient function which does what you might expect
    max.i <- which.max(alt.scores)
    ## in R functions return the evalution of the last statement
    ## Hence the following statement will return a vector of two values:
    ## 1. The index associated with the maximal score.
    ## 2. The maximum score itself.
    c(max.i, alt.scores[max.i])
}

    
## a function that takes two sequences as a single character vector
## a substitution matrix and a gap penalty
## The function will:
##
## 1. Splits the vector to single nucleotide 
## 2. Set up appropriate score and pointer tables
## 3. Loop through each cell of the table and call nm.cell

nm.align <- function(seq, match, mismatch, gap.i, gap.e){
    ## seq should contain two sequences which we want to split
    ## and assign to a list.
    ## note that strsplit is vectorised and returns a list of split
    ## strings:
    seq.l <- strsplit( seq, '')
    ## scores and ptrs are just numeric values, so to begin with
    ## they will look exactly the same
    ## the first argument is the data; all values of the table will
    ## default to this:
    scores <- matrix(0,
                     nrow=length(seq.l[[1]]) + 1,
                     ncol=length(seq.l[[2]]) + 1)
    ptr <- scores
    ## then go through and assign
    for(i in 1:nrow(scores)){
        for(j in 1:ncol(scores)){
            nm <- NMscore(scores, ptr, seq.l, i, j, match, mismatch, gap.i, gap.e)
            scores[i,j] <- nm[2]
            ptr[i,j] <- nm[1]
        }
    }
    ## the result of the last statement is returned to the caller:
    list(sc=scores, pt=ptr, seq=seq.l)
}

## The most difficult part of this is to extract the alignment
## To do that we have to go backwards through the table and
## concatenate strings. R is not very good at this..
## 
## As before, sequence 1 is in the rows and sequence two is in the columns
nm.extract <- function(ptr, seq, i=nrow(ptr), j=ncol(ptr), x=NULL, y=NULL, ...){
    ## extracging t
    al.s <- c("", "")
    ## if(!is.null(x))
    ##     dx <- diff(x)[1] / 6
    ## if(!is.null(y))
    ##     dy <- diff(y)[1] / 6
    while(i > 1 || j > 1){
        if(ptr[i,j] == DIAG){
            al.s[1] <- paste( seq[[1]][i-1], al.s[1], sep="")            
            al.s[2] <- paste( seq[[2]][j-1], al.s[2], sep="")
            if(!is.null(x) && !is.null(y))
                arrows(x[j]-dx, y[i]-dy, x[j-1]+dx, y[i-1]+dy, ...)
            i <- i - 1
            j <- j - 1
            next
        }
        if(ptr[i,j] == UP){
            al.s[1] <- paste( seq[[1]][i-1], al.s[1], sep="")            
            al.s[2] <- paste( "-", al.s[2], sep="")
            if(!is.null(x) && !is.null(y))
                arrows(x[j], y[i]-dy, x[j], y[i-1]+dy, ...)
            i <- i - 1
            next
        }
        al.s[1] <- paste( "-", al.s[1], sep="")
        al.s[2] <- paste( seq[[2]][j-1], al.s[2], sep="")
        if(!is.null(x) && !is.null(y))
            arrows(x[j]-dx, y[i], x[j-1]+dx, y[i], ...)
        j <- j -1
    }
    al.s
}

## print the alignment in a reasonable manner
print.align <- function(al.s, w=50){
    seq <- strsplit(al.s, '')
    for(beg in seq(1, length(seq[[1]]), w)){
        end <- min(c( beg+w, length(seq[[1]])))
        ss1 <- seq[[1]][ beg:end ]
        ss2 <- seq[[2]][ beg:end ]
        id.str <- ifelse(ss1 == ss2, "|", " ")
        cat("\t", ss1, "\n", "\t", id.str, "\n", "\t", ss2, "\n")
    }
}

## xo = xorigin
## cw = character width
draw.aligns <- function(al, xo, y1, y2=y1-h1*2, h1=1.2 * strheight("A", cex=cex), cw=1.2 * strwidth("A", cex=cex),
                        col, sp.a=NULL, sp.b=NULL, w.radius=4, w.sd=w.radius/2, sim.h=h1*0.75, sim.sep=h1*0.125,
                        sim.pos=c(1,1), border=bg.col, bg.col=col, draw.char=FALSE, draw.rect=!draw.char, cex=1, ...){
    krn <- dnorm( -w.radius:w.radius, sd=w.sd )
    a.seq <- al[[1]] ## strsplit( al$seq[1], '' )[[1]]
    b.seq <- al[[2]] ## strsplit( al$seq[2], '' )[[1]]
    sim <- sapply( 1:length(a.seq), function(i){
        b <- ifelse( i > w.radius, i - w.radius, 1 )
        e <- ifelse( i + w.radius <= length(a.seq), i + w.radius, length(a.seq) )
        k.b <- 1 + w.radius - (i-b)
        k.e <- 1 + w.radius + (e-i)
        sum( as.numeric(a.seq[b:e] == b.seq[b:e]) * krn[k.b:k.e] ) / sum(krn[k.b:k.e])
    })
    ## then draw our rectangles using the colours specified
    x2 <- xo + cw * 1:length(a.seq)
    x1 <- x2 - cw
    if(draw.rect){
        rect(x1, y1, x2, y1+h1, col=bg.col[ a.seq ], border=border[a.seq])
        rect(x1, y2, x2, y2+h1, col=bg.col[ b.seq ], border=border[b.seq])
    }
    if(draw.char){
        text((x1 + x2)/2, y1+h1/2, a.seq, col=col[a.seq], cex=cex, ...)
        text((x1 + x2)/2, y2+h1/2, b.seq, col=col[b.seq], cex=cex, ...)
    }
    ## then we plot the similarity beneath y1, and at 
    ## sim always has a maximum of 1.
    sim.y.base <- ifelse( sim.pos[1] == 1, y1, y2 )
    sim.y <- sim.y.base + ifelse( sim.pos[2] == 1,  -(sim.h + sim.sep), (h1 + sim.sep) )
    lines( (x1+x2)/2, sim.y + sim * sim.h )
##    segments( 0.5, sim.y, length(a.seq)-0.5, sim.y )
    segments( (x1+x2)/2, sim.y, (x1+x2)/2, sim.y + ifelse( a.seq == b.seq, sim * sim.h, 0 ) )
    segments( min((x1+x2)/2), sim.y, max((x1+x2)/2))
    if(!is.null(sp.a) || !is.null(sp.b))
        text( 0, y2, paste(sp.a, "vs", sp.b), adj=c(0,1.2) )
    invisible(list(x1=x1, x2=x2, y1=y1, y2=y2, h1=h1, left=min(x1), right=max(x2),
                   bottom=min(c(y1,y2)), top=max(h1 + c(y1,y2))))
}
