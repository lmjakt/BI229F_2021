

slides[[1]] <- function(){
    new.slide()
    slide.title("Scripts and programs")
    sc.text( "Automating simple to complex tasks", cex=4)
}

slides[[2]] <- function(){
    new.slide()
    slide.title("What is programming?")
    bullet.list(list("A detailed set of instructions",
                    list(""),
                     "A data model",
                     list("")),
                10, 80)
}

slides[[3]] <- function(){
    new.slide()
    slide.title("Scripts vs programs")
    get.input()
    sc.text( "Programs", x=10, y=80, adj=c(0,0), max.w=40, cex=4 )
    bullet.list(list("Complex tasks",
                     "Used many times",
                     "Slow to write",
                     "Compiled to machine code",
                     "Fast to run"), x=10, y=68, t.cex=bul.cex, max.w=40)
    sc.text( "Scripts", x=50, y=80, adj=c(0,0), max.w=40, cex=4 )
    get.input()
    bullet.list(list("Simple and specific tasks",
                     "Used once or small number of times",
                     "Interpreted language (not compiled)",
                     "May call external programs",
                     "Quick to write",
                     "Slow to run"), x=50, y=68, t.cex=bul.cex, max.w=40)
}

slides[[4]] <- function(){
    new.slide()
    slide.title("Levels of abstraction")
    get.input()
    sc.text( "Low level", x=10, y=80, adj=c(0,0), max.w=40, cex=4 )
    bullet.list(list("Reflects CPU operations",
                     "Explicit description of memory use",
                     "Small number of simple built in functions",
                     "Slow to write",
                     "Compiled to machine code",
                     "Fast to run"), x=10, y=68, t.cex=bul.cex, max.w=40)
    get.input()
    sc.text( "High level", x=50, y=80, adj=c(0,0), max.w=40, cex=4 )
    bullet.list(list("Built in", list("complex functions", "complex data structures"),
                     "Automatic inference of data types",
                     "Reflects the problem domain",
                     "Quick to write",
                     "Slow to run"), x=50, y=68, t.cex=bul.cex, max.w=40)
}

slides[[5]] <- function(bullets=TRUE){
    new.slide()
    slide.title("Low level drawing of a line")
    if(bullets){
        bullet.list(list("pixel based",
                         "determine which pixels affected",
                         "change the colour of each pixel",
                         "update screen"),
                    t.cex=bul.cex, x=10, y=80, max.w=40)
        get.input()
    }
    asp <- with(par(), (pin[1]/pin[2]) / ((usr[2]-usr[1])/(usr[4]-usr[3])))
    grid.x <- 55:95
    grid.y <- 20 + 1:40 * asp
    segments(grid.x, min(grid.y), grid.x, max(grid.y))
    segments(min(grid.x), grid.y, max(grid.x), grid.y)
    invisible(list(x=grid.x, y=grid.y, asp=asp))
}

slides[[6]] <- function(){
    grid <- slides[[5]](bullets=FALSE)
    sc.text("draw line from (x1,y1) to (x2,y2)", 10, y=85, adj=c(0,0), cex=2, max.w=40)
    get.input()
    bullet.list( list("n = max( abs(x2-x1), abs(y2-y1) )",
                      "for each value of i in range 0:n",
                      list("x = x1 + (x2 - x1) * i",
                           "y = y1 + (y2 - y1) * i",
                           "pixel[x,y] = black"),
                      "refresh display buffer"),
                t.cex=c(2,2), x=10, y=80, max.w=40,
                bullet=FALSE)
    sc.text("pixel : a direct memory buffer")
}

slides[[7]] <- function(){
    grid <- slides[[5]](bullets=FALSE)
    sc.text("draw line from (x1,y1) to (x2,y2)", 10, y=85, adj=c(0,0), cex=2, max.w=40)
    get.input()
    pixels <- as.raster(matrix(1, ncol=length(grid$x)-1, nrow=(length(grid$y)-1)))
##    rasterImage(pixels, grid$x[1], grid$y[1], max(grid$x), max(grid$y))
    bullet.list( list("x1 <- 5; y1 <- 10",
                      "x2 <- 20; y2 <-30",
                      "n <- max( abs(x2-x1), abs(y2-y1) )",
                      "for( i in 0:n ){",
                      "   x <- x1 + (x2 - x1) * i/n",
                      "   y <- y1 + (y2 - y1) * i/n",
                      "   pixels[x,y] <- \"#000000\"",
                      "}",
                      "rasterImage(pixels)"),
                t.cex=c(2,2), x=10, y=80, max.w=40, bullet=FALSE, family="Hack", line.spc=1.5)
    x1 <- 5; y1 <- 10
    x2 <- 20; y2 <- 30
    n <- max( abs(x2-x1), abs(y2-y1) )
    for(i in 0:n){
        x <- x1 + (x2-x1) * i/n
        y <- y1 + (y2-y1) * i/n
        pixels[x, y] <- "#000000"
    }
    rasterImage(pixels, grid$x[1], grid$y[1], max(grid$x), max(grid$y))
    segments(grid$x, min(grid$y), grid$x, max(grid$y))
    segments(min(grid$x), grid$y, max(grid$x), grid$y)
    sc.text("pixel : a direct memory buffer", x=10, y=10, adj=c(0,1), cex=2)
}



slides[[8]] <- function(){
    new.slide()
    slide.title("A data model")
    bullet.list(list("Numbers",
                     list("binary encoded as fixed width words of 8, 16, 32 or 64 bits"),
                     "Text",
                     list("represented as sequences of (meaningless) numbers")),
                10, 80)
    sc.text( "Fundamentally all models are composed of a bunch of numbers and some implied relationships", 
            x=10, y=10, adj=c(0,0), cex=2)
}

