The probability of having no stop codons in a single frame of a single random
sequence.


```R
pNS <- 61/64

l <- 1:100

plot( l, pNS^l )
```

The probability of having at least one frame with no stop codons:

```R
## again calculate pNS in the same way
l <- 1:100
pNS <- 61/64

## the probability of having one or more STOP
## codons in a single frame is:
pfS <- (1 - pNS^l)

## Then the probability of having one or more
## STOP codons in all foward or frames is:
## pfNS^3

## the probability of having it in n frames is
## pfNS^3

## and the probability of not observing this (i.e.
## at least one of the frames does not have a stop codon is

n <- 3
pfNSn <- 1 - (pfS^n)

plot(l, pfNSn)

n <- 6
pfNSn <- 1 - (pfS^n)

plot(l, pfNSn)

```
