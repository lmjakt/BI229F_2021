# Dark matter: unmapped environmental sequences

## Environmental sequencing

The development of next-generation sequencing has made it possible to obtain
useful information by directly sequencing DNA or RNA derived
from a mixture of individuals and species that are present in a sample but
which have not been specifically isolated. Such sequencing is referred to as
*environmental sequencing* and is usually used in order to assess the taxonomic
composition of a an environment.

### Amplicon sequencing
The most commonly used form of environmental sequencing is *amplicon
sequencing*, where degenerate primers are used to amplify conserved sequence
elements such as ribosomal and mitochondrial gene fragments. The resulting PCR
product is then sequenced and compared to existing databases of the amplified
sequences in a wide range of species (referred to as *meta bar-coding*). This
approach is useful because it ensures that sequences are obtained from genetic
elements that have been sequenced in many species and taxons. 


### Shotgun sequencing
As the capacity of sequencing has grown it has become possible to simply
sequence random DNA fragments (shotgun sequencing) from a sample followed by
sequence assembly. This approach is suitable for samples containing
prokaryotic organisms as these usually have compact genomes that are
relatively straightforward to assemble. Alternatively the approach can be used
if the analysis focusses on mitochondrial sequences as these are present at
high copy numbers and are also relatively easy to assemble into discrete
units. Sequencing un-amplified DNA avoids the problem of PCR bias[^bias],
but requires much more sequence data to be useful and the analysis of the
resulting sequences also requires far more computational resources than
amplicon sequencing.

[^bias]: The differential amplification efficiency of different
    sequences. Small differences in amplification efficiency can lead to large
    differences in the final yield due to the exponential nature of the PCR.

### RNA sequencing
It is also possible to sequence the RNA content of an environmental sample. In
this case the RNA molecules are first extracted from the sample and then
reverse transcribed [^rt] into DNA that is then sequenced as in the shotgun
sequencing approach above. Sequencing RNA molecules rather than DNA means that
the set of sequences that are sequenced are restricted to expressed and
presumably functional genes. In theory, the resulting information can be used
to investigate how mixed populations respond to environmental changes. In
practice, however, this is difficult both because of the taxonomic complexity of
the sample and the fact that a few genes are expressed at very high levels
whereas most genes are expressed at low levels. Hence a large part of the
sequences obtained will be derived from the most highly expressed genes of the
most common species. 

[^rt]: Reverse transcription copies the sequence of RNA nucleotides into a
    sequence of DNA nucleotides using an RNA-dependent DNA polymerase. The
    reaction requires a short stretch of a double stranded RNA / DNA double
    helix which is extended by a reverse transcriptase enzyme.

### Sequence lengths and assembly
The most common forms of next-generation sequencing[^ngseq] produce large
numbers of relatively short sequences (up to 600 base pairs) which are
generally much shorter than the molecules that we wish to study
(i.e. chromosomes or full length transcripts). This means that the sequences
obtained from shotgun or RNA sequencing[^amplicon] are often assembled into
larger molecules prior to analysis. The assembly of sequences is dependant on
there being a sufficient number of uniquely overlapping sequences across the
assembled region and is made difficult by the complexity of environmental
sequences. Assemblies of both RNA and DNA (i.e. chromosomes) molecules are
typically fragmented and likely to contain erroneously assembled sequences,
and this problem is usually worse for environmental samples due to their
greater complexity. Hence shotgun environmental sequencing of eukaryotic
sequences remains remains a difficult objective.

[^ngseq]: The latest forms of high-throughput sequencing allow much longer
    molecules to be sequenced with molecules of several thousand base pairs
    being routinely sequenced and with a few reported cases of several million
    base pair sequences being obtained.
	
[^amplicon]: Amplicons are generally designed to be shorter allowing the full
    amplicon to be sequenced as a forward and reverse pair of sequences. This
    also makes the analysis of amplicon sequencing much simpler.

## The data

The data that you will be given to analyse comes from a preliminary shotgun
environmental mRNA sequencing project. The aim of the project was to assess
the utility of using mRNA sequencing (see details below) to address the impact
of fish farming on benthic eukaryotic components. The sequences were obtained
by extracting total RNA from small benthic (bottom mud) samples and the mRNA
content enriched for using immobilised oligo-dT (which can hybridise with
poly-A stretches). This enrichment step should do two things:

1. Remove ribosomal and other non-polyadenylated sequences
2. Remove prokaryotic sequences

Note that many functional long non-coding RNAs will be polyadenylated, so it
is not correct to consider all polyadenylated sequences as mRNA (the
m stands for messenger). Note also that these are enrichment processes and
there will always be some contaminating material left over.

Following mRNA enrichment[^mRNA] the resulting RNA sequences were copied to
complementary DNA (cDNA) using reverse transcriptase using either oligo-dT or
random hexamer priming[^priming]. The cDNA was then amplified using a limited
number of cycles of the PCR. The resulting library[^library] was then
sequenced on an Illumina MiSeq instruments yielding around 20-30 million
forward and reverse reads of 300 basepairs each.

[^mRNA]: Yes, the enrichment is really for polyadenylated RNA rather than
    mRNA, but it's much easier to write mRNA, and since the former includes
    the latter it's not technically wrong to write mRNA enrichment.

[^priming]: I forget if I've ever actually known which was used; I wasn't
    involved in the design or execution of the experiment and so don't have
    any definitive knowledge.
	
[^library]: We often refer to a pool of DNA sequences as a library; usually
    (but not always) the DNA molecules will have been modified in some way
    that allows us to amplify the whole collection of molecules. Historically
    this was done by inserting the fragments into vector sequences 
	(circular plasmids or linear bacteriophages) that carry sequences that
    cause them to be copied profusely within bacterial cells. More recently,
    the DNA fragments will have known linker sequences added (ligated) to
    their ends allowing the fragments to be amplified by PCR.
	
