% Looking at omics data

# Getting some data

In this exercise we will use gene expression data obtained from Gene
Expression Omnibus (GEO). To do this we can use the Bioconductor pacakge
GEOQuery. As usual you will need to install this:

```R
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("GEOquery")

## and check that it is working.

require("GEOquery")
```

To download the data we use the `getGeo` function. Here we will use a data set
called 'GDS3850'. This is the same data that I showed examples of in the
lectures. Hopefully you will be able to recreate some of the figures I showed
and others as well.

```R
## directly from the internet:
gds <- getGEO("GDS3850")

## OR from a file on your computer
## gds <- getGEO("GDS3850_full.soft")

```

To work out what `gds` is, we need to look at the documentation for the getGEO
function, do: `?getGEO`, and have a look.

```R
?getGEO
```

Most of the documentation for the `getGEO` function describes *how* to use it;
to see something about what is *returned* scroll down to the `Value:`
section. Here you find merely that the function returns an object of type
`GDS`, `GPL`, `GSM`, or `GSE`. That in its own right is not particularly
informative. However you can probably guess that we got an object of class
`GDS` from the command. Better yet, you can actually check that:

```R
class(gds)
```

So continue to read documentation, `?GDS`. Unfortunately this doesn't tell us
very much at all, and reading the reference manual from the package website
doesn't tell us very much more. This is probably because a great deal of the
functionality of the package comes from other packages. It can be somewhat
time consuming to track down all of this. In this case it is better to follow
the `Using GEOquery` link from the package website 
(<https://www.bioconductor.org/packages/release/bioc/vignettes/GEOquery/inst/doc/GEOquery.html>).

From that we can eventually find the following functions, `Meta`, `Table`,
`Columns` that we can use to get the data into more standard `R` data
structures. It is quite likely that the designers of the package intend for us
not to use these for analyses but to use functions that use the `GDS`, `GPL`
types directly. But it is not good to be bound to any specific framework, and
you should always be able to inspect the raw data without relying on specific
funtions. So let us see what we can get:

```R
gds.data <- Table(gds)
gds.meta <- Meta(gds)
gds.columns <- Columns(gds)

### Do ONE of these at a time, and look at the output.
### If I see anyone simply executing all the lines in one
### go I may consider that person an absolute moron.

class(gds.data)
class(gds.meta)
class(gds.columns)

## meta is a list; presumably it holds some sort of meta information
## maybe check if it has names:
names(gds.meta)

## The names of gds relate to the experimental data:
## the term description seems interesting. Have a look:

head(gds.meta$description)  ## how useful is that?

## what about the columns?
dim(gds.columns)
head(gds.columns)

## seems that the columns give us information for each sample
## and that there are three different factors
## genotype, tissue, agent

## lets have a look at the data
dim(gds.data)

## almost looks like there is one sample per column, but we actually
## have two extra columns (56 instead of 54). Why is that?
head(gds.data)

## ahh, the first two columns give us some information about which
## genes are represented by the different probes.

## from
dim(gds.data)

## we can see that there are 15923 rows in the table. We can ask how many distinct
## genes are present in the table by using the unique function

length( gds.data$IDENTIFIER )  ## 15923
length( unique(gds.data$IDENTIFIER) )  ## 13375

## in other words some genes are represented by more than a single probe. This
## can be good as it allows us to look at how reproducible the measures are.
## we will have a look at that later on.
```

### If you are confused by the above:

The code shown above makes use of the `getGEO` function to download data from
a microarray experiment. The data includes the actual expression measurements
in the `gds.data` object that was returned by the `Table` accessor
function. This is a dataframe containing one row per *probe*[^probe] on the
microarray; each probe is used to measure the expression[^expression] of a
single gene or transcript. Hence a gene can be represented by more than one
probe, but a probe should only respond to a single gene. In addition to the
expression values `gds.data` also has two columns (1 and 2) that give us the
identifier of the probe (1) and a gene symbol (2). Looking at the gene symbols
we can determine that many genes are represented by more than one probe.

[^probe]: A microarray consists of a small flat surface (chip) onto which a large
    numbers of specific nucleotide sequences have been deposited into very
    small and distinct areas. To measure expression of genes we first
    do something to label RNA, cDNA, or cRNA molecules from a given sample
    with fluoresent molecules. These are then incubated on the chip to allow
    sequence specific annealing of complementary sequences (hybridisation) to
    occur. A large quantity of a specific RNA will then result in a
    (relatively) large amount of fluorescence at the location containing
    probes complementary to that sequence.
[^expression]: You will hear a lot about the measurement of *gene
    expression*. In fact we very rarely measure *expression* as such; what we
    actually measure is *RNA quantity* from which we infer past expression of
    the corresponding gene. This is reasonable in static systems, but not in
    dynamic systems where gene expression is likely to change (as during
    differentiation).
	
The data also contains meta data; that is information about the samples and
the experiment. The `gds.data` data structure contains information about the
methods used and the samples, whereas `gds.columns` only contains data about
each individual sample. From here on we will only make use of `gds.data` and
`gds.columns` as obtaining the sample information from `gds.meta` is possible
but troublesome.

# First consider the distributions

As I've emphasised many times; given a large set of numbers the first thing
that you should probably do is to inspect the distribution of the values. To
make our code simpler we will first extract the expression measurements from
`gds.data` into a separate data.frame as we do not want to include text based
data in any numerical analyses.

```R
## extract the expression data into separate data set:
## select all rows and all columns except for 1 and 2
gds.exp <- gds.data[, -2:-1]

## check that you have done what you thought:
dim(gds.exp)
head(gds.exp)
gds.exp[1,]
is.numeric(gds.exp) ## ???

## let us set some rownames:
rownames(gds.exp) <- gds.data[,1]
head(gds.exp)

## We could consider converting gds.exp into a matrix;
## that will make some things a bit simpler (but isn't really necessary).
gds.exp <- as.matrix(gds.exp)
class(gds.exp)
is.numeric(gds.exp) ## that is nice.

## we can then simply do:
hist(gds.exp)

## we can also play around with the paramters of hist()
hist(gds.exp, breaks=100)

## looking at the distribution it looks like we might want to log transform the
## data. Before doing that it is reasonable to check the range of the data, since
## log(0) isn't really defined.
range(gds.exp) ## NA, NA ? why
range(gds.exp, na.rm=TRUE)  ## values range from 0.1 -> 114450.0

## we can ask how many NAs we have:
sum( gds.exp == NA ) ## NA

## it turns out that we cannot use == to check if soemthing is NA
## instead we have to use:

sum( is.na( gds.exp )) ## 2 .. not so bad.

## we can set the NA values to something reasonable. Maybe we can
## take half of the lowest value (0.1). We can set these by simply doing
gds.exp[ is.na( gds.exp ) ] <- min( gds.exp, na.rm=TRUE ) / 2
## That works because we can treat a matrix as a vector as well.
range(gds.exp) ## ok, good.

## then we can do:
hist(log2(gds.exp)) 
## That's nicer; we should probably deal mostly with log transformed data. 
## It doesn't really matter which log we use, but I like log2

## We can assign the return value of the call to hist to a variable so
## that we can use it later on.

gds.exp.l.h <- hist( log2(gds.exp) )
## you may wish to specify a different number of breaks in the histogram
## but it is not that important.

## you should have a look at this gds.exp.l.h
names(gds.exp.l.h)

## and simply
gds.exp.l.h

## consider the difference between the following:
plot( gds.exp.l.h$mids, gds.exp.l.h$counts )
plot( gds.exp.l.h$mids, gds.exp.l.h$counts, type='l' )
plot( gds.exp.l.h$mids, gds.exp.l.h$counts, type='b' )

plot( gds.exp.l.h$mids, gds.exp.l.h$density, type='b' )

## and maybe:
plot( gds.exp.l.h$breaks[-1], gds.exp.l.h$density, type='b' )

## there is also a convenient function with() that you can use with
## lists and dataframes:

with( gds.exp.l.h, plot( mids, counts, type='b',
                        main='A distribution of everything', xlab='log2 expression' ))
```

Having looked at the distribution of the values we see that we should probably
log transform the data for further analyses. So far we have only looked at the
distribution of the full data set; we should see whether the distributions are
the same in the different samples. Remember that each column of the data set
represents a single sample and that we can use `apply` to perform operations
on rows or columns of data. It is also useful to make sure that we have the
same breaks for all of the distributions. We can ensure this by using the
`$breaks` component of the histogram returned by the `hist` function above.

```R
## l for log, s for sample, h for histogram.
## this is getting troublesome to write, read and remember. There are
## better ways...

## the second argument to apply is MARGIN; a 2 means operate on columns of
## the data. Here this means that hist will be called on each column of data
## The last set of arguments to apply (...) will simply be passed to the
## specified function. Here we make sure to tell hist to use the same
## breaks as for the full data set.
gds.exp.l.s.h <- apply(log2(gds.exp), 2, hist, breaks=gds.exp.l.h$breaks)

## you may have noticed your screen flicker a bit. Consider changing to:
gds.exp.l.s.h <- apply(log2(gds.exp), 2, hist, breaks=gds.exp.l.h$breaks, plot=FALSE)

## what did we get?
## make sure you understand what the following means
class(gds.exp.l.s.h)
length(gds.exp.l.s.h)
names(gds.exp.l.s.h)

class( gds.exp.l.h )
class( gds.exp.l.s.h[[1]] )
sapply( gds.exp.l.s.h, class )

## Having done that how can we look at the data. The easiest way is to
## extract the things that we want to visualise. Since we have a list we can extract
## out the mids and the counts or density that we used before:

## and lets use shorter variable names. This would be a problem if we had lots of
## different datasets that we did different things on. And doing the following
## is bad, and you should feel guilty, but sometimes life is like that.

## to extract a part of each hist object we define a function in the
## sapply statement.
counts <- sapply( gds.exp.l.s.h, function(x){ x$counts } )
mids <- sapply( gds.exp.l.s.h, function(x){ x$mids } )
## note that it doesnt matter what I call the argument to the function
## it is only an identifier:
density <- sapply( gds.exp.l.s.h, function(graka){ graka$density })

## have a look at the dimensions:
dim(counts)
dim(mids)
dim(density)

## and consider where they come from:
dim( gds.exp )
length( gds.exp.l.s.h )
length( gds.exp.l.h$counts )

## have a look at the data structures:
head( counts )
counts[,1:4]

head(mids)
mids[,1:4]

## you should have noticed something about mids. if not
## look again.

## I can now plot all of the distributions in a single plot:
## First I have to work out what range of values I have
## so that I can set the ylimits appropriately.

## plot the first column
plot( mids[,1], counts[,1], ylim=range(counts), type='l' )
## and then loop through the remaining columns
for(i in 2:ncol(counts)){
    lines( mids[,i], counts[,i])
}

## if we don't set the ylim above then we get the following
plot( mids[,1], counts[,1], type='l' )
## and then loop through the remaining columns
for(i in 2:ncol(counts)){
    lines( mids[,i], counts[,i])
}
## which is not so good.

## you should note that ther are at least two groups here. But from this plot its
## not so easy to see. We can colour the lines differently using the sample data.
## consider

colnames(gds.columns)
## and
gds.columns$tissue

## the tissue column is a factor. Factors can be coerced to numerics which can
## be used to specify colour.
as.numeric( gds.columns$tissue )

## we can now do:
plot( mids[,1], counts[,1], ylim=range(counts), type='l', col=as.numeric(gds.columns$tissue[1]) )
## and then loop through the remaining columns
for(i in 2:ncol(counts)){
    lines( mids[,i], counts[,i], col=as.numeric(gds.columns$tissue[i]))
}

## working out which color is what can be a bit of a pain, as dealing with factors
## often is.

## we can also colour by other columns

plot( mids[,1], counts[,1], ylim=range(counts), type='l', col=as.numeric(gds.columns$genotype[1]) )
## and then loop through the remaining columns
for(i in 2:ncol(counts)){
    lines( mids[,i], counts[,i], col=as.numeric(gds.columns$genotype[i]))
}

plot( mids[,1], counts[,1], ylim=range(counts), type='l', col=as.numeric(gds.columns$agent[1]) )
## and then loop through the remaining columns
for(i in 2:ncol(counts)){
    lines( mids[,i], counts[,i], col=as.numeric(gds.columns$agent[i]))
}

## note that it actually turns out that we can specify colours directly from
## a factor and that we don't need to do as.numeric. The following will also work.
plot( mids[,1], counts[,1], ylim=range(counts), type='l', col=gds.columns$agent[1] )
## and then loop through the remaining columns
for(i in 2:ncol(counts)){
    lines( mids[,i], counts[,i], col=gds.columns$agent[i])
}

```

You may have noticed that there is an awful lot of code that is repeated with
very minor changes; where I have simply copied and pasted something. That is
*bad* and you should not do that. In this case if we find that we are doing
something like it we might consider creating a function of some sort.

```R
## x and y should be matrices of the same dimensions
## whose column values will be plotted against each other
## col should specify colours in some way.
plot.columns <- function(x, y, col, ...){
    plot( x[,1], y[,1], xlim=range(x), ylim=range(y), col=col[1], type='l', ... )
    for(i in 2:ncol(x)){
        lines( x[,i], y[,i], col=col[i] )
    }
}

## then we can simply do..
plot.columns( mids, counts, gds.columns$tissue )

## That doesn't look great. So we can pass some extra arguments to
## plot..
plot.columns( mids, counts, gds.columns$tissue, main="Some distributions", xlab="log2 expression", ylab="counts" )
## and then.. 

plot.columns( mids, counts, gds.columns$agent, main="Some distributions", xlab="log2 expression", ylab="counts" )
## and so on.
```

You can often get a good idea of how values by simple line plots. However, it
can be difficult to see the relationships between the lines. For this we often
use some sort of heatmap plotting. There is a `heatmap` function in R, but it
does a bit too much, so it is often easier to use the lower level `image`
function. For ultimate flexibility we can also use the `rect` function, though
this is a bit more complicated. Consider the following code:

```R
heatmap( counts )
## horrible colours and quite obviously heatmap has arranged things around a lot.
## lets try with different colours first. We can use the rainbow() function to
## generate some colours;
heatmap( counts, col=rainbow(255) )
heatmap( counts, col=rainbow(255, start=0.1) )

## that still looks a huge mess.. consider the differences between
heatmap( counts, col=rainbow(255, start=0.1), Rowv=NA )
heatmap( counts, col=rainbow(255, start=0.1), Rowv=NA, Colv=NA )

## in fact this is still difficult. You can consider:
heatmap( counts, col=rainbow(255, start=0.1), Rowv=NA, scale='none' )
heatmap( log(counts+1), col=rainbow(255, start=0.1), Rowv=NA, Colv=NA, scale='none' )

tissue.colors <- c('black', 'red', 'green', 'blue', 'cyan')
heatmap( counts, col=rainbow(255, start=0.1), Rowv=NA, scale='none',
        ColSideColors=tissue.colors[ gds.columns$tissue ])

tissue.colors <- c('black', 'red', 'green', 'blue', 'cyan')
heatmap( counts, col=rainbow(255, start=0.1), Rowv=NA, Colv=NA, scale='none',
        ColSideColors=tissue.colors[ gds.columns$tissue ])

tissue.colors <- c('black', 'red', 'green', 'blue', 'cyan')
heatmap( counts, col=rainbow(255, start=0.1), Rowv=NA, scale='none',
        ColSideColors=tissue.colors[ gds.columns$agent ])

## heatmap is quite useful, but it does rather too much by default, and can be
## tricky to use without reading the manual everytime. I tend to use image instead

image( counts )
## maybe here we prefer
image( t(counts) )
## remember that t() transposes data (swaps columns and rows)

par(mar=c(8.1, 4.1, 4.1, 2.1))
image(x=1:ncol(counts), y=mids[,1], z=t(counts),
      col=rainbow(255, s=1, v=0.8, start=0.1), xaxt='n',
      xlab='', ylab='log2 expression', main="More distributions")
axis(1, at=1:ncol(counts), labels=colnames(counts), las=2)
```

There are lots of ways to visualise the distributions, but we can also
consider to treat each distribution as an object in its own right. We can then
do things like compare all of the distributions to each other, and even do a
PCA to consider whether there are any strong underlying patterns in the data.

```R
## we can cacluate correlation coefficents using the cor() function
## this will calculate correlaations for all columns against all columns
## given a matrix:

counts.cor <- cor(counts)
head(counts.cor)
dim(counts.cor)

## we can look at that as before using the image function.
par(mar=c(8.1, 8.1, 4.1, 2.1))
image(x=1:ncol(counts.cor), y=1:ncol(counts.cor), z=t(counts.cor),
      col=rainbow(255, s=1, v=0.8, start=0.1), xaxt='n', yaxt='n',
      xlab='', ylab='', main="Distribution correlations")
axis(1, at=1:ncol(counts), labels=colnames(counts), las=2)
axis(2, at=1:ncol(counts), labels=colnames(counts), las=2)

## definitely a good deal of structure there. 

## to do a PCA on the data we can use prcomp
## note that the objects compared to each other should
## be in each row. Hence we need to tranpose the counts

counts.pca <- prcomp( t(counts) )
plot(counts.pca) ## definitely some structure there

## look at the counts.pca:
names(counts.pca)
sapply(counts.pca, dim)

## To plot the points in the first and second dimension
## we use the x table of the prcomp object

with( counts.pca, plot(x[,1], x[,2], xlab='Dim 1', ylab='Dim 2' ))
## very clear distinction. Again we can colour in varios ways

with( counts.pca, plot(x[,1], x[,2], xlab='Dim 1', ylab='Dim 2', col=gds.columns$tissue, pch=19 ))
## we can add a legend here to indicate the colors
legend('bottomright', legend=levels(gds.columns$tissue), fill=unique(gds.columns$tissue))

## we can add some indicators of the genotype as well:
with( counts.pca, points(x[,1], x[,2], col=gds.columns[,'genotype/variation'], pch=1, cex=2, lwd=2 ))
with( counts.pca, points(x[,1], x[,2], col=gds.columns[,'agent'], pch=1, cex=3, lwd=2 ))
## which doesnt tell us that much more.
```

Having looked at the distributions we should consider whether we want to
include all samples and whether we should consider trying to normalise away
the differences in the distributions. Whether and to what extent to normalise
is a complex question that I will not cover here. However, you should be aware
of it. From here onwards I will simply use all of the samples with (possibly)
very marginal normalisation.

# The expression data

We can now start to look at the expression data. We can do this in various
ways:

1. Look at the overall structure with a PCA or look at the correlations of the
   samples or any number of ways.
2. Look for genes that vary with the different experimental factors. This
   usually involves some form of fitting to a predefined model and can be
   complex. We will not do complex things here, but will be more concerned
   with dealing with multiple testing.
   
## The overall structure of the expression data

Just as we did for the distribution values we can calculate the correlations
of all of the columns against each other. But before we do that, lets consider
the loading of each sample (i.e. the total amount of signal). We generally
would expect that this should be the same for all of the samples.

### Loading (total counts)

```R
## calculate the sums of the signal intensities for each column
colSums( gds.exp )

## big numbers, lets visualise
plot( colSums( gds.exp ) )

## again we can use colour to give more information:
plot( colSums( gds.exp ), col=gds.columns$tissue )
## the black ones have less. I believe that is the adipose tissue and
## you can see that relates to the distributions that we looked at above.
## possibly we should have used density rather than counts in the PCA
## above. Feel free to try.

## you can also do:
barplot( colSums(gds.exp), las=2 )

## the differents here are not that large. We can divide all columns
## by their mean values.. This is a form of normalisation; the simplest
## of all. For this, lets create a new matrix

exp <- t(t(gds.exp) / colMeans(gds.exp))

barplot( colSums(exp), las=2 )

## there is a bit of trickery with transpose going on here;
## it is actually quite important to understand.
## consider:

m <- matrix(1:15, ncol=3)

## note the result of:
m - 1:5
m - 1:3

## and you should note that the values are subtracted by row.
## m.m has only three values. The first of this should be used to
## divide the values in the first column; if I transpose the columns
## I can do this directly:

t(m)
##      [,1] [,2] [,3] [,4] [,5]
## [1,]    1    2    3    4    5
## [2,]    6    7    8    9   10
## [3,]   11   12   13   14   15

t(m) / 1:3
## is equivalent to:
##      [,1] [,2] [,3] [,4] [,5]
## [1,]    1    2    3    4    5     1
## [2,]    6    7    8    9   10  /  2
## [3,]   11   12   13   14   15     3

## but everything is now transposed the wrong
## way round, so we retranspose to get back to where we started.

t( t(m) / 1:3 )

## This is actually really useful knowledge if you are using R.
## But also something that is really easy to get wrong.
```

We can now go on to look at the structure as before.

### Expression correlation

```R
## lets do for both gds.exp and exp. But again we should probably log transform.

gds.exp.c <- cor( log2(gds.exp) )
exp.c <- cor( log2(gds.exp) )

## again we can simply use image:
par(mar=c(8.1, 8.1, 4.1, 2.1))
image(x=1:ncol(gds.exp.c), y=1:ncol(gds.exp.c), z=gds.exp.c,
      col=rainbow(255, s=1, v=0.8, start=0.1), xaxt='n', yaxt='n',
      xlab='', ylab='', main="Expression correlations")
axis(1, at=1:ncol(counts), labels=colnames(gds.exp.c), las=2)
axis(2, at=1:ncol(counts), labels=colnames(gds.exp.c), las=2)

## again we can simply use image:
par(mar=c(8.1, 8.1, 4.1, 2.1))
image(x=1:ncol(exp.c), y=1:ncol(exp.c), z=exp.c,
      col=rainbow(255, s=1, v=0.8, start=0.1), xaxt='n', yaxt='n',
      xlab='', ylab='', main="Expression correlations")
axis(1, at=1:ncol(counts), labels=colnames(exp.c), las=2)
axis(2, at=1:ncol(counts), labels=colnames(exp.c), las=2)

## and we really don't see much difference between those

## to make a nicer picture we can change the order of the samples.
s.o <- order( gds.columns$tissue, gds.columns[,'genotype/variation'], gds.columns$agent )
gds.exp.c <- cor( log2(gds.exp[,s.o]) )
exp.c <- cor( log2(gds.exp[,s.o]) )


par(mar=c(8.1, 8.1, 4.1, 2.1))
image(x=1:ncol(exp.c), y=1:ncol(exp.c), z=exp.c,
      col=rainbow(255, s=1, v=0.8, start=0.1), xaxt='n', yaxt='n',
      xlab='', ylab='', main="Expression correlations")
axis(1, at=1:ncol(counts), labels=colnames(exp.c), las=2)
axis(2, at=1:ncol(counts), labels=colnames(exp.c), las=2)

## which is a little bit nicer.. 
```

### Principal components analysis

To peform the PCA we do the same thing as before. However, we may consider
scaling the data; this will ensure that genes that are expressed highly do not
contribute more to the PCA than genes expressed at a low level. In essence
what we end up lookin at is only how a gene changes across the experimental
series.

```R
## scaling..
## consider the following matrix:
m <- matrix(1:15, ncol=3)
m[,2] <- m[,2] * 2
m[,3] <- m[,3] * 3
## look at it!
m

plot(1:5, m[,1], type='b', col=1, ylim=range(m))
points(1:5, m[,2], type='b', col=2)
points(1:5, m[,3], type='b', col=3)

## the lines have the same pattern, though different locations.
## lets subtract the column means from each line
m.s <- t( t(m) - colMeans(m) )

plot(1:5, m.s[,1], type='b', col=1, ylim=range(m.s))
points(1:5, m.s[,2], type='b', col=2)
points(1:5, m.s[,3], type='b', col=3)

## now the lines are centered. We cn also consider to divide by the
## standard deviation of each column:

m.s <- t( (t(m) - colMeans(m)) / apply(m, 2, sd) )

plot(1:5, m.s[,1], type='b', col=1, ylim=range(m.s))
points(1:5, m.s[,2], type='b', col=2)
points(1:5, m.s[,3], type='b', col=3)

## and now they are completely identical...
## this is what the scaling function does. Note that since it divides by
## the standard deviation we must have some variance in the data to be able to use it

```

To run the PCA we do as before:

```R
gds.exp.pca <- prcomp( log2( t(gds.exp) ), scale=TRUE )
exp.pca <- prcomp( log2(t(exp)), scale=TRUE )

## have a look at both of these:
plot(gds.exp.pca)
plot(exp.pca)

with(gds.exp.pca, plot(x[,1], x[,2]))
with(exp.pca, plot(x[,1], x[,2]))

## consider how you can use colours to distinguish the
## different samples.

```

### Fitting a simple model (lm and ANOVA)

Here I will fit three different models to the data:

1. Expression is a function of tissue
2. Expression is a function of agent (treatment)
3. Expression is a function of the interaction of tissue and agent

We will only have a cursory look at the results as it will take rather too
long otherwise. We will use the simplest linear model fitting (`lm`).

```R
## We will fit a model to every row of the exp data set
exp.m1 <- apply(log(exp), 1, function(x){ lm(x ~ gds.columns$tissue) })
exp.m2 <- apply(log(exp), 1, function(x){ lm(x ~ gds.columns$agent) })
exp.m3 <- apply(log(exp), 1, function(x){ lm(x ~ gds.columns$tissue * gds.columns$agent) })

## note that this is really slow and that you would probably use some
## function that is dedicated to gene expression analysis in real life.

## have a look at the first model:
exp.m1[[1]]
class(exp.m1[[1]])
names(exp.m1[[1]])

## there are a lot of things that you can get from the model. In general though
## we are interested in the p-values which you can obtain from the f-statistics
## and the pf() function

## we can get this via the summary function:
summary(exp.m1[[1]])

## which actually returns a named list:
names( summary(exp.m1[[1]]))
## we can get the fstatistic by:
summary(exp.m1[[1]])$fstatistic

## we can then (the long way around)
fs <- summary(exp.m1[[1]])$fstatistic
pf( fs[1], fs[2], fs[3], lower.tail=FALSE ) ## very good.

## to get all the p values we can define a function..
get.pf <- function(x){
    fs <- summary(x)$fstatistic
    pf( fs[1], fs[2], fs[3], lower.tail=FALSE )
}

## we can then get the p-values;
exp.m1.p <- sapply( exp.m1, get.pf )
exp.m2.p <- sapply( exp.m2, get.pf )
exp.m3.p <- sapply( exp.m3, get.pf )

### consider the p-value distributions:
### first in linear space and then in log
hist(exp.m1.p)
hist(exp.m2.p)
hist(exp.m3.p)

hist(log10(exp.m1.p))
hist(log10(exp.m2.p))
hist(log10(exp.m3.p))

## note the differences..
## we can also do quantiles plots..
plot( sort(log10(exp.m1.p)), col=1 )
points( sort(log10(exp.m2.p)), col=2 )
points( sort(log10(exp.m3.p)), col=3 )
abline(h=log10(0.05), col='red')

## this should tell you something..
## we can even ask if there are some that fit model3 better
## than model1
plot( log10(exp.m1.p), log10(exp.m3.p) )
abline(0, 1, col='red')

## Again, try to work out what it is that you are seeing here.
```

### Adjusting the p-values

As mentioned in the lectures, we have done around 16,000 statistical tests for
each of the models. We thus have to correct for the multiple testing. In `R`
there is a function `p.adjust` that lets us do this easily.

```R
plot( sort( log10( p.adjust( exp.m1.p ))))
plot( sort( log10( p.adjust( exp.m2.p ))))
plot( sort( log10( p.adjust( exp.m3.p ))))

## but note that you should read the documentation:
?p.adjust

plot( sort( log10( p.adjust( exp.m1.p, method='BH' ))))
plot( sort( log10( p.adjust( exp.m2.p, method='BH' ))))
plot( sort( log10( p.adjust( exp.m3.p, method='BH' ))))

## for this data there is not that much of a difference
## between the different methods.

## see if you can work out how many genes have p-values
## lower than 0.05, before and after adjustment.
##
## you can do something like
## sum( p < 0.05 )
##
## where you obviously replace the p with the adjusted p values
```

### Looking at individual genes

We can also extract specific genes that have differential expression and then
visualising their expression pattern across the data set.

```R
## look for tissue specific genes
## first define an order ..
g.o <- order( exp.m1.p )

## and lets make a function that extracts the a set of genes
## from this order and plots their expression

plot.ge <- function(o, n, exp, samples=gds.columns, scale=TRUE, ...){
    m <- exp[ o[1:n], ]
    if(scale)
        m <- t( scale(t(m)))
    x <- 1:ncol(m)
    plot(x, m[1,], ylim=range(m), type='l', ...)
    for(i in 2:row(m)){
        lines(x, m[i,])
    }
}

plot.ge( g.o, 10, log2(exp) )
plot.ge( g.o, 20, log2(exp) )
plot.ge( g.o, 100, log2(exp) )

## we can also ask for genes that have similar expression patterns to the first one:
## you can do this most simply by the cor function. From the correlation you can then
## create an order (using order) as above and plot those.
## Please try this if you have time.
```

