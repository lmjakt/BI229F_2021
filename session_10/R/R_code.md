Example code snippets for distributions to p-values

```R
N <- 1000
k <- 5
S <- -10:10
means <- vector(mode='numeric', length=N)
for(i in 1:N)
    means[i] <- mean( sample(S, size=k, replace=TRUE) )
hist(means)
```

Inspect the values a bit more:

```R
N <- 1000
k <- 5
S <- -10:10
means <- vector(mode='numeric', length=N)
for(i in 1:N)
    means[i] <- mean( sample(S, size=k, replace=TRUE) )
m.mean <- mean(means)
m.median <- median(means)
m.var <- var(means)
m.sd <- sd(means)
hist(means)
abline(v=c(m.mean, m.median), col=c('blue', 'red'))
abline(v=m.mean + c(-m.sd, m.sd), col='dark green')
abline(v=m.mean + c(-m.var, m.var), col='dark green', lty=2)
```

Make a function to obtain the distribution:

```R
make.norm.1 <- function(N, k, S, breaks=N/20, ...){
    ## use sapply instead of a loop
    means <- sapply(1:N, function(x){
        mean( sample(S, size=k, replace=TRUE) )
    })
    h <- hist(means, breaks=breaks, ...)
    list(m=means, h=h)
}
```

Call the function for several values of N using `lapply`:

```R
k <- 5
S <- -10:10
N <- 2^(10:15)
par(mfrow=c(2,3))
h <- lapply(N, make.norm.1, k=k, S=S)
```

To check the effect of k, we first choose an N that gives us a nicely shaped
distribution:

```R
N <- 2^15
S <- -10:10
k <- 2^(0:5)
par(mfrow=c(2,3))
h <- vector(mode='list', length=length(k))
for(i in 1:length(k))
    h[[i]] <- make.norm.1(N, k[i], S, breaks=50, main=paste('k =', k[i]))
```

Lets make a function that calculates variance; we can convert to
standard deviation by simply taking the square root.

```R
## we already have a var function. We don't want to
## clobber it.
my.var <- function(x){
    xm <- mean(x)
    sum( (x - xm)^2 ) / length(x)
}
```

And lets call that on the data we created above:

```R
h.var <- sapply(h, function(x){ my.var( x$m ) })
par(mfrow=c(1,1))
plot(k, h.var, type='b', xlab='k', ylab='variance')
```

Check that the my.var function does what it is supposed to do:

```R
h.var.2 <- sapply(h, function(x){ var( x$m ) })
plot(h.var, h.var.2, xlab='my.var', ylab='var', type='b')
### But.. 
h.var == h.var.2
### is all FALSE
```

How normal are the distributions. We can calculate standard deviation and
variance for each one separately and then use the `dnorm` function.

```R
## obtain the fitted distributions for each
## set of mean values:

h.norm <- lapply(h, function(x){
    sd <- sd( x$m )
    m <- mean( x$m )
    dnorm(x$h$mids, mean=m, sd=sd) })

par(mfrow=c(2,3))
for(i in 1:length(k)){
    plot(h[[i]]$h$mids, h[[i]]$h$density,
         main=paste('k =', k[i]), type='b')
    lines(h[[i]]$h$mids, h.norm[[i]], col='red',
          lwd=2, type='b')
}

```

To get all combinations for k=2

```R
v <- sapply( -10:10, function(x){
    x + -10:10
})

length(unique(as.numeric(v))) ## 41
plot(table( v ))

```

```R
make.norm.2 <- function(N, k, min.v, max.v, breaks=N/20, ...){
    ## use sapply instead of a loop
    means <- sapply(1:N, function(x){
        mean( runif(k, min=min.v, max=max.v) )
    })
    h <- hist(means, breaks=breaks, ...)
    list(m=means, h=h)
}
```

