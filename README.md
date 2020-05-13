NAME
====

Fasta - Library of FASTA related functionality

SYNOPSIS
========

    use Fasta;

    my %labels = Fasta.count-bases($file);
    say %label{"Carsonella ruddii"};  # bag with frequencies

DESCRIPTION
===========

A library for Fasta processing related logic.

count-bases
-----------

    my %labels = Fasta.count-bases($file);
    say %label{"Carsonella ruddii"};  # bag with frequencies

Takes the name of a Fasta file, and creates a hash with labels encountered as keys, and a Bag with the nucleotide letters and their frequencies.

INSPIRATION
===========

Inspired by the Suman Khanal's:

    https://sumankhanal.netlify.app/post/raku/count_dna/

AUTHOR
======

Elizabeth Mattijsen <liz@wenzperl.nl>

Source can be located at: https://github.com/lizmat/Fasta . Comments and Pull Requests are welcome.

COPYRIGHT AND LICENSE
=====================

Copyright 2020 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