num.to.bin <- function(v, bits=8){
    sapply(v, function(x){
        paste( ifelse(bitwAnd( 2^(1:bits - 1), x), 1, 0), collapse="" )
    })
}

slides[[9]] <- function(){
    new.slide()
    slide.title("Representing numbers")
    bullet.list(list("Integers",
                     list("signed / unsigned",
                          "8, 16, 32, 64 bits",
                          "hold up to:\n256, 65536, 4.2e9, 1.8e19\ndifferent values")),
                10, 90, max.w=40, t.cex=bul.cex )
    bullet.list(list("Real / floating point",
                     list("variable precision",
                          list("a + b = a\nif a >> b"),
                          "variable encoding\nno standard",
                          "32 or 64 bits",
                          "hold up to:\n4.2e9, 1.8e19\ndifferent values")),
                50, 90, max.w=40, t.cex=bul.cex)
}

slides[[10]] <- function(){
    new.slide()
    slide.title("ASCII: a simple text model")
    ascii <-
        "          2 3 4 5 6 7       30 40 50 60 70 80 90 100 110 120
        -------------      ---------------------------------
       0:   0 @ P ` p     0:    (  2  <  F  P  Z  d   n   x
       1: ! 1 A Q a q     1:    )  3  =  G  Q  [  e   o   y
       2: \" 2 B R b r     2:    *  4  >  H  R  \\  f   p   z
       3: # 3 C S c s     3: !  +  5  ?  I  S  ]  g   q   {
       4: $ 4 D T d t     4: \"  ,  6  @  J  T  ^  h   r   |
       5: % 5 E U e u     5: #  -  7  A  K  U  _  i   s   }
       6: & 6 F V f v     6: $  .  8  B  L  V  `  j   t   ~
       7: ' 7 G W g w     7: %  /  9  C  M  W  a  k   u  DEL
       8: ( 8 H X h x     8: &  0  :  D  N  X  b  l   v
       9: ) 9 I Y i y     9: '  1  ;  E  O  Y  c  m   w
       A: * : J Z j z
       B: + ; K [ k {
       C: , < L \\ l |
       D: - = M ] m }
       E: . > N ^ n ~
       F: / ? O _ o DEL";

    pos1 <- sc.text(ascii, 10, 90, cex=1.5, family="Hack", adj=c(0,1))
    get.input()
    pos2 <- with(pos1, sc.text("simple", 5, y - (h+10), cex=2, adj=c(0,0.5)))
    with(pos2, arrows( x+w*1.2, y, x + w + 5 - 0.2*w, y, lwd=2 ))
    pos3 <- with(pos2, sc.text(paste(utf8ToInt("simple"), collapse=" "), x + w + 5, y, cex=2, adj=c(0,0.5), family="Hack"))
    get.input()
    with(pos2, arrows( x+w*1.2, y-5, x + w + 5 - 0.2*w, y-5, lwd=2 ))
    pos4 <- with(pos2, sc.text(paste(as.hexmode(utf8ToInt("simple")), collapse="  "), x + w + 5, y-5, cex=2, adj=c(0,0.5), family="Hack"))
    get.input()
    with(pos2, arrows( x+w*1.2, y-5, x + w + 5 - 0.2*w, y-10, lwd=2 ))
    pos5 <- with(pos2, sc.text(paste(num.to.bin(utf8ToInt("simple")), collapse="  "), x + w + 5, y-10, cex=2, adj=c(0,0.5), family="Hack"))
    get.input()
    sc.text("sequences of meaningless numbers", y=2, adj=c(0.5, 0), cex=1.5)
}

slides[[11]] <- function(question=TRUE){
    new.slide()
    slide.title("A model of a gene")
    g.y <- 85
    ex.h <- 2
    ex.pos <- c(10, 30, 43, 50, 80)
    ex.w <- c(5, 4, 3, 8, 15)
    ex.col <- rgb(0.4, 0.3, 0.8, 1)
    lines( c(0,100), c(g.y, g.y) )
    rect(ex.pos, g.y-2, ex.pos+ex.w, g.y+2, border=NA, col=ex.col)
    seq <- sample(c('A', 'C', 'G', 'T'), 100, replace=TRUE)
    seq.cex <- 1
    while( strwidth( 'A', cex=seq.cex, family="Mono") > 1 ){
        seq.cex <- seq.cex * (0.01 / strwidth( 'A', cex=seq.cex, family="Mono"))
    }
    text( 1:100, g.y - ex.h*1.2, seq, cex=seq.cex, family="Mono", adj=c(1.2, 1))
    if(question){
        get.input()
        sc.text("How to represent this gene?", cex=4)
    }
}

slides[[12]] <- function(){
    slides[[6]](question=FALSE)
    bullet.list( list("A string",
                      list("a sequence of small numbers"),
                      "Positions of exon starts",
                      list("a sequence of numbers"),
                      "Lengths of exons",
                      list("a sequence of numbers")),
                10, 70, t.cex=bul.cex, max.w=40)
    get.input()
    pos <- bullet.list( list("Variables",
                      list("sequence",
                           "exon starts",
                           "exon lengths")),
                      50, 70, t.cex=bul.cex, max.w=40)
    get.input()
    bullet.list( list("Variable quantities",
                      list("Sequence length",
                           "Number of exons")),
                50, min(pos$y)-5, t.cex=bul.cex, max.w=40)
}

slides[[13]] <- function(){
    slides[[6]](question=FALSE)
    sc.text("Where do we get the data from?", cex=4)
}

