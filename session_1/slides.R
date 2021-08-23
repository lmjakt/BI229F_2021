i <- 0

slides[[1]] <- function(){
    new.slide()
    sc.text("Course Introduction", y=75, adj=c(0.5,0.5), cex=6, col=blue)
    sc.text("Introduction to BI229F", y=50, adj=c(0.5,0.5), cex=4, col=blue)
    sc.text("Autumn 2021", x=90, y=0, adj=c(1, 0), cex=2)
    NULL
}

slides[[2]] <- function(){
    new.slide()
    slide.title('Course structure') ## , cex=4, adj=0, line=0)
    bullet.list( list( c("A weekly mixture of lectures and practicals"),
                      list(c("Tuesday lecture", "Friday practical")),
                      c("Extended practical sessions"),
                      list(c("3-4 hours",
                             "Number and dates to be determined")),
                      c("Mandatory project"),
                      list(c("Coding or data analysis"),
                           c("Designed with your input"))),
                bul.x, bul.y, t.cex=bul.cex)
    NULL
}

slides[[3]] <- function(){
    new.slide()
    slide.title("Introductory course")
    bullet.list( list(c( "Introduction to:"),
                      list(c("Databases", "Tools", "Resources")),
                      c("Details:"),
                      list(c("some Algorithms (eg. sequence alignment)",
                               "some Statistical methods")),
                        c("Practical skills (writing code)"),
                        list(c("Data mangling", "Statistical analysis", "Project management"))
                      ), bul.x, bul.y, t.cex=bul.cex)
    sc.text("Content and schedule may be adjusted as we progress\nSuggestions for changes are welcomed",
            x=bul.x, y=strheight('A', cex=2), cex=2, adj=c(0,0))
    NULL
}

slides[[4]] <- function(){
    new.slide()
    slide.title("Reference material")
    sc.text("There is a book", x=bul.x, y=0, adj=c(0,0), cex=2, max.w=50-bul.x)
    im <- readJPEG("images/book_cover.jpg")
    placeImage(im, 0, 95, h=85)
    boxText(c(50, 95, 0, 30), "Good book,\nbut not that necessary:\nalmost everything can be found on the web", max.cex=3)
    NULL
}

slides[[5]] <- function(...){
    new.slide(...)
    slide.title("Bioinformatics? Genomics?")
    sc.text("What are these things and why do we care?", x=bul.x, y=sub.y, adj=c(0,0), cex=4)
    dim <- bullet.list( list(c("Bioinformatics"),
                             list(c("Development of computational methods for biological data analysis"),
                                  c("Computational analysis of biological data")),
                             c("Genomics"),
                             list(c("The study of genomes"),
                                  list(c("Structure", "Evolution", "..."))),
                             list(c("The use of genomics scale data"),
                                  list(c("Genome wide gene expression data (transcriptomics)",
                                         "Population genomics (eg. identification of selected loci)",
                                         "...")))),
                       x=bul.x, y=bul.y, t.cex=bul.cex)
    sc.text("We care because data is cheap", x=bul.x, y=strheight('A', cex=3), adj=c(0,0), cex=3)
    NULL
}

slides[[6]] <- function(){
    new.slide()
    slide.title("Lots of data")
    boxText(c(10, 90, 50, 80),
            "Advances in technology allow us to define complete genome sequences and to measure the activities of 1000s of genes without spending large amounts of money or time", max.cex=3)
    sc.text( "This makes genomics and bioinformatics useful for almost all biological questions", x=10, y=20, adj=c(0,0), cex=2.5)
    NULL
}

slides[[7]] <- function(...){
    new.slide(...)
    slide.title("How much data?")
    sc.text("http://www.ncbi.nlm.nih.gov/", x=0, y=80, cex=2, col=blue, adj=c(0,0))
    sc.text("Has the answer", x=0, y=78, cex=2, adj=c(0,1))
    ## im1 <- readPNG("images/entrez_2020_pd.png")
    ## im2 <- readPNG("images/entrez_genomes_2020_pd.png")
    ## get.input()
    ## placeImage(im1, 25, 85)
    ## get.input()
    ## placeImage(im2, 30, 75)
    NULL
}

