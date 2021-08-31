## divide the students into groups randomly.

students <- readLines( "students.txt" )

i <- sample(1:length(students))
group.no <- length(i) %/% 4

groups <- tapply( i, 1:length(i) %% group.no, function(i){
    students[ i ] })

groups
