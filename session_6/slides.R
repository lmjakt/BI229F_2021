

slides[[1]] <- function(){
    new.slide()
    slide.title("Scripts and programs")
    sc.text( "Automating simple to complex tasks", cex=4)
}

slides[[2]] <- function(){
    new.slide()
    slide.title("What is a program?")
    bullet.list(list("A detailed set of instructions",
                     "That manipulate a data model"
                     ),
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
    get.input()
    sc.text( "Scripts", x=50, y=80, adj=c(0,0), max.w=40, cex=4 )
    bullet.list(list("Simple and specific tasks",
                     "Used once or small number of times",
                     "Interpreted language (not compiled)",
                     "May call external programs",
                     "Quick to write",
                     "Slow to run"), x=50, y=68, t.cex=bul.cex, max.w=40)
    get.input()
    sc.text( "No clear distinction", y=0, cex=2 )
}

slides[[4]] <- function(){
    new.slide()
    slide.title("Levels of abstraction")
    get.input()
    sc.text( "Low level", x=10, y=80, adj=c(0,0), max.w=38, cex=4 )
    bullet.list(list("Reflects CPU operations",
                     "Explicit allocation of memory used (amount and type)",
                     "Small number of simple built in functions",
                     "Slow to write",
                     "Compiled to machine code",
                     "Fast to run"), x=10, y=68, t.cex=c(3,2.5,2), max.w=40)
    get.input()
    sc.text( "High level", x=50, y=80, adj=c(0,0), max.w=38, cex=4 )
    bullet.list(list("Built in", list("complex functions", "complex data structures"),
                     "Automatic inference of data types",
                     "Reflects the problem domain",
                     "Quick to write",
                     "Slow to run"), x=50, y=68, t.cex=c(3,2.5,2), max.w=40)
    sc.text("Broad generalisations", y=0, cex=2)
}

slides[[5]] <- function(bullets=TRUE, main="Low level drawing of a line"){
    new.slide()
    slide.title(main)
    if(bullets){
        bullet.list(list("pixel based",
                         "need to determine which pixels affected",
                         "change the colour of each pixel",
                         "update screen"),
                    t.cex=bul.cex, x=10, y=80, max.w=40, bullet=FALSE)
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
                           "pixels[x,y] = black"),
                      "refresh display buffer"),
                t.cex=c(2,2), x=10, y=80, max.w=40,
                bullet=FALSE)
    sc.text("pixels points to a memory buffer that\nwill be passed to the graphics card", x=10, y=10, adj=c(0,1), cex=2)
}

slides[[7]] <- function(){
    grid <- slides[[5]](bullets=FALSE, main="low level in R!")
    sc.text("draw line from (x1,y1) to (x2,y2)", 10, y=85, adj=c(0,0), cex=2, max.w=40)
    get.input()
    pixels <- as.raster(matrix(rgb(1,1,1,0), ncol=length(grid$x)-1, nrow=(length(grid$y)-1)))
    ##    rasterImage(pixels, grid$x[1], grid$y[1], max(grid$x), max(grid$y))
    code  <- readLines("code_snippets.R")[5:15]
    code.col  <- coloriseR(code)
    pos  <- draw.code(code.col, 10, 80, cex=2, family="hack")
    x1 <- 5; y1 <- 10
    x2 <- 20; y2 <- 30
    n <- max( abs(x2-x1), abs(y2-y1) )
    for(i in 0:n){
        x <- x1 + (x2-x1) * i/n
        y <- y1 + (y2-y1) * i/n
        pixels[x, y] <- "#000000"
    }
    get.input()
    rasterImage(pixels, grid$x[1], grid$y[1], max(grid$x), max(grid$y))
    segments(grid$x, min(grid$y), grid$x, max(grid$y))
    segments(min(grid$x), grid$y, max(grid$x), grid$y)
    sc.text("pixels points to a memory buffer that\nwill be passed to the graphics card",
            x=10, y=10, adj=c(0,1), cex=2)
    sc.text("Line is upside down!", x=75, y=10, adj=c(0.5,1), cex=2)
}