slides[[8]] <- function(...){
    ##    new.slide(...)
    if(!int.dev())
        slides[[ 7 ]](clear=TRUE) 
    im1 <- readPNG("images/entrez_2020_pd.png")
    placeImage(im1, 25, 85)
    NULL
}

slides[[9]] <- function(...){
    ##    new.slide(...)
    if(!int.dev())
        slides[[ 8 ]](clear=TRUE) 
    im2 <- readPNG("images/entrez_genomes_2020_pd.png")
    placeImage(im2, 30, 75)
    NULL
}


slides[[10]] <- function(){
    par(oma=par('mar'))
    layout(matrix(1:2,nrow=1), widths=c(0.5,0.5))
    plot.new()
    slide.title("Change over time", outer=TRUE)
    ## we will have four different axis so we will need more space
    par(mar=c(5.1, 5.1, 5.1, 5.1))
    plot.window(xlim=range(py.range), ylim=range(py.counts[,'nucleotide']))
    box()
    axis(1)
    plot.py <- function(column, col, ax.pos, ax.line, leg.x=0.05, leg.y=0.95){
        plot.window(xlim=range(py.range), ylim=range(py.counts[,column]))
        axis(ax.pos, line=ax.line, col.axis=col)
        points(py.range, py.counts[,column], type='b', col=col, lwd=3)
        sc.text(column, leg.x, leg.y, adj=c(0,1), col=col, npc=TRUE, cex=1.5)
    }
    cds <- plot.py( 'nucleotide', 'black', 2, 0 )
    get.input()
    cds <- plot.py( 'genome', red, 2, 2.5, leg.y=cds$npy - cds$nph*1.5 )
    get.input()
    cds <- plot.py( 'sra', blue, 4, 0, leg.y=cds$npy - cds$nph*1.5 )
    get.input()
    plot.py( 'assembly', green, 4, 2.5, leg.y=cds$npy - cds$nph*1.5 )
    par(mar=c(5.1, 0, 5.1, 2.1))
    new.slide()
    r.code <- readLines("pub_counts.R")
    r.col <- coloriseR(r.code)
    get.input()
    draw.code.box(r.col, 7.5, 90, 90, 90, family='Hack', cex=1, moderation=1)
    bez.arrow( pts=cbind(c(30, 30, 15, 0), c(90, 95, 95, 95)), col=blue, border=NA, bt.n=50 )
    sc.text("A bit of R:", 32, 92, max.w=70, cex=2, adj=c(0,1))
    NULL
}

slides[[11]] <- function(){
    new.slide()
    slide.title("Course topics")
    topics <- rbind(c("Molecular Biology", "Information storage (DNA), transmission (RNA), functional molecules (RNA & proteins)"),
                    c("Practical bioinformatics", "Resources and tools for looking at sequences and other data"),
                    c("Algorithms", "Sequence alignment, database search"),
                    c("Computers", "Hardware, operating systems, networks, applications"),
                    c("Big(ish) data analysis", "Visualisation and analysis of large data sets"),
                    c("Statistics", "Derivation of p-values and multiple testing"),
                    c("Doing the above", "i.e. Programming"),
                    c("Genomes & transcriptomes", "Structure and other properties"))
    tmp <- plotTable(10, 90, topics, c.widths=c(15, 45), column.bg=c(rgb(0.8, 0.8, 0.8,0.3), rgb(0.9, 0.9, 0.9,0.3)),
                     row.bg=c(rgb(0,0,0,0), rgb(0.5,0.5,0.5,0.2)),
                     text.col=c(blue, 'black'), text.adj=rbind(c(0,1), c(0,1)), font=c(2,1), cex=2.25, family="Arial",
                     row.margin=2)
    sc.text( "With adjustments along the way if necessary", 5, 5, cex=1.5, adj=c(0,0))
    NULL
}

