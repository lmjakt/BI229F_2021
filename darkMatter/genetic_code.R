## Example code that translates DNA sequences to amino acid sequences


AAs  <- "FFLLSSSSYY**CC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG"
Starts <- "---M------**--*----M---------------M----------------------------"
Base1  <- "TTTTTTTTTTTTTTTTCCCCCCCCCCCCCCCCAAAAAAAAAAAAAAAAGGGGGGGGGGGGGGGG"
Base2  <- "TTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGG"
Base3  <- "TCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAG"

bases  <- list(Base1, Base2, Base3)

codons  <- vector(mode='character', length=nchar(AAs))
for(i in 1:nchar(AAs)){
    codons[i]  <- paste(sapply( bases, function(x){
        substring(x, i, i)}), collapse="")
}

gcode  <- strsplit( AAs, split="" )[[1]]
names(gcode)  <- codons

nuc  <- "ACATAGATAGACCTAGACGAT"
beg  <- seq(1, nchar(nuc), 3)
end  <- beg + 2

gcode[ substring( nuc, beg, end ) ]

## to read an unfolded fasta file into R, all you need is readLines

## given a file, for example rand_1m_bl_unmap_50k.fa

unmap.50  <- readLines("rand_1m_bl_unmap_50k.fa")
i  <- seq(1, length(unmap.50), 2)
ids  <- unmap.50[i]
unmap.50  <- unmap.50[i+1]
names(unmap.50)  <- ids

translate  <- function(seq, code, frame=1){
    beg  <- seq(frame, nchar(seq), 3)
    end  <- beg + 2
    code[ substring(seq, beg, end) ]
}

translate( unmap.50[1], gcode, 1 )
translate( unmap.50[1], gcode, 2 )
translate( unmap.50[1], gcode, 3 )

## to reverse complement is worse
