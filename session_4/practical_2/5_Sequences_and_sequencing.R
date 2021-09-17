#################################################
###            SEQUENCE ALIGNMENT             ###
#################################################

# INSTALL PACKAGES ####

# Run the following lines if you haven't yet installed package ape, seqinr, BiocManager, Biostrings or msa:
#install.packages("ape")
#install.packages("seqinr")
#install.packages("BiocManager")
#BiocManager::install("Biostrings")
#BiocManager::install("msa")

# 1. PAIRWISE SEQUENCE ALIGNMENT ####

# For this exercise we need packages Biostrings and seqinr. Don't forget to activate them!

library(seqinr)
library(Biostrings)

# Follow this script to perform a pairwise alignment between two sequences.
# You can either start by executing all the code to see how it works for example sequences,
# or immediately change the code to fit the bacterial sequences (See 1F). Up to you!

# 1A. Set your working directory to the location where you saved all .FASTA sequences ####

setwd("yourdirectory")

# 1B. Read in your fasta files ####

# The standard format for sequence files that you can download from online databases is the .FASTA format.

exampleseq1 <- read.fasta(file = "examplesequence1.fasta")
ex1 <- exampleseq1[[1]]
ex1
exampleseq2 <- read.fasta(file = "examplesequence2.fasta")
ex2 <- exampleseq2[[1]]
ex2
#QUESTION: What do the letters mean? Remember these are proteins and not genes.

# 1C. Make a dotplot ####

#To visualize the matching nucleotides or amino acids between two sequences, 
#we can use a "Dot plot".
dotPlot(ex1, ex2)
#QUESTION: What does it show and how to can you interpret this plot?

# 1D. Make a global alligment ####

#Next, we will try to provide a formal alignment and an alignment score.
#You learned that to score an alignment, we need to define a substitution matrix.
#For nucleotides, this is easily defined by using the "nucleotideSubstitutionMatrix" function.

sigma <- nucleotideSubstitutionMatrix(match = 2, mismatch = -1, baseOnly = TRUE)
sigma 
#QUESTION: What do these numbers represent?

#Let's try this with two simple nucleotide sequences:
s1 <- "GAATTC"
s2 <- "GATTA"

#The "pairwiseAlignment()" function in the Biostrings R package finds the score for the optimal global alignment
#between two sequences using the Needleman-Wunsch algorithm, given a particular scoring system.

globalAligns1s2 <- pairwiseAlignment(s1, s2, substitutionMatrix = sigma,
                                     gapOpening = -2,
                                     gapExtension = -8, scoreOnly = FALSE)
globalAligns1s2

#QUESTION: Can you see how the score was calculated? Look into the help of the function pairwiseAlignment()
?pairwiseAlignment()

#Let's try with our protein sequences.
#For proteins, a different matrix is required. There are several datasets and matrices
#included in the Biostrings package. You can view them using
data(package="Biostrings")
#For this example, we will load the BLOSUM50 matrix using the data() function
data(BLOSUM50)
BLOSUM50

#To align the protein sequences, they have to be saved as a single string,
#not as characters. You can do this easily using the c2c() function
ex1string <- c2s(ex1)
ex2string <- c2s(ex2)
#And the letters have to be uppercase, use the toupper() function
ex1string <- toupper(ex1string)
ex2string <- toupper(ex2string)
globalAlignex1ex2 <- pairwiseAlignment(ex1string, ex2string, substitutionMatrix = "BLOSUM50",
                                     gapOpening = -2,
                                     gapExtension = -8, scoreOnly = FALSE)
globalAlignex1ex2

# 1E. Make a local alligment ####

#What you have done above is called a GLOBAL alignment. 
#It is also possible to do a LOCAL alignment, by adjusting some arguments of the pairwiseAlignment function.

localAlignex1ex2 <- pairwiseAlignment(ex1string, ex2string,
                                              substitutionMatrix = BLOSUM50, gapOpening = -2, gapExtension = -8, scoreOnly =
                                                FALSE, type="local")
localAlignex1ex2

