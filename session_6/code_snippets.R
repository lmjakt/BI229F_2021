ex.pos <- c(10, 30, 43, 50, 80)
ex.w <- c(5, 4, 3, 8, 15)
seq <- sample(c('A', 'C', 'G', 'T'), 100, replace=TRUE)

x1 <- 5;  y1 <- 10
x2 <- 20; y2 <- 30
n <- max( abs(x2-x1), abs(y2-y1) )

for( i in 0:n ){
    x <- x1 + (x2 - x1) * i/n
    y <- y1 + (y2 - y1) * i/n
    pixels[x,y] <- "#000000"
}

rasterImage(pixels)

### code for slide 17
slides[[16]] <- function(){
    slides[[12]](question=FALSE)
    sc.text("In this case:", cex=2, y=70, x=10, adj=c(0,0))
    code  <- readLines("code_snippets.R")[1:3]
    code.col  <- coloriseR(code)
    pos  <- draw.code(code.col, 10, 60, cex=2)
    get.input()
    sc.text("ex.pos, ex.w, seq\nare all variables",
            cex=2.5, y=min(pos$pos[,'y']) - (pos$lheight + 5),
            x=10, adj=c(0,1), max.w=40)
    pos2  <- sc.text("Variables",
                    cex=2.5, y=min(pos$pos[,'y']) - (pos$lheight + 5),
                    x=52, adj=c(0,1), max.w=40)
    bullet.list(list("labels that point to data",
                     "can be used to",
                     list("set value", "access and use value")),
                t.cex=2.5, x=52, y=with(pos2, y-(h+5)),
                max.w=40, line.spc=1)
}

## a simple vector
v1 <- c(3, 4, 1, 2)
## use range notation to create
v2 <- 1:10

## to access elements use []
v1[1] + v2[2]

## a named vector
v3 <- c(a=1, b=2, c=10, d=4)

## to access elements use []
## and string or index
v3['a'] + v3[2]

### This is allowed but bad:
v4 <- c("a", 10)

### vectorised addition
v1 <- 1:10
v2 <- 10:1

v1
 [1]  1  2  3  4  5  6  7  8  9 10

v2
 [1] 10  9  8  7  6  5  4  3  2  1

v1 + 1
 [1]  2  3  4  5  6  7  8  9 10 11

v1 + v2
 [1] 11 11 11 11 11 11 11 11 11 11

## and a little more complicated:
v1 + v2[c(1,10)]
 [1] 11  3 13  5 15  7 17  9 19 11

## Conditional execution
a  <- 10
b  <- 20

if( a < b ){
    print("A is smaller than b")
}else{
    print("A is not smaller than b")
}

## logical (TRUE / FALSE) vectors
a  <- 1:10
a
 [1]  1  2  3  4  5  6  7  8  9 10

b  <- a > 5
b
 [1] FALSE FALSE FALSE FALSE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE

## we can subset a vector with numeric index values:
a[ c(1, 3, 5) ]
 [1] 1 3 5

## but we can also use a logical vector
a[b]
 [1]  6  7  8  9 10

### For loops in R
a  <- 1:10 * 2
a
 [1]  2  4  6  8 10 12 14 16 18 20

## calculate the sum of a
a.sum <- 0
for( v in a ){
    a.sum  <- a.sum + v
}
a.sum
[1] 110

## use an index
a.sum  <- 0
for(i in 1:length(a)){
    a.sum  <- a.sum + a[i]
}
a.sum
 [1] 110

## A basic while loop in R
a  <- 1:10 * 3
a
 [1]  3  6  9 12 15 18 21 24 27 30

## define an index:
a.sum  <- 0
i  <- 1
while(i <= length(a)){
    a.sum  <- a.sum + a[i]
    i  <- i + 1
}
a.sum
 [1] 165

## with more complex conditional
a.sum  <- 0
i  <- 1
while(i <= length(a) && a[i] < 18){
    a.sum  <- a.sum + a[i]
    i  <- i + 1
}
a.sum
 [1] 45

## the sapply statement:
a  <- 1:10 * 3 - 10
a
 [1] -7 -4 -1  2  5  8 11 14 17 20

## multiply every element by -1
sapply(a, function(x){ x * -1 })
 [1]   7   4   1  -2  -5  -8 -11 -14 -17 -20

## here sapply returns a vector

## A function that sums elements of
## a vector if they lie between a max and
## minimum value
sum.within.range  <- function(x, min.v, max.v){
    x.sum  <- 0
    for(v in x){
        if(v >= min.v & v <= max.v){
            x.sum  <- x.sum + v
        }
    }
    x.sum
}

## execute the above code to define the function
## to call it we need some numbers
a  <- 1:100
b  <- sum.within.range(a, 45, 50)
b
 [1] 285

## should give the same result as
sum( 45:50 )
  [1] 285
## seems OK

## boolean operations
a  <- 1:10
b1 <- a > 4
b2 <- a < 8
b1
 [1] FALSE FALSE FALSE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
b2
 [1]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE FALSE FALSE

## combine with AND
b1 && b2
 [1] FALSE
b1 || b2
[1] TRUE

b1 & b2
 [1] FALSE FALSE FALSE FALSE  TRUE  TRUE  TRUE FALSE FALSE FALSE
b1 | b2
 [1] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE

xor(b1, b2)
 [1]  TRUE  TRUE  TRUE  TRUE FALSE FALSE FALSE  TRUE  TRUE  TRUE