slides[[8]]  <- function(){
    new.slide()
    slide.title("High level drawing of a line")
    sc.text( "segments(5, 10, 20, 30, lwd=3)", y=10, x=10, adj=c(0,0), cex=2.5,
            family="hack")
    plot.window(xlim=c(0,50), ylim=c(-10,50), asp=1)
    segments(5, 10, 20, 30, lwd=3)
}

slides[[9]] <- function(){
    new.slide()
    slide.title("Representing data")
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
        paste( ifelse(bitwAnd( 2^(bits:1 - 1), x), 1, 0), collapse="" )
    })
}

slides[[10]] <- function(){
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

slides[[11]] <- function(){
    new.slide()
    slide.title("ASCII: a simple text encoding")
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

slides[[12]]  <- function(){
    new.slide()
    slide.title("Why hexadecimal?")
    pos1  <- sc.text("Maps (relatively) easily to binary", x=10, y=90, cex=3, adj=c(0,1))
    pos2 <- with(pos1, sc.text("decimal    ", 5, y - (h+10), cex=2, adj=c(0,0.5),
                               family='Hack'))
    with(pos2, arrows( x+w*1.2, y, x + 2*w - 0.2*w, y, lwd=2 ))
    pos3 <- with(pos2, sc.text(paste(utf8ToInt("simple"), collapse=" "),
                               x + 2*w, y, cex=2, adj=c(0,0.5), family="Hack"))
    with(pos1, sc.text("hexadecimal", 5, y-(h+15), cex=2, adj=c(0,0.5)))
    with(pos2, arrows( x+w*1.2, y-5, x + 2 * w - 0.2*w, y-5, lwd=2 ))
    pos4 <- with(pos2, sc.text(paste(as.hexmode(utf8ToInt("simple")), collapse="  "),
                               x + 2*w, y-5, cex=2, adj=c(0,0.5), family="Hack"))
    with(pos1, sc.text("binary", 5, y-(h+20), cex=2, adj=c(0,0.5)))
    with(pos2, arrows( x+w*1.2, y-10, x + 2*w - 0.2*w, y-10, lwd=2 ))
    pos5 <- with(pos2, sc.text(paste(num.to.bin(utf8ToInt("simple")), collapse="  "),
                               x + 2*w, y-10, cex=2, adj=c(0,0.5), family="Hack"))
    hnums  <- as.hexmode(utf8ToInt("simple"))
    bnums  <- num.to.bin(utf8ToInt("simple"))
    cw  <- strwidth( 'A', cex=2, family='hack' )
    ch  <- strheight( 'A', cex=2, family='hack' )
    x  <- 20
    y  <- 50
    text( x, y, hnums[1], cex=2, family='hack' )
    text( x-3*cw, y-3*ch, substring(bnums[1], 1, 4), cex=2, family='hack' )
    text( x+3*cw, y-3*ch, substring(bnums[1], 5, 8), cex=2, family='hack' )
    arrows( c(x-cw/2,x+cw/2), y-ch*0.8, c(x-3*cw, x+3*cw), y-2*ch )
    x  <- 40
    y  <- 50
    text( x, y, hnums[2], cex=2, family='hack' )
    text( x-3*cw, y-3*ch, substring(bnums[2], 1, 4), cex=2, family='hack' )
    text( x+3*cw, y-3*ch, substring(bnums[2], 5, 8), cex=2, family='hack' )
    arrows( c(x-cw/2,x+cw/2), y-ch*0.8, c(x-3*cw, x+3*cw), y-2*ch )
    x  <- 60
    y  <- 50
    text( x, y, hnums[3], cex=2, family='hack' )
    text( x-3*cw, y-3*ch, substring(bnums[3], 1, 4), cex=2, family='hack' )
    text( x+3*cw, y-3*ch, substring(bnums[3], 5, 8), cex=2, family='hack' )
    arrows( c(x-cw/2,x+cw/2), y-ch*0.8, c(x-3*cw, x+3*cw), y-2*ch )
}


slides[[13]] <- function(question=TRUE){
    new.slide()
    slide.title("A data model of a gene")
    g.y <- 85
    ex.h <- 2
    ex.pos <- c(10, 30, 43, 50, 80)
    ex.w <- c(5, 4, 3, 8, 15)
    ex.col <- rgb(0.4, 0.3, 0.8, 1)
    lines( c(0,100), c(g.y, g.y) )
    rect(ex.pos, g.y-2, ex.pos+ex.w, g.y+2, border=NA, col=ex.col)
    lines( c(ex.pos[1], ex.pos[1], ex.pos[1]+2), c(g.y, g.y+ex.h*2, g.y+ex.h*2))
    arrows( ex.pos[1], g.y+ex.h*2, ex.pos[1]+2 )
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

slides[[14]] <- function(){
    slides[[13]](question=FALSE)
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

slides[[15]] <- function(){
    slides[[13]](question=FALSE)
    sc.text("Where do we get the data from?", cex=4)
}

slides[[16]] <- function(){
    slides[[13]](question=FALSE)
    sc.text("In this case:", cex=2, y=70, x=10, adj=c(0,0))
    code  <- readLines("code_snippets.R")[1:3]
    code.col  <- coloriseR(code)
    pos  <- draw.code(code.col, 10, 60, cex=2)
    get.input()
    sc.text("Hard coded into the source code\ngenerally useless\n\nNormally would be read from a file or database",
            cex=2, y=min(pos$pos[,'y']) - (pos$lheight + 5),
                         x=10, adj=c(0,1))
}

slides[[17]] <- function(){
    slides[[13]](question=FALSE)
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

slides[[18]]  <- function(){
    new.slide()
    slide.title("The code behind the previous slide")
    code  <- readLines("code_snippets.R")[18:36]
    code.col  <- coloriseR(code)
    pos  <- draw.code( code.col, 10, 90, cex=1.5, family='hack' )
    sc.text( "Generally useless\nalways does the same thing\nTakes no arguments (no input?)",
            x=20, y=3, cex=2, adj=c(0,0))
}

slides[[18]]  <- function(){
    new.slide()
    slide.title("General types of variables")
    sc.text("Generally:", x=10, y=85, adj=c(0,0), cex=3, max.w=40 )
    bullet.list(list("Scalars", list("Individual values"),
                     "Vectors",
                     list("Ordered sequences of values", "Accessed by position in list"),
                     "Maps",
                     list("Key-value pairs", "Accessed by key")),
                x=10, y=80, t.cex=bul.cex, max.w=40)
    get.input()
    sc.text("In R:", x=55, y=85, adj=c(0,0), cex=3, max.w=40 )
    bullet.list(list("Vector", list("most simple data type"),
                     "Matrix", list("2 dimensional vector"),
                     "Array", list("n-dimensional vector"),
                     "list", list("a special kind of vector"),
                     "name attributes",
                     list("no native map, but all elements can be named")),
                x=55, y=80, t.cex=bul.cex, max.w=40)
    sc.text("These variable types are called different things in different languages",
            y=10, adj=c(0.5, 0), cex=2)
}

slides[[19]]  <- function(){
    new.slide()
    slide.title( "Values of variables" )
    sc.text("obtained from:", x=10, y=84, adj=c(0,0), cex=2)
    bullet.list(list("arguments to program",
                     "arguments to functions",
                     "read from:",
                     list("files", "databases", "interactive input"),
                     "written in source (bad!)",
                     "calculated from other variables"),
                x=10, y=80, t.cex=bul.cex)
}

slides[[20]]  <- function(){
    new.slide()
    slide.title("Variable examples in R")
    sc.text("Vectors; the simplest data type in R", x=10, y=90, adj=c(0,1), cex=2)
    code  <- readLines("code_snippets.R")[38:54]
    code.col  <- coloriseR(code)
    draw.code( code.col, 10, 80, cex=2, family='Hack')
}

slides[[21]]  <- function(){
    new.slide()
    slide.title("Vectorised operations in R")
    sc.text("like in linear algebra", x=10, y=90, adj=c(0,1), cex=2)
    code  <- readLines("code_snippets.R")[56:74]
    code.col  <- coloriseR(code)
    draw.code( code.col, 10, 80, cex=1.8, family='Hack' )
    get.input()
    sc.text("You should be able to\nunderstand what is going on here",
            max.w=40, x=55, y=70, adj=c(0,1), cex=2)
}

slides[[22]]  <- function(){
    new.slide()
    slide.title("The basic building blocks")
    bullet.list(list("variables",
                     list("hold or point to data",
                          "variable length"),
                     "conditionals",
                     list("different code run based on variable values"),
                     "loops",
                     list("code run repeatedly", "no. of repeats data dependant"),
                     "function definition",
                     "external interaction",
                     list("read and write files")),
                x=10, y=80, t.cex=bul.cex, line.spc=1.5, max.w=40)
}


slides[[23]]  <- function(){
    new.slide()
    slide.title("Conditional statements")
    code  <- readLines("code_snippets.R")[76:84]
    code.col  <- coloriseR(code)
    pos  <- draw.code( code.col, 10, 80, cex=2, family='Hack' )
    sc.text("Conditional statements depend\non expressions that evaluate to\nTRUE or FALSE",
            x=50, y=80, adj=c(0,1), cex=2)
}

slides[[24]]  <- function(){
    new.slide()
    slide.title("TRUE or FALSE")
    sc.text("logical values. Obtained from:", x=10, y=85, adj=c(0,0), cex=3)
    bullet.list(list("Comparisons:",
                     list("> => <= < =="),
                     "Value coercion",
                     list("0 -> FALSE",
                          "!0 -> TRUE",
                          "in R, only numeric values can be coerced"),
                     "From functions that return",
                     list("logical values (TRUE / FALSE)",
                          "numeric values (can be coerced)")),
                x=10, y=80, t.cex=bul.cex)
}

slides[[25]]  <- function(){
    new.slide()
    slide.title("vectors and conditionals in R")
    sc.text("logical vectors can subset vectors", x=10, y=85, adj=c(0,0), cex=3)
    code  <- readLines("code_snippets.R")[86:101]
    code.col  <- coloriseR(code)
    pos  <- draw.code( code.col, 10, 80, cex=2, family='Hack' )
}

slides[[26]]  <- function(){
    new.slide()
    slide.title("Boolean operations in R")
    bullet.list(list("A && B",
                     list("combines two single logical values",
                          "TRUE if A and B TRUE",
                          "else FALSE"),
                     "A || B",
                     list("combines two single logical values",
                          "FALSE if A and B FALSE",
                          "else TRUE"),
                     "A & B",
                     list("elementwise AND combination of vector A and B",
                          "Returns a vector of the longer of A and B"),
                     "A | B",
                     list("elementwise OR combination of vector A and B"),
                     "xor(A, B)",
                     list("elementwie exclusive OR of vector A and B",
                          "TRUE for each pair of elements where exactly one element is TRUE"),
                     "!A", list("Negates A", "TRUE if A is FALSE")),
                x=10, y=90, t.cex=bul.cex, max.w=60, line.spc=1.25)
}

slides[[27]]  <- function(){
    new.slide()
    slide.title("Boolean operations in R")
    code  <- readLines("code_snippets.R")[185:206]
    code.col  <- coloriseR(code)
    pos  <- draw.code( code.col, 10, 95, cex=1.8, family='Hack' )
}

slides[[28]]  <- function(){
    new.slide()
    slide.title("Loops")
    sc.text("Two basic types", cex=3, x=10, y=85, adj=c(0,0))
    bullet.list( list("for",
                      list("for each value in a sequence",
                           list("do something with value")),
                      "while",
                      list("while condition is TRUE",
                           list("do something",
                                "that changes",
                                "the evaluation of the condition")
                           )),
                x=10, y=80, bullet=FALSE, prefix.style="d", prefix.sep=". ")
}

slides[[29]]  <- function(){
    new.slide()
    slide.title("For loops in R")
    code  <- readLines("code_snippets.R")[103:122]
    code.col  <- coloriseR(code)
    pos  <- draw.code( code.col, 10, 90, cex=2, family='Hack' )
}

slides[[30]]  <- function(){
    new.slide()
    slide.title("While loops in R")
    code  <- readLines("code_snippets.R")[124:147]
    code.col  <- coloriseR(code)
    pos  <- draw.code( code.col, 10, 95, cex=1.8, family='Hack' )
}

slides[[31]]  <- function(){
    new.slide()
    slide.title("Other languages")
    sc.text("Have more interesting loop constructs", x=10, y=80, adj=c(0,0), cex=3)
    sc.text("for(int i=0; i < n; ++i)", y=50, x=10, adj=c(0,0), cex=3, family='Hack')
}

slides[[32]]  <- function(){
    new.slide()
    slide.title("More modern approaches")
    sc.text("Apply and map like statements", x=10, y=90, cex=3, adj=c(0,0))
    sc.text("run a function on every\nelement of a collection",
            x=10, y=70, cex=3, adj=c(0,0))
    code  <- readLines("code_snippets.R")[149:158]
    code.col  <- coloriseR(code)
    pos  <- draw.code( code.col, 10, 60, cex=1.8, family='Hack' )
    sc.text("but difficult to use sapply to calculate the sum",
            x=10, y=5, adj=c(0,0), cex=3)
}

slides[[33]]  <- function(){
    new.slide()
    slide.title("More apply functions")
    sc.text("You should also be familiar with",
            10, 90, cex=3, adj=c(0,0))
    bullet.list(list("apply",
                     list("applies function to rows or columns of matrices"),
                     "lapply",
                     list("applies function to vectors or lists. Always returns a list"),
                     "sapply",
                     list("like lapply, but tries to simplify result to vector or matrix"),
                     "tapply",
                     list("applies function to subsets of a vector grouped by an index")),
                10, 80, t.cex=bul.cex, max.w=60)
}

slides[[34]]  <- function(){
    new.slide()
    slide.title("What are these 'function' things?")
    bullet.list(list("A function:",
                     list("a block of code that can be invoked from elsewhere in the code",
                          "code that is only run when invoked elsewhere in the code",
                          "may have its own scope (namespace)",
                          "contains functionality that is required more than once",
                          "usually takes arguments that change what it does")
                     ),
                x=10, y=80, max.w=50, t.cex=bul.cex)
}

slides[[35]]  <- function(){
    new.slide()
    slide.title("Functions in R")
    bullet.list(list("defined by the function function",
                     "behave as normal objects / variables",
                     "called by appending (args) to function name",
                     "can read the callers namespace",
                     "cannot modify the callers namespace",
                     "can define new variables that disappar after end of execution",
                     "usually return a value"),
                x=10, y=80, max.w=50, t.cex=bul.cex)
}

slides[[36]]  <- function(){
    new.slide()
    slide.title("A function example")
    code  <- readLines("code_snippets.R")[160:183]
    code.col  <- coloriseR(code)
    pos  <- draw.code( code.col, 10, 95, cex=1.8, family='Hack' )
}

slides[[37]]  <- function(){
    new.slide()
    slide.title("Arguments to functions")
    sc.text("When you call a function:", cex=3, 10, 80, adj=c(0,0))
    sc.text("sum.within.range(a, 45, 50)", cex=3, 10, 78, adj=c(0,1))
    bullet.list( list("argument values are copied to the function",
                      "available within the function",
                      "via names in argument definition"),
                x=10, y=60, max.w=60, t.cex=bul.cex)
}

slides[[38]]  <- function(){
    new.slide()
    slide.title("debug to understand")
    txt  <- paste("If you call debug on a function",
                  "R will enter the debug mode when",
                  "that function is called",
                  "until the function is modified or",
                  "you call undebug on the function", sep="\n")
    pos  <- sc.text(txt, x=10, y=90, cex=2.5, adj=c(0,1))
    bullet.list(list("allows you to step through each line of code",
                     "inspect values of variables",
                     "run functions on variables",
                     "easier to demonstrate than to describe:"),
                x=10, y=50, t.cex=bul.cex, max.w=50)
}
