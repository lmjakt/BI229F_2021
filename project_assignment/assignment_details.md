% BI229F 2021 Project assignment details

# Overview

As part of the BI229F you will need to complete a bioinformatics / genomics
project. This project will consist of some form of bioinformatics analyses or
the development of some useful bioinformatics method. The work should be
carried out in groups of three or four individuals and should comprise the
following:

1. A body of code that was developed to meet the aims of the project.
2. Data and figures obtained by the use of the code.

These two components will be common to the members of a group. In addition to
this each member must hand in an individual report describing the work
performed. The reports should be written individually and should not resemble
each other too much (it is better that you do not see each others reports,
though you may certainly discuss amongst yourselves how to write the report).

# The assignment

You should perform an analyses based upon sequence or genome data (thus making
this a true genomics project) or implement some useful bioinformatics
function. You may choose to focus on genome structure, the nature of genomic
sequence, sequence analysis or some combination of these. I will suggest a
number of project topics, but you are free to suggest others. You can use the
'dark matter' sequences if you like, but it is not necessary.

## Topic suggestions

1. Analyse the coding potential of the dark matter sequences; note that you
   should compare coding potential in different sequence sets in order
   to be able to make any conclusions.
2. Analyse k-mer content of the dark matter sequences; again to reach some
   interesting solution you will need to compare the results with different
   sequence sets.
3. Compare the sequence content (i.e. kmers again) of different genomic
   elements within a species or across species.
4. Compare the distributions of the sizes of genomic elements across species.
5. Implement pairwise alignment in R along with some means of summarising and
   visualising the resulting alignments.
6. Implement some methods for visualising pairwise and or multiple alignments
   in R.


This is not an exhaustive list; you are free to come up with your own
suggestions of topics and ways you will need to specify a smaller goal within
the above topics.

These suggestions talk about things like sequence content and genomic elements
without actually specifying what these things mean. In terms of genome
elements at the simplest level these include:

1. Genic elements: i.e. regions which are transcribed.
2. Exons: regions which are transcribed and included in processed transcripts.
3. Introns: regions transcribed but removed from the mature transcript.

But you can also specify things like, 'upstream of putative starts of
transcription', 'upstream of translation start', 'downstream of translation'
stop codons. 

I do not think it reasonable for you to obtain the sequences from such
elements yourself and if needed I am willing to provide them for
you. Alternatively you could work on *how* to obtain such sequences and that
could be a reasonable project as well.

## The code and the report

I expect that you should produce at least one to two hundred lines of code as
part of your project. Your analysis should also produce at least 3 figures
(which may have multiple panels). The report should describe succinctly what
you set out to do and why as well as what you found. I do not expect a very
long report; something in the lines of 1000-2000 words should suffice.
It may be good[^good] to
structure your report into the following sections:

[^good]: good: something that we are more likely to award with a good grade.

#### Abstract
Very brief description of what you have done and what you found.

#### Introduction
Explanation of why you choose to do this work; this should not be filled with,
'very important to determine', and so on. I am more interested in why *you*
think the project topic is interesting; i.e. your personal motivations. Though
you may not wish to be too honest here if your motivation is only, 'because it
seemed the easiest thing on the list and I couldn't be bothered to think of
anything else'. 

Although providing your own motivation for doing the work might sound somewhat
*too* informal, it is not too far off from what we do when we write the introduction to
a scientific article. Of course then we are writing the justification for why
it should be of interest to others, but that generally aligns with why *we*
think it is interesting. For this project I do not expect you to come up with
something that no-one has done before, or that will answer as yet unanswered
questions, but I do hope that you can come up with something you you find
interesting, or at least can come up with an argument as to *why* others
might.

The introduction should also explain the logic of your analysis; how does your
analysis address the questions or aims that you started with.

#### Methods
Explain what your code does. If your project is very methods related, then
you may want to spend a fair amount of time describing functions that you have
created (and which should be usable outside of your own analysis).

#### Results and discussion
What have you observed in your analyses, and how does it answer the questions
you raised or fulfil your initial aims. Your figures should be referred to
within this text.

## Presentations
Each group must also present their ideas and preliminary results to the
class. Groups are free to arrange how they present their project, but should
make a slide presentation that should be handed in. The presentations will be
done over two days with each group given about 15 minutes for their
presentation, to be followed by a general discussion. The discussion should be
chaired by a member of another group.

The presentation is mandatory but not graded; it is hoped that the discussion
will provide you with more ideas as to how to finish both your analyses and
your reports.

# Advice
You are encouraged to ask me about your choice of project plans, and to ask
for advise when you feel you need it. However, there is no specific time
allocated for this and you will need to make the arrangements with me or
simply try knocking on my door (I like this as I can tell you to go away if I
am not free, but you may prefer to arrange a time beforehand).
