## Experimenting with biostrings to see if we can use it to:
##
## 1. load sequences (should be easy)
## 2. translate sequences
## 3. count kmers
##

require(Biostrings)

unmap <- readDNAStringSet("../rand_1m_bl_unmap_50k.fa")
mapped <- readDNAStringSet("../rand_1m_bl_map_50k.fa")

## width / nchar give us the length of the sequences:

par(mfrow=c(1,2))
hist( nchar( unmap ))
hist( nchar( mapped ))

par(mfrow=c(1,1))
hist( nchar( mapped ), col='black')
hist( nchar( unmap ), add=TRUE, col=rgb(0.5, 0.2, 0.2, 0.5) )
## We actually have longer sequences in the unmapped. Not so bad.

## we can access individual sequences
unmap[1]

## to get an R string:
as.character(unmap[1])
## but this is probably more expensive..
## to use, both in terms of CPU and memory, so better
## to avoid conversion if there are suitable methods available.

## we can get the alphabet Frequency:
head(alphabetFrequency( unmap ))
head(letterFrequency( unmap, letters=c('A', 'C', 'G','T')))
## that gives us a separate count for each entry.
## To get a count for the complete set, we can simply add up the
## column scores:

unmap.lf <- colSums( letterFrequency( unmap, letters=c('A', 'C', 'G', 'T') ) )
mapped.lf <- colSums( letterFrequency( mapped, letters=c('A', 'C', 'G', 'T') ) )

barplot( rbind('unmap'=unmap.lf, 'mapped'=mapped.lf), beside=TRUE, legend.text=c("unmapped", "mapped") )

## maybe more informative to do;
barplot( rbind('unmap'=unmap.lf/sum(unmap.lf), 'mapped'=mapped.lf/sum(mapped.lf)),
        beside=TRUE, legend.text=c("unmapped", "mapped") )

## That's actually interesting.. The mapped sequences are more GC rich. How could you check
## if this is statistically significant (that is, does this sampel represent the theoretical
## population).

## what about other characters like N's. To check if there is a difference we can do:
colSums(alphabetFrequency( unmap ))
colSums(alphabetFrequency( mapped ))

## no Ns, or other ambiguity symbols.
## IUPAC ambiguity symbols.

## we could check that as well by doing:
uniqueLetters( unmap )
uniqueLetters( mapped )
## these are nice functions for checking stuff

## we can also do dinucleotide frequencies:
unmap.df <- colSums( dinucleotideFrequency(unmap) )
mapped.df <- colSums( dinucleotideFrequency(mapped) )

plot( unmap.df, mapped.df ) ## nicely correlated. We can also do:

plot( unmap.df/sum(unmap.df), mapped.df/sum(mapped.df), type='n', xlab='unmapped', ylab='mapped' ) 
text( unmap.df/sum(unmap.df), mapped.df/sum(mapped.df), names(unmap.df) )
abline(0, 1, lty=2)
## again we see more of AT, AA, TT in the unmapped

## and
barplot( rbind('unmap'=unmap.df/sum(unmap.df), 'mapped'=mapped.df/sum(mapped.df)),
        beside=TRUE, legend.text=c("unmapped", "mapped"), args.legend=list(x='topleft') )

## and we can do the same for the trinucleotides:
unmap.tf <- colSums( trinucleotideFrequency(unmap) )
mapped.tf <- colSums( trinucleotideFrequency(mapped) )

## this starts to get a bit messy.. 
plot( unmap.tf/sum(unmap.tf), mapped.tf/sum(mapped.tf), type='n', xlab='unmapped', ylab='mapped' ) 
text( unmap.tf/sum(unmap.tf), mapped.tf/sum(mapped.tf), names(unmap.tf) )
abline(0, 1, lty=2)

## Generally nicely correlated. Note that the most common word is TTT. This could be related
## to the presence of polyA tails.

## there is also the function
## oligonucleotideFrequency
unmap.k6 <- colSums(oligonucleotideFrequency(unmap, width=6 ))
mapped.k6 <- colSums(oligonucleotideFrequency(mapped, width=6 ))

## you should look at the object that you create!!!
head(mapped.k6)
head(unmap.k6)

## This is a very important test.. 
all(names(mapped.k6) == names(unmap.k6))

plot(mapped.k6, unmap.k6)

plot(log2(mapped.k6), log2(unmap.k6))

## the rarest words
head(sort( mapped.k6 ))
head(sort( unmap.k6 ))

## the most common words:
head(sort( mapped.k6, decreasing=TRUE ))
head(sort( unmap.k6, decreasing=TRUE ))

## get the same information, but in the opposite order
tail(sort( mapped.k6 ))
tail(sort( unmap.k6 ))

## you can try to look at different word lengths..
unmap.k7 <- colSums(oligonucleotideFrequency(unmap, width=7 ))
mapped.k7 <- colSums(oligonucleotideFrequency(mapped, width=7 ))
gc()

plot(log2(mapped.k7), log2(unmap.k7))
## you will run into trouble if you try to do this with width=8
## consider:

2^4 * 5e4 > 2^31

## what can you do if you want to look at longer reads?


all( names(mapped.k6) == names(unmap.k6))

## What about loading the full set of reads.
unmap.f <- readDNAStringSet("../rand_1m_bl_unmap.fa")
mapped.f <- readDNAStringSet("../rand_1m_bl_map.fa")

length(unmap.f) ## 556,590
length(mapped.f) ## 358046

## and lets have a look at some of these statistics
## unmap.f.df <- colSums(dinucleotideFrequency(unmap.f, as.prob=FALSE))
## that crashes.. note that:

## note:
length(unmap.f) * 4^6 > 2^31
length(mapped.f) * 4^6 > 2^31

## 
unmap.f.k6 <- colSums(oligonucleotideFrequency(unmap.f[1:500000], width=6 ))
## because we made a big matrix, that we don't keep
## it is reasonable to collect garbage here
##
gc()

mapped.f.k6 <- colSums(oligonucleotideFrequency(mapped.f, width=6 ))
gc()

plot(mapped.f.k6, unmap.f.k6)

plot(log2(mapped.f.k6), log2(unmap.f.k6))


### What does translation give us?
<- translate(mapped[1], no.init.codon=TRUE)
tmp1 <- translate(mapped[1], no.init.codon=FALSE)
tmp2 <- translate( mapped[[1]][2:length(mapped[[1]])], no.init.codon=TRUE )
tmp3 <- translate( mapped[[1]][3:length(mapped[[1]])], no.init.codon=TRUE )

### but that can maybe be done more efficiently with subseq

tmp1 <- translate( subseq(mapped, 1), no.init.codon=TRUE )
tmp2 <- translate( subseq(mapped, 2), no.init.codon=TRUE )
tmp3 <- translate( subseq(mapped, 3), no.init.codon=TRUE )

## these have * in them. How can we handle them?
tmp1.1 <- strsplit( tmp1, "*", fixed=TRUE )

length(tmp1.1[[1]])
as.character(tmp1.1[[1]])
max(nchar(tmp1.1[[1]]))

## how about:
head( nchar( strsplit(tmp1, "*", fixed=TRUE) ))

## The following can extract the longest ORF from each translation
## by splitting on "*" (indicating a stop codon), and then calling
## nchar on the resulting objects
plot( sapply( nchar(strsplit(tmp1, "*", fixed=TRUE)), max ) )