slides[[12]] <- function(...){
    new.slide(...)
    slide.title("Course objectives (1)")
    bullet.list( list("Data handling (genomics / bioinformatics data types)",
                      list("General data formats (eg. text / binary)",
                           "Specific data formats (sequences, alignments, etc)",
                           "Import / parsing of data"),
                      "Selected bioinformatics algorithms",
                      "Sources of information (databases)",
                      "Data visualisation",
                      "Data analysis (statistical tests)"),
                x=bul.x, y=bul.y, t.cex=bul.cex )
    NULL
}

slides[[13]] <- function(...){
    new.slide(...)
    slide.title("Course objectives (2)")
    bullet.list( list("Computational skills",
                      list("File systems",
                           "General purpose programming (R!?*^%$)",
                           "Data extraction and munging",
                           "Method implementation")),
                x=bul.x, y=bul.y, t.cex=bul.cex )
    sc.text( "Learnt from programming exercises", x=bul.x, y=strheight("A", cex=3), adj=c(0, 0), cex=3)
    NULL
}
                           
slides[[14]] <- function(...){
    new.slide(...)
    slide.title("Course objectives (3)")
    bullet.list( list("Genomes",
                      list("Anatomy (content)",
                           "Genes",
                           "Evolution of",
                           "Types (nuclear, organellular)"),
                      "Transcriptomes",
                      list("Structure of (distribution)",
                           "Differential expression")),
                x=bul.x, y=bul.y, t.cex=bul.cex)
    NULL
}
                      
slides[[15]] <- function(...){
    new.slide(...)
    slide.title("A practical approach")
    r1 <- c(10, 30, 40, 60)
    boxText(r1,
            "Environmental sequences", max.cex=3)
    get.input()
    polygon(arrow.x2( 32, 50, 45, 50, 3, 6, 0.5 ))
    bullet.list( list("Sequence origin?",
                      "Functional roles?",
                      "Orthology?",
                      "Set properties"),
                x=50, y=65, t.cex=bul.cex)
    get.input()
    sc.text( "Analysis of sequences in R", y=strheight("A", cex=3), cex=3, adj=c(0.5, 0))
    NULL
}
                
    

slides[[16]] <- function(){
    new.slide()
    slide.title("Tentative timetable")
    weeks <- c(as.numeric( rbind(34:45, NA )), NA, NA)
    days <- c(rep(c("Tue", "Fri"), length(weeks)/2))
    days[ (length(days)-1):length(days) ] <- NA
    dates <- c(24,27,31,03,07,10,14,17,21,24,28,01,05,08,12,15,19,22,26,29,02,05,09,12, NA, NA)
    months <- c(rep('Aug', 3), rep('Sep', 8), rep('Oct', 9), rep('Nov', 4), NA, NA)
    description <- c("Course introduction & discussion", "Molecular biology review",
                     "Introduction to R/Rstudio", "Dark matter sequences (practical intro)",
                     "Pairwise alignment", "Implementing a pairwise alignment in R",
                     "Multiple sequence alignment", "Running MSA's in R",
                     "Genome structures", "Genome structure analysis",
                     "Writing scripts and programs", "Programming exercises",
                     "Dark matter resumed", "Dark matter continued",
                     "Biological databases", "Identifying sequences (practical)",
                     "Dark matter presentations", "Dark matter presentations",
                     "Genomics & statistics", "Playing with numbers",
                     "Sequence data to p-values: differential gene expression", "Obtaining and interpreting p-values (practical)",
                     "Questions and comments (1)", "Questions and comments (2)",
                     "Computers", "An introduction to Unix & Linux")
    ttable <- data.frame(Week=weeks,
                         Day=days,
                         Month=months,
                         Date=dates,
                         Description=description)
    bgs <- c(rgb(1,1,1), rgb(0.9,0.9,0.9), rgb(0.95, 0.95, 0.95))
    row.bg <- c(bgs[1], rep(c(rep(bgs[2], 2), rep(bgs[3], 2)), nrow(ttable)/2) )
    col.bg <- NA
    tmp <- plotTable(5, 95, ttable, c.widths=c(5, 5, 5, 5, 45), column.bg=NA,
                     row.bg=row.bg,
                     text.adj=c(0,1), cex=1.5, family="Arial",
                     row.margin=1)
    segments(tmp$l[1], tmp$b[1], max(tmp$r), col='black', lwd=2)
    NULL
}

