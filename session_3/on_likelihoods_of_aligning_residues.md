# Values in substitution matrices

In the article "Where did the BLOSUM62 alignment score matrix come
from"[^blosum] you will find the following equation:

$$
	s(a,b) = \frac{1}{\lambda}\log\frac{P_{ab}}{f_{a}f_{b}}
$$

[^blosum]: Uploaded to Canvas as the file
    Where_blosum_came_from_Sean_Eddy.pdf.
	
We don't care much about the first term ($\frac{1}{\lambda}$) in this
equation; it is only there to give us numbers that are close to
integrals. However we do care about the following parts. In
particular:

$$
\frac{P_{ab}}{f_{a}f_{b}}
$$

In this equation:

- $P_{ab}$ is the probability of observing $a$ and $b$ aligned to each other
  in a homologous sequence alignment. Probability in this case will have been
  estimated as the *frequency* of $a$ aligned to $b$ in some trusted[^trust]
  pairwise alignments of homologous sequences.
- $f_a$ and $f_b$ are simply the frequency of the amino acids $a$ and $b$ in
  the sequences used to estimate $P_{ab}$.
  
[^trust]: Such alignments would have been created with available substitution
    matrices, and although such matrices may have been less optimal it would
    still have been possible to derive useful statistics enabling some form of *trust*.

The denominator[^denom] in this equation ($f_{a}f_{b}$) is an estimate of the
frequency with which we would expect to find the residues $a$ and $b$ aligned
to each other in random sequence pairs. This value is equivalent to
the probability of picking an $a$ and a $b$ from a pool of residues where the
frequency of $a$ and $b$ is $f_a$ and $f_b$ respectively. That corresponds to
our *null hypothesis*.

The numerator ($P_{ab}$) is an estimate of the probability of observing $a$ and $b$
aligned in two homologous sequences.

[^denom]: Denominator: the bottom part of fractions (I always tend to forget
    which is the denomitor, numerator and so on).

The resulting fraction can thus be described as:

$$
\frac{likelihood\; of\; observing\; ab\; in\; a\; homologous\; alignment}{likelihood\; of\;
observing\; ab\; in\; random\; alignment}
$$

Here likelihood and probability are pretty much interchangeable, so you can
also think of the above as the probabilities of observing the aligned residues
under the two conditions.

The two conditions given here represent a *null* and an *alternative*
hypothesis. The *null* one being that the sequences are not related to each
other; we model these sequences as being essentially random (i.e. constructed
by picking residues randomly from a pool with known frequencies). The
alternative hypothesis is that they are homologous, or more accurately, that
they have the same relationships as those in the set of alignments used to
create the substitution matrix.

If we define the *null* and *alternative* hypotheses then we can also express this fraction as:

$$
\frac{P[ab\mid H_1]}{P[ab\mid H_0]}
$$

Where $P[ab\mid H_1]$ and $P[ab\mid H_0]$ represent the probability of
observing $ab$ under the alternative and the null hypothesis respectively.

This kind of expression is often called a likelihood ratio; we almost always
take the log of such ratios[^log]. These are referred to as *log odds
ratios*. Taking the log of them means that we can simply add up the values and
the resulting sum will represent the log odds ratio of the entire alignment.

[^log]: In fact when dealing with fractions (and products) it is very often 
	useful to take the log of the values.

## The probability of the alternative hypothesis being true

I was asked in class as to whether it wouldn't be better to estimate:

$$
P[H_1\mid ab]
$$

That is, *the probability of the alternative hypothesis being true given the
observation*. Of course, to some extent that is what we would like to
know. Unfortunately we cannot obtain an estimate for that probability. There
are many reasons for this (eg. it is not clear how to derive such a
probability), but one reason can be nicely expressed in a famous quote:

>	Essentially all models are wrong. Some are useful.
>	
>	Box, George E. P.; Norman R. Draper (1987). Empirical Model-Building and
>    Response Surfaces, p. 424, Wiley. ISBN 0471810339.
	
Both $H_0$ and $H_1$ above are models, and these models are
simplifications of reality. For example, from the article:

>	If we assume that each aligned residue pair is statistically independent
>   of the others (biologically dubious, but mathematically convenient), ...
	
We see that the models used are
convenient simplifications. As such they can not be *absolutely* true, and there
are likely to exist *better* models ($H_2,H_3,\dots H_n$) that are *more*
true. In fact even the null model used here is not really true for alignments of
non-homologous sequences; biological
sequences really do not look like sequences created by picking residues at
random, and there are certainly better ways in which you could model the
*null* hypothesis. However, that would be rather too complex and it is not
clear that such models would be more useful even if more correct.

The good old *p*-values that we calculate are based on estimating the
probability of observing the data under one or more model. Often all we have
is the *null* hypothesis, but even then we need to have a statistical model
that describes what we expect to observe when it is true. I am not aware of
any situation where we attempt to estimate the probability of a *specific*
model being true.