```R
N <- 2^15
min.v=-10
max.v=10
k <- 2^(0:5)
par(mfrow=c(2,3))
h <- vector(mode='list', length=length(k))
for(i in 1:length(k))
    h[[i]] <- make.norm.2(N, k[i], min.v=min.v, max.v=max.v,
                          breaks=50, main=paste('k =', k[i]))

h.norm <- lapply(h, function(x){
    sd <- sd( x$m )
    m <- mean( x$m )
    dnorm(x$h$mids, mean=m, sd=sd) })

par(mfrow=c(2,3))
for(i in 1:length(k)){
    plot(h[[i]]$h$mids, h[[i]]$h$density,
         main=paste('k =', k[i]), type='b')
    lines(h[[i]]$h$mids, h.norm[[i]], col='red',
          lwd=2, type='b')
}

```

Obtain normally distributed numbers using rnorm:

```R
x <- rnorm( n=10000, mean=10, sd=3 )
x.mean <- mean(x)
x.sd <- sd(x)

sum( abs(x - x.mean) > x.sd ) / length(x) ## 0.3181
sum( abs(x - x.mean) > 2 * x.sd ) / length(x) ## 0.046
sum( abs(x - x.mean) > 3 * x.sd ) / length(x) ## 0.0025

h <- hist( x, breaks=50 )
b.i <- which( abs( h$mids - mean(x) ) < 2 * x.sd )
with(h, polygon( c(mids[b.i[1]], mids[b.i], mids[b.i[length(b.i)]]),
                c(0, counts[b.i], 0), col=rgb(0, 0.4, 0.8, 0.4)))
```

What do we mean when we say that two measures are different in a statistical
sense?

```R
## sample values from the same distribution
## or from two different distributions
q <- seq(0,20,0.25)
m1 <- 8
m2 <- 14
sd1=2
sd2=3
d1 <- dnorm( q, mean=m1, sd=sd1)
d2 <- dnorm( q, mean=m2, sd=sd2)
plot(q, d1, ylim=range(c(d1, d2)), type='l', col='red', lwd=2,
     xlab='value', ylab='frequency', cex.axis=1.5, cex.lab=1.5)
lines(q, d2, type='l', col='blue', lwd=2)
```

Measurements are simply samples of the above distribution.
Say if we have three replicates:

```R
rep.n <- 3
est1.1 <- rnorm( rep.n, mean=m1, sd=sd1 )
est1.2 <- rnorm( rep.n, mean=m2, sd=sd2 )
## visualise these...
stripchart( list('X'=est1.1, 'Y'=est1.2),
           vertical=FALSE, pch=19, cex=2,
           col=c('red', 'blue') )
```

To do repeated functions we can define a function in R that repeats this. This
is a bit more difficult to do using R style.

```R
rep.sample <- function(N, n, m1, m2, sd1, sd2, label){
    l1 <- lapply(1:N, function(i){
        l <- list(rnorm(n, m1, sd1),
                  rnorm(n, m2, sd2))
        names(l) <- paste(label, i, sep="")
        l
    })
    do.call(c, l1)
}

N <- 10
n <- 3
measures <- rep.sample(N, n, m1, m2, sd1, sd2, c('X', 'Y'))

stripchart( measures, pch=19, col=c('red', 'blue'),
           cex=2, vertical=TRUE, cex.axis=1.4)
x <- 1:N*2
with(par(),
     rect(x-1.5, usr[3], x+0.5, usr[4],
          col=c(rgb(0.8, 0.8, 0.8, 0.3),
                rgb(0.8, 0.8, 0.8, 0)),
          border=NA))
```

We can estimate the means and standard deviations from these:

```R
est.m <- sapply( measures, mean )
est.sd <- sapply( measures, sd )

x.i <- seq(1, 20, 2)
y.i <- seq(2, 20, 2)

par(mfrow=c(1,2))
plot(rep(1, length(x.i)), est.m[x.i],
     xlim=c(0,3), ylim=range(est.m),
     pch=19, cex=2, col='red', xaxt='n',
     xlab='sample', ylab='mean')
points(rep(2, length(y.i)), est.m[y.i],
       pch=19, cex=2, col='blue')
abline(h=c(m1, m2), col=c('red', 'blue'),
       lwd=2)

plot(rep(1, length(x.i)), est.sd[x.i],
     xlim=c(0,3), ylim=range(est.sd),
     pch=19, cex=2, col='red', xaxt='n',
     xlab='sample', ylab='standard deviation')
points(rep(2, length(y.i)), est.sd[y.i],
       pch=19, cex=2, col='blue')
abline(h=c(sd1, sd2), col=c('red', 'blue'),
       lwd=2)

```

