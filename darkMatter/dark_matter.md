# Dark matter: unmapped environmental sequences

## Environmental sequencing

The development of next-generation sequencing has made it possible to obtain
useful information by directly sequencing DNA or RNA derived
from a mixture of individuals and species that are present in a sample but
which have not been specifically isolated. Such sequencing is referred to as
*environmental sequencing* and is usually used in order to assess the taxonomic
composition of an environment.

### Amplicon sequencing

The most commonly used form of environmental sequencing is *amplicon
sequencing*, where degenerate primers are used to amplify conserved sequence
elements such as ribosomal and mitochondrial gene fragments. The resulting PCR
product is then sequenced and compared to existing databases of the amplified
sequences in a wide range of species (referred to as *meta bar-coding*). This
approach is useful because it reduces the complexity of the effective sample
sequence content and ensures that sequences are obtained from genetic
elements that have been sequenced in many species and taxons. 


### Shotgun sequencing

As the capacity of sequencing has grown it has become possible to simply
sequence random DNA fragments (shotgun sequencing) from a sample followed by
sequence assembly. This approach is suitable for samples containing
prokaryotic organisms as these usually have compact genomes that are
relatively straightforward to assemble[^assemble]. Alternatively the approach can be used
if the analysis focusses on mitochondrial sequences as these are present at
high copy numbers and are also relatively easy to assemble into discrete
units. Sequencing un-amplified DNA avoids the problem of PCR bias[^bias],
but requires much more sequence data to be useful and the analysis of the
resulting sequences also requires far more computational resources than
amplicon sequencing.

[^assemble]: Combining short overlapping sequences into longer fragments,
    ultimately leading to complete chromosome sequences. This can be
    straightforward for small and compact genomes that do not contain many
    repetitive elements.

[^bias]: The differential amplification efficiency of different
    sequences. Small differences in amplification efficiency can lead to large
    differences in the final yield due to the exponential nature of the PCR.

### RNA sequencing
It is also possible to sequence the RNA content of an environmental sample. In
this case the RNA molecules are first extracted from the sample and then
reverse transcribed[^rt] into DNA that is then sequenced as in the shotgun
sequencing approach above. Sequencing RNA molecules[^rnaseq] rather than DNA means that
the set of sequences that are sequenced are restricted to expressed and
presumably functional genes. In theory, the resulting information can be used
to investigate how mixed populations respond to environmental changes. In
practice, however, this is difficult both because of the taxonomic complexity of
the sample and the fact that a few genes are expressed at very high levels
whereas most genes are expressed at low levels. Hence a large part of the
sequences obtained will be derived from the most highly expressed genes of the
most common species.

One potential advantage of sequencing RNA molecules is that the RNA is much
less stable than DNA. This means that we can avoid sequencing molecules
present in biological material that may have drifted in from distant locations
or which may simply represent historical taxonomic composition. In theory, all
or at least most, of the sequences ought to be derived from cells alive at the
time of sample processing.

[^rt]: Reverse transcription copies the sequence of RNA nucleotides into a
    sequence of DNA nucleotides using an RNA-dependent DNA polymerase. The
    reaction requires a short stretch of a double stranded RNA / DNA double
    helix which is extended by a reverse transcriptase enzyme.

[^rnaseq]: Although I have written 'sequencing RNA molecules' we actually
    sequence DNA molecules that are complementary to the RNA sequences from
    which they have been copied. It would be more accurate to write,
    'obtaining RNA sequences', but this feels somewhat too awkward.


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
sequences is still difficult.

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
by extracting total RNA from small benthic (bottom mud) samples. The mRNA
content of this RNA was then enriched using immobilised oligo-dT (which can
hybridise with poly-A stretches). This enrichment step should do two things:

1. Remove ribosomal and other non-polyadenylated sequences
2. Remove prokaryotic sequences

Note that many functional long non-coding RNAs will be polyadenylated, so it
is not correct to consider all polyadenylated sequences as mRNA (the
m stands for messenger). Note also that these are enrichment processes and
there will always be some contaminating material left over.

Following mRNA enrichment[^mRNA] the resulting RNA sequences were copied to
complementary DNA (cDNA) using reverse transcriptase using either oligo-dT or
random hexamer priming[^priming]. The cDNA was then amplified using a limited
number of cycles of PCR. The resulting library[^library] was then
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
	
The sequencing thus obtained 300 bases starting from the beginning[^beg_end]
and 300 bases starting from the end of each fragment
sequenced. In theory this provides up to 600 bases from each fragment as long
as the fragment is longer than 600 base pairs (note that in such cases there
would be some sequence missing from the middle of the fragment). However
the vast majority of the fragments were much shorter than 600 base
pairs. Although this means that we didn't obtain as much sequence data as
possible it also means that it is straightforward to merge the forward and
reverse sequences together. In this practical work you will be provided with
the merged sequences rather than the individual forward and reverse
reads.