slides[[17]] <- function(...){
    new.slide(...)
    sc.text("Some questions for you", cex=4)
}

slides[[18]] <- function(...){
    new.slide(...)
    slide.title("Molecular biology questions")
    dim <- bullet.list( list("What is the most common type of RNA molecule?",
                             "How many different ways can you translate\nATGGTACTATAA ?",
                             "And how about\nAUGGUACUAUAA ?",
                             "What is the difference between RNA and DNA?",
                             "What is a gene?",
                             "Name an important consequence of double-strandedness?",
                             "How many different codons are there?",
                             "What are histones?",
                             "What is gene expression?"),
                       x=bul.x, y=bul.y, t.cex=bul.cex )
    NULL
}

slides[[19]] <- function(...){
    new.slide(...)
    slide.title("Bioinformatics experience")
    dim <- bullet.list( list("What is global and local alignment?",
                             "How many of you have used BLAST?",
                             "What is the problem with multiple sequence alignment?",
                             "How do we estimate gene expression from RNA sequencing data?",
                             "Are you familiar with: fasta, fastq, sam and bam files?",
                             "Why is the following funny?",
                             list("There are 10 types of people in the world",
                                  list("Those who understand binary", "And those who don't")),
                             "How many of you have written shell scripts?"),
                       x=bul.x, y=bul.y, t.cex=bul.cex )
    NULL
}

slides[[20]] <- function(...){
    par(oma=par('mar'))
    x <- seq(-5, 5, 0.1)
    y1 <- dnorm(x)
    y2 <- dlnorm(x)
    par(mfrow=c(1,2))
    plot(x, y2, type='l', col=red, lwd=3, xlab='x', ylab='y', new=FALSE)
    lines(x, y1, type='l', col=blue, lwd=3)
    new.slide()
    slide.title("Distributions", outer=TRUE)
    sc.text( "What are these?", x=0, y=60, cex=3, adj=c(0,0) )
    sc.text( "What kind of processes give\nrise to them?", x=0, y=40, cex=3, adj=c(0,0) )
    NULL
}

slides[[21]] <- function(...){
    R1 <- c("for(i in 1:10){",
                "   cat(paste(i, i^2, sep='\\t'), '\\n')",
                "}")
    R2 <- c("f1 <- function(x){",
                "   sum(x) / length(x)",
                "}")
    R3 <- c("f2 <- function(x){",
                "   sort(x)[ length(x) / 2 ]",
                "}")
    R1.c <- coloriseR(R1)
    R2.c <- coloriseR(R2)
    R3.c <- coloriseR(R3)
    new.slide()
    slide.title("R")
    left <- 5
    width <- 75
    height <- 30
    draw.code.box(R1.c, left, 80, width=width, height=height, cex=2, family='Monospace')
    draw.code.box(R2.c, left, 55, width=width, height=height, cex=2, family="Monospace")
    draw.code.box(R3.c, left, 30, width=width, height=height, cex=2, family="Monospace")
    sc.text("What do these do?", y=strheight('A', cex=2), cex=2)
    NULL
}

slides[[22]] <- function(...){
    new.slide()
    slide.title("Main questions")
    bullet.list(list("Why have you selected this course?",
                     "What do you hope to get out of it?"),
                x=bul.x, y=bul.y-20, t.cex=bul.cex)
    NULL
}