#QUESTION: What is the difference between local and global alignment?
#When are local or global alignments most appropriate?
#Why is the score of the local alignment so much higher than the global one?

# 1F. Optional: allignment between two bacterial sequences ####

# Swith to the two bacterial sequences mleprae.fasta and mulcerans.fasta.
# Copy the code from 1B to 1E and apply it to these two new fasta files
# Warning! computational time will increase!





# 2. MULTIPLE SEQUENCE ALIGNMENT ####

# One big family: aligning the mitochondrial genomes of our closest living relatives
# For this exercise we need packages ape and msa. Don't forget to activate them!

library(ape)
library(msa)

# In this exercise we will run a multiple alignment of six members of the Hominoidea: the great apes.
# The text file "Great-Apes_mitogenomes.txt" in multifasta format is our starting point and contains 
# the mitochondrial genomes of the six species.
# We will use the R package "msa", or Multiple Sequence Alignment, to perform our alignment.
# With our input, this package will perform the difficult calculations for us to produce the multiple alignment.

# 2A. Set your working directory to the location of "Great-Apes_mitogenomes.txt" ####

setwd("C:/Users/tmb/Dropbox/PhD-fellowship Nord University/Teaching/B1229F bioinformatics/2018/Practicals/Sequences")

# 2B. Import the multifasta file ####

# Import the multifasta file, and let the package read it as a stringset of DNA 
# sequences with the function "readDNAStringSet"

GreatApeSequencesFile <- "Great-Apes_mitogenomes.txt"
GreatApeSequences <- readDNAStringSet(GreatApeSequencesFile)

# To check if the multifasta file was imported correctly, check "GreatApeSequences" in the console. #
GreatApeSequences

# What kind of relevant information can you already infer after doing this? #

# 2C. Run the "msa" package under the default settings ####

# Under the default settings "msa" will use the default parameters of the ClustalW method.
# This can take a few minutes, processing speed may also vary between computers.

library(msa)
FamilyAlignment <- msa(GreatApeSequences)

# 2D. Check the full alignment ####

print(FamilyAlignment, showConsensus=FALSE, show="complete")

# Study the alignments visually, is there anything you can infer? 
# Are there unique gaps and/or unique sequences for single species? 
# If so, what is a possible biological/molecular explanation for this? 

# As covered in the lectures, alignments can be used to infer the phylogenetic 
# relationships between species # The package "msa" can not build phylogenetic trees itself, 
# but luckily files in R can often be converted to be used by other packages. 
# Using the packages "seqinr" and "ape" we can try to infer the phylogenetic 
# relationship based on the mitogenome alignment. In previous exercises you might have already 
# installed these packages, if not, make sure to download, install and activate them first.

# 2E. Convert the "msa" alignment to a file that can be read by "seqinr" #####

FamilyAlignmentForSeqinr <- msaConvert(FamilyAlignment, type="seqinr::alignment")

# 2F. Compute a distance matrix for the alignment ####

FamilyAlignmentDistance <- dist.alignment(FamilyAlignmentForSeqinr, "identity")

# This matrix contains information about the genetic distance between the species, from which we can infer the phylogenetics #

# 2G. Calculate the phylogenetic tree and plot it ####

FamilyTree <- nj(FamilyAlignmentDistance)
plot(FamilyTree, main="Our family tree")

# Are the relationships between the species as you expected? #
# Will every homologous sequence alignment between these species always result in this specific tree? #

# 2H. Optional: Align the sequences using the MUSCLE algorithm ####

FamilyAlignmentMuscle <- msa(GreatApeSequences, "Muscle")
print(FamilyAlignmentMuscle, showConsensus=FALSE, show="complete")
FamilyAlignmentMuscleForSeqinr <- msaConvert(FamilyAlignmentMuscle, type="seqinr::alignment")
FamilyAlignmentMuscleDistance <- dist.alignment(FamilyAlignmentMuscleForSeqinr, "identity")
FamilyTreeMuscle <- nj(FamilyAlignmentMuscleDistance)
plot(FamilyTreeMuscle, main="Our family tree 2")

# What effect has using the MUSCLE algorithm on the alignment and the family tree? #

