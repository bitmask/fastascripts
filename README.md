fastascripts – Manipulate FASTA files
=====================================

Everyone writes one off scripts to manipulate FASTA files.  Use these instead -- they're working and tested (mostly).  Let's work towards having one collection of small tools that we trust to work properly. 

These scripts were originally written in 2013 by Shaun Jackman with the following disclaimer: "These scripts were never meant to see the light of day. I apologize for the distasteful code."

Since then, I have rewritten facat and fagrep to be a bit more robust, and added tests for them.  I have added some new scripts as well (see below).  I am starting to collect the functions into a module; there is a lot of room to simplify this further.  Some scripts now rely on BioPerl.

New in v2
=========

Updated with tests

* `facat`
	Concatenate FASTA files and add a prefix to the identifier; optionally remove spaces from ids; merges all sequence lines into one line
* `fagrep` and `faget` have been merged
    Specify queries for identifiers in FASTA files; exact/fuzzy match supported

Added and tested

* `fagrepif`
    Grep for a codon in frame; has colour highlighting like unix grep

Added but pending tests

* `fastandard`
    Exclude any entries that contain nonstandard bases
* `fasplit`
    Split fasta file into a file for each gene
* `famerge`
    Merge exon entries into one entry based on fasta id
* `fatrans`
    Translate from nucleotide to protein, specifying genetic code
* `fasw`
    Split entries by applying a sliding window to extract possibly overlapping sequences

Original Utilities
==================

* `facanon`
	Output the lexicographically smaller of the sequence and its reverse complement
* `facat`
	Concatenate FASTA files and add a prefix to the identifier
* `fachain`
	Merge overlapping sequences
* `faclean`
	Reformat and optionally remove short contigs from a FASTA file
* `facmp`
	Compare pairs of sequences
* `facstont`
	Convert colour-space sequence to nucleotides
* `fadecimate`
	Randomly keep 1 in every N pairs of reads
* `faget`
	Select sequences from a FASTA file by identifier
* `fagrep`
	Search a FASTA file using a regular expression
* `fakmer`
	Generate tiled k-mers
* `falength`
	Print the lengths of sequences
* `falint`
	Check the syntax of a FASTA file
* `famd5`
	Calculate a MD5 digest for a FASTA file
* `famd5seq`
	Calculate a MD5 digest for each sequence
* `fanttocs`
	Convert nucleotides to colour-space sequence
* `farand`
	Generate a FASTA file with random sequence
* `farc`
	Reverse and complement the sequences
* `farenumber`
	Renumber the sequences
* `faseperate-mates`
	Separate paired reads into two files
* `fasplit-read`
	Split a read into two at the midpoint
* `fastqtofa`
	Convert a FASTQ file to FASTA format
* `fatoagp`
	Convert FASTA scaffolds to FASTA contigs and an AGP file
* `fatofastq`
	 Convert a FASTA file to a FASTQ file
* `fatoseq`
	Remove FASTA headers
* `faunamb`
	Convert IUPAC-IUB ambiguity codes to ACGT
* `faunscaffold`
	Break scaffolds into contigs at Ns

License
================================================================================

Copyright 2013 Shaun Jackman

### [ISC License][]

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

[ISC License]: http://opensource.org/licenses/ISC
