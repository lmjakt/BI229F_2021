
## prepare some publication trends data:
py.range <- 1990:2020
ncbi.url <- urlInfo()
py.counts <- cbind('year'=py.range, 'nucleotide'=NA)
for(i in 1:length(py.range)){
    tmp <- search.ncbi.py(ncbi.url, py.range[i], db='nucleotide', "")
    py.counts[i,2] <- extract.count( tmp[[1]] )
}

urlInfo  <- function(){
    list(base="https://eutils.ncbi.nlm.nih.gov/entrez/eutils/",
         search_suffix = "esearch.fcgi?",
         summary_suffix = "esummary.fcgi?",
         data_suffix = "efetch.fcgi?")
}

## other functions to take this list as a an argument

## terms is a character vector that will be combined
## into a single string
search.ncbi  <- function(url, db="pubmed", terms, type="id", max=0){
    query=paste(url$base, url$search_suffix, "db=", db, "&", sep="")
    query=paste( query, "term=", paste(terms, collapse="+"),
                "&rettype=", type, sep="" )
    if(max && max > 0)
        query = paste(query, "&retmax=", max, sep="")
    readLines(query)
}

search.ncbi.py  <- function(url, years, db="pubmed", terms, type="id", max=0){
    terms.list  <- paste( paste(terms, collapse="+"),
                         paste(years, "[pdat]", sep=""), sep="+AND+" )
    lapply(terms.list, function(x){
        search.ncbi(url, db=db, terms=x, type=type, max=max )
    })
}

extract.ids  <- function(lines){
    gsub("[^0-9]", "",  grep("<Id>([0-9]+)</Id>$", lines, value=TRUE))
}

extract.count  <- function(lines){
    as.numeric( sub(".+?<Count>([0-9]+)</Count>.+", "\\1",
                    grep("<Count>[0-9]+</Count>", tmp[[1]], value=TRUE))[1] )
}
