## A function that calculates the alignment score for a single cell of a
## Needlman-Wunsch scoring matrix.
##
## The arguments to the function are:
##
## 1. score: the score matrix
## 2. ptr : the pointer matrix
## 3. seq: a list of two character vectors
## 4. sm: a substitution matrix. This should have colnames and rownames so that\
##        scores can be directly looked up.
## 5. gap: The gap penalty. (This function does not calculate affine gap penalties)
##       Note that gap should be negative...
## 6 & 7. i and j, the row and column of the score to be calculated
##
## The function will return a vector of two values: the score and the ptr where
## ptr values indicate:
## 0. No pointer to previous cell (should not exist in a finished table)
## 1. Left pointer (gap in sequence 2)
## 2. Up pointer (gap in sequence 1)
## 3. Up and left (indicating an alignment of two residues
## the dimensions of the tables should be:
## nrow = length(seq[1]) + 1
## ncol = length(seq[2]) + 2
## residues in either sequence that are not given in the subsitution matrix will not 

nm.cell <- function(score, ptr, seq, sm, gap, i, j){
    ## special rules for first column and row:
    if(i == 1 && j == 1)
        return(c(0, 0))
    if(i == 1)
        return(c(score[i,j-1] + gap, 1))
    if(j == 1)
        return(c(score[i-1,j] + gap, 2))
    ## calculate the score alternatives:
    alt.sc <- c(score[i,j-1] + gap, ## a gap in sequence 1
                score[i-1,j] + gap, ## a gap in sequence 2
                sm[ seq[[1]][i-1], seq[[2]][j-1] ] + score[i-1,j-1])
    ## We simply want to return the maximum score and the identity of the
    ## calculation that calculated it:
    k <- which.max(alt.sc)
    c( alt.sc[k], k ) ## this will return the two values
}

## make a simple substitution matrix for dna sequences:
## mismatches will be set to mm and matches to 4
dna.sm <- function(m=4, mm=-4){
    sm <- matrix(mm, nrow=4, ncol=4) ## makes a matrix filled with -4s
    colnames(sm) <- c('A', 'C', 'T', 'G')
    ## set the diagonal to m
    rownames(sm) <- colnames(sm)
    for(i in 1:nrow(sm))
        sm[i,i] <- m
    sm
}
    
## a function that takes two sequences as a single character vector
## a substitution matrix and a gap penalty
## The function will:
##
## 1. Splits the vector to single nucleotide 
## 2. Set up appropriate score and pointer tables
## 3. Loop through each cell of the table and call nm.cell

nm.align <- function(seq, sm, gap){
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
            nm <- nm.cell(scores, ptr, seq.l, sm, gap, i, j)
            scores[i,j] <- nm[1]
            ptr[i,j] <- nm[2]
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
nm.extract <- function(ptr, seq){
    ## extracging t
    al.s <- c("", "")
    i <- nrow(ptr)
    j <- ncol(ptr)
    while(i > 1 || j > 1){
        if(ptr[i,j] == 3){
            al.s[1] <- paste( seq[[1]][i-1], al.s[1], sep="")            
            al.s[2] <- paste( seq[[2]][j-1], al.s[2], sep="")
            i <- i - 1
            j <- j - 1
            next
        }
        if(ptr[i,j] == 2){
            al.s[1] <- paste( seq[[1]][i-1], al.s[1], sep="")            
            al.s[2] <- paste( "-", al.s[2], sep="")
            i <- i - 1
            next
        }
        al.s[1] <- paste( "-", al.s[1], sep="")
        al.s[2] <- paste( seq[[2]][j-1], al.s[2], sep="")
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