[^beg_end]: The orientation of the fragments is only a function of how they
	were sequenced and is usually completely arbitrary when dealing with
	sequences obtained from DNA. However in this case we sequenced RNA, and
	the beginning and end of the fragments relates to the direction of the RNA
	sequence.
	
## Prior data analysis

The sequences that you have been given come from a randomly selected set of
around 1 million fragments whose forward reads were aligned to sequences in
the NCBI nr/nt database using BLAST. NCBI nr/nt contains very large numbers of
sequences from all domains of life and it is probably the most comprehensive
sequence database available. Nevertheless, with the parameters chosen, the
majority of sequences did not align to any sequences within NCBI nr/nt. This
is somewhat unexpected because biological sequences in general and mRNA
sequences specifically tend to contain common motifs that are present across
all domains of life and which can usually be aligned to something within the
known databases. There are at least three potential explanations for the lack
of aligning sequences:

1. Bad choice of alignment parameters; i.e. the threshold parameters were too
   strict.
2. The sequences are in fact not biological in nature but represent some sort
   of experimental artefact.
3. The sequences are from very divergent organisms that we have very little
   prior knowledge of.
   
Of these, alternative one is probably the most significant, but our observations
are fairly typical for this kind of experiment and it is possible that
two and three contribute to the lack of alignment for the majority of
sequences. However, for this data analysis we will start by assuming that the
BLAST search was sufficiently sensitive and that we have a set of sequences
that simply do not look like any previously obtained sequences.

## The assignment

### The data and questions

You will initially be given the set of merged sequences which did not align to
NCBI nr/nt. For the time being you should assume that these sequences can't be
aligned meaningfully to any known sequences. At later stages you may consider
to what extent this is actually true. Given this set of sequences you should
come up with ways of addressing the following questions:

1. Do the sequences look random?
2. Are they likely to have been caused by some experimental artefact?
3. Are they derived from RNA or DNA sequences?
4. Do they encode proteins?

These questions can be addressed by simply considering the properties of the
sequences themselves, though it may not be initially obvious how this can be
done. In particular questions one and two are actually more tricky than the
latter questions.

When thinking about how to address the above questions keep in mind that:

1. The sequences are supposed to be derived from RNA fragments in a
   directional manner. That implies that the forward reads
   will have different properties to the reverse complement.
2. If the sequences really are from mRNA you may expect that either the
   forward or the reverse complement has more coding potential.
3. Biological sequences do not look like random sequences.
4. What type of complexity would you expect from artefactual sequences?

When you consider these questions you may find that you want to compare the
properties of these sequences with other sequences. If there are sets that you
think would be useul let me know and I can probably supply such sets to you
(we have several that we have used).

### The assignment tools

It is expected that you will do most of the analyses in R. However, at some
later stages you may wish to use external tools for specific
analyses. However, even in these cases you will probably want to visualise the
resulting data using R.

If you have an idea of doing something that is intrinsically difficult to do
in R and you think you can do the analysis using a different programming
language you may do so. But you will need to explain the analysis to the other
students and it is probably a good idea for you to discuss it with me before
doing too much.

You will be given an unfolded fasta file. This means that sequence identifiers
and sequences will be present on alternate lines:

```sh
>seq_1
ACATAGACTAAATA
>seq_2
ACGATAGGACTAGACACATAGAC
>seq_3
ACATAGATACAGAGAAC
...
```

This makes it easy to read the sequences into R.

You may find some of these functions useful:

1. `readLines`
2. `nchar`
3. `strsplit`
4. `substring`
5. `hist`
6. `seq`
7. `table`

Though you will certainly need more. Remember that first you must consider
what properties that you wish to consider. Also remember that you need to
consider not only the properties of the set from which the sequences were
sequenced, but also the properties of the sampling itself (i.e. that which you
have been given).

### The group setup

Note: the following represents a loose plan that is likely to be adjusted by
circumstance.

You will be divided into groups of four individuals each. Initially each group
should discuss what questions to address and how you can do so. One member of
each group should take responsibility for one of the following domains:

1. Molecular biology: how the underlying molecular biology processes will be
   reflected in the sequence content.
2. R: how to perform the analyses in R.
3. Visualisation: how to visualise the observations.
4. Statistics: how can you address whether any observations are significantly
   different from random noise?
   
After initial discussion within each group, the groups will split up and the
'domain experts' will form domain specific groups to discuss what they have
come up with and how to proceed. The initial groups will then reform to carry
out the work. The actual work, will happen over the progress of the course and
be interspersed with discussion across the class.

There is obviously a lot of overlap between these roles and in your actual
work you will contribute to all four domains. The main purpose of defining the
'domain specific experts' is to enable ideas to be spread across the
groups. Therefore you may change your roles if you feel this is appropriate.

We will have try to discuss what the groups have come up with each time we
have a group session. During this time I may provide suggestions as to what to
consider or how you can proceed. As we progress we may also start to use some
R packages, but to start with it is good if you can consider how to use only
base R to answer the above questions.
