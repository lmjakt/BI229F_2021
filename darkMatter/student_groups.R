## The dark matter presentation in R


## we may want to print out the studens names:
## an external dependancy! Sorry about that. The code though
## can be found on github if you know how to look for it.
source("~/R/drawinR/drawing_functions.R")


grid  <- function(v=seq(0, 100, 10), h=v, lty=3, ...){
    abline(v=v, lty=lty)
    abline(h=h, lty=lty)
}

plot.new()
plot.window(xlim=c(0,100), ylim=c(0,100))
sc.text("The future belongs to those who turn up", cex=4)
identify(1,1)
##
plot.new()
plot.window(xlim=c(0,100), ylim=c(0,100))
##grid()
bullet.list(list("When would you like to have your exams?",
                 "When would you like to have the deadline for your projects?"),
            x=15, y=80, max.w=50,
            prefix.style='d')
identify(1,1)
##

plot.new()
plot.window(xlim=c(0,100), ylim=c(0,100))
sc.text("The course teamwork", y=90, cex=4)
##
boxText( c(0, 60, 60, 80), "You will be given:\n\nA set of unidentified sequences obtained by shotgun sequencing of bottom sediment mRNA", min.cex=2)
##
boxText( c(70, 90, 60, 80), "See canvas for the files", max.cex=2)
identify(1,1)
boxText( c(0, 60, 45, 50), "What are they?", min.cex=2)
identify(1,1)
##grid()
bullet.list(list("Artefacts from the sequencing",
                 "coding mRNA",
                 "non-coding mRNA",
                 "DNA contamination"), x=10, y=40)
identify(1,1)
##

plot.new()
plot.window(xlim=c(0,100), ylim=c(0,100))
sc.text("Today's tasks", y=90, cex=4)
bullet.list(list("Form groups", "Define tasks",
                 "Consider:",
                 list("How to read sequences into R",
                      "How to represent sequences in R (i.e. data type)",
                      "What properties to investigate",
                      "How to use R to obtain these properties")),
            x=5, y=80, prefix.style='d', t.cex=c(3,2,1))
identify(1,1)
##
##
## Visualise the procedure:
roles  <- c('MB', 'R', 'stats', 'vis')
max.w  <- 1.5 * max(strwidth(roles, cex=2))
max.h  <- 1.5 * max(strheight(roles, cex=2))
roles.yo  <- seq(0,max.h*3, length.out=4)
teams.x  <- seq(10, 80, length.out=ncol(groups.m))
role.y  <- 80
spec.y  <- 40
##
par(mar=c(2,2,2,2))
plot.new()
plot.window(xlim=c(0,100), ylim=c(0,100))
##abline(v=seq(0,100,10), lty=3)
##abline(h=seq(0,100,10), lty=3)
text( 50, 95, "member roles", pos=1, cex=3)
for(x in teams.x){
    text(x, role.y-roles.yo, roles, adj=c(0,0.5), cex=2)
    rect( x-max.w/4, role.y-roles.yo[4]-max.h, x+max.w, role.y+max.h)
}
text( 50, role.y - (max(roles.yo)+max.h*2), "30 minute discussion", pos=1, cex=3)
identify(1,1)
polygon( arrow.x2(15, 60, 22.5, 47, 2.5, 5, 0.3), col=1)
spec.m  <- matrix(roles, ncol=length(roles), nrow=ncol(groups.m), byrow=TRUE)
spec.x  <- seq(20, 70, length.out=ncol(spec.m))
spec.yo  <- seq(0, max.h * (nrow(spec.m)-1), max.h)
for(i in 1:length(spec.x)){
    x  <- spec.x[i]
    text(x, spec.y-spec.yo, spec.m[,i], cex=2, adj=c(0,0.5))
    rect( x-max.w/4, spec.y-spec.yo[6]-max.h, x+max.w, spec.y+max.h)
}
text( 50, spec.y - (max(spec.yo)+max.h*2), "30 minute discussion", pos=1, cex=3)
identify(1,1)
bez.arrow( cbind(c(78, 90, 105, 105, 88), c(30, 30, 60, 75, 75)), col='grey90' )
boxText(c(80, 100, 45, 60), "reform & report")
identify(1,1)
##
##
plot.new()
plot.window(xlim=c(0,100), ylim=c(0,100))
sc.text("Some hints", y=90, cex=4)
bullet.list(list("The sequences are (supposedly) directional",
                 "Coding potential",
                 "Complexity",
                 "Words (kmers)",
                 "Amino Acid frequency"),
            10,80, max.w=40, t.cex=c(3,2,1))
bullet.list(list("readLines", "nchar", "strsplit", "substring",
                 "hist", "seq", "table", "?"),
            55, 80, max.w=40, line.spc=1.5, t.cex=c(3,2,1))





## divide the students into groups randomly.
## show how this is done.. 
students <- readLines( "students.txt" )
i <- sample(1:length(students))
group.no <- length(i) %/% 4

groups <- tapply( i, 1:length(i) %% group.no, function(i){
    students[ i ] })

groups


plot.new()
plot.window(xlim=c(0,100), ylim=c(0,100))

h  <- 100 / length(groups)
y1  <- seq(100, h, -h)

for(i in 1:length(groups)){
    boxText(c(20, 80, y1[i]-h, y1[i]), paste(groups[[i]], collapse=", "))
}


## maybe better with plotTable
## works because all are the same
groups.m  <- sapply(groups, eval)
colnames(groups.m)  <- 1:ncol(groups.m)


cairo_pdf("team_members.pdf", width=20, height=14)
plot.new()
plot.window(xlim=c(0,100), ylim=c(0,100))
text(50, 90, "Team members", cex=3)
pos1  <- plotTable(0, 80, groups.m[,1:3], cex=2, col.margin=0.25) 
pos2  <- plotTable(0, min(pos$b)-10, groups.m[,4:6], cex=2, col.margin=0.25)
##
memb.x  <- matrix( c(pos1$l, pos2$l), ncol=6, nrow=4, byrow=TRUE)
memb.y  <- matrix(c(rep( (pos1$t[-1] + pos1$b[-1])/2, 3),
                    rep( (pos2$t[-1] + pos2$b[-1])/2, 3)),
                  ncol=ncol(groups.m), nrow=nrow(groups.m))
##
points(memb.x, memb.y)
dev.off()
##present  <- identify(memb.x, memb.y)


