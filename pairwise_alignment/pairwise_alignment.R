### Needleman-Wunsch and Smith-Waterman are not as complex as they may seem:
### Here we will implement functions in R that can be used to align pairs
### of sequences.

### The functions will be defined in a separate .R file that we will source
### from this file:

source("pair_align.R")
## This will execute all code in the designated file. Note that this
## file must be present in the current working directory for this to work.

## ALSO NOTE: implementing sequence in alignment in R as done here is
## enormously inefficient. However it is easy and can be used to
## demonstrate the method and the consequences of using different
## alignment parameters.

## set up a nucleotide substitution matrix:

nuc.sm <- dna.sm()
gap <- -6

## first try with two identical sequences:
seq.1 <- rep("ACTAGATTACTAGCGGATAGCCG", 2)

seq.1.nm.1 <- nm.align(seq.1, nuc.sm, gap)

## look at the tables
seq.1.nm.1

image( seq.1.nm.1$sc )
image( seq.1.nm.1$pt )

## use with to avoid typing seq.1.nm.1 twice:
with( seq.1.nm.1, nm.extract(pt, seq) )

## now try with another sequence
seq.2 <- c(seq.1[1], "ACTAGATTGCGGATAGCCGTTT")

seq.2.nm.1 <- nm.align(seq.2, nuc.sm, gap)
image( seq.2.nm.1$sc )
image( seq.2.nm.1$pt )


seq.al <- with( seq.2.nm.1, nm.extract(pt, seq) )

print.align(seq.al)

## and that seems to work.


## Can you write new functions to:

## 1. Implement affine gap penalties.
## 2. Implement Smith Waterman local alignment.