We can then of course create some estimated distributions:

```R
x.est <- sapply( x.i, function(i){ dnorm(q, est.m[i], est.sd[i]) })
y.est <- sapply( y.i, function(i){ dnorm(q, est.m[i], est.sd[i]) })

par(mfrow=c(1,1))
plot(q, x.est[,1], col='red', type='l',
     ylim=range(c(x.est, y.est)), lty=2,
     xlab='value', ylab='frequency')
for(i in 2:ncol(x.est))
    lines(q, x.est[,i], col='red', lty=2)
for(i in 1:ncol(y.est))
    lines(q, y.est[,i], col='blue', lty=2)
lines(q, d1, col='red', lwd=3)
lines(q, d2, col='blue', lwd=3)
```

Consider the following pair of distributions:

```R
d3 <- dnorm(q, 8, 0.5)
d4 <- dnorm(q, 12, 0.5)
d5 <- dnorm(q, 8, 4)
d6 <- dnorm(q, 12, 4)

par(mfrow=c(1,2))
plot(q, d3, ylim=range(c(d3, d4)), type='l',
     lwd=2, col='red')
lines(q, d4, lwd=2, col='blue')
plot(q, d5, ylim=range(c(d5, d6)), type='l',
     lwd=2, col='red')
lines(q, d6, lwd=2, col='blue')
```

A simple distribution:

```R
plot(q, d5, type='l', lwd=2, xlab="", ylab="")

N <- 100000
n <- 3
m <- 8
sd <- 4
## sample n times
my.t <- function(a, b){
    (mean(a) - mean(b)) /
        (sqrt(var(a) + var(b)) * sqrt(1/length(n)))
}

t.val <- sapply(1:N, function(i){
    my.t( rnorm(n, m, sd), rnorm(n, m, sd))
})

t.h <- hist(t.val, breaks=100)

qnt <- seq(0,1,0.05)
plot(qnt, quantile(t.val, probs=qnt),
     xlab='quantile', ylab='t')

my.p <- function(t, tdist){
    sum( abs(tdist) > abs(tdist) ) / length(tdist)
}

## obtain the actual p distribution for n=3, and n=3
## degrees of freedom = 6-2 = 4

q <- seq(-5, 5, 0.1)
tt <- dt(q, 4)
q1 <- which( cumsum(tt) / sum(tt) >= 0.05 )[1]
q2 <- max(which( cumsum(tt) / sum(tt) <= 0.95 )) + 1
q2 <- q2 + 1
q1 <- q1-1
plot(q, tt, type='l', xlab='t', ylab='frequency')
polygon( c(q[q1], q[q1:q2], q[q2]), c(0, tt[q1:q2], 0),
        col=rgb(0, 0.2, 0.6, 0.2))
q1 <- which( cumsum(tt) / sum(tt) >= 0.025 )[1]
q2 <- max(which( cumsum(tt) / sum(tt) <= 0.975 )) + 1
q2 <- q2 + 1
q1 <- q1-1
polygon( c(q[q1], q[q1:q2], q[q2]), c(0, tt[q1:q2], 0),
        col=rgb(0.6, 0.2, 0, 0.2))
```

Use t.test to obtain p-values from data sampled from the same distribution:

```R
t.tests <- lapply( 1:N, function(i){
    t.test( rnorm(n, m, sd), rnorm(n, m, sd),
           alternative='two.sided', var.equal=TRUE )
})

t.tests.p <- sapply( t.tests, function(x){ x$p.value })
hist(t.tests.p)
```

But this gives the wrong distribution..

```R
t.tests <- lapply( 1:N, function(i){
    t.test( rnorm(n, m, sd), rnorm(n, m, sd),
           alternative='two.sided', var.equal=FALSE )
})

t.tests.p <- sapply( t.tests, function(x){ x$p.value })
hist(t.tests.p)
```
