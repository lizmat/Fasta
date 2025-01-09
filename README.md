[![Actions Status](https://github.com/lizmat/Fasta/actions/workflows/linux.yml/badge.svg)](https://github.com/lizmat/Fasta/actions) [![Actions Status](https://github.com/lizmat/Fasta/actions/workflows/macos.yml/badge.svg)](https://github.com/lizmat/Fasta/actions) [![Actions Status](https://github.com/lizmat/Fasta/actions/workflows/windows.yml/badge.svg)](https://github.com/lizmat/Fasta/actions)

NAME
====

Fasta - Library of FASTA related functionality

SYNOPSIS
========

```raku
use Fasta;

my %counts = Fasta.count-bases($file);
say %counts{"Carsonella ruddii"};     # bag with frequencies

my %sequences = Fasta.sequences($file);
say %sequences{"Carsonella ruddii"};  # sequence as string
```

DESCRIPTION
===========

A library for Fasta processing related logic.

count-bases
-----------

```raku
my %labels = Fasta.count-bases($file);
say %label{"Carsonella ruddii"};  # bag with frequencies
```

Takes the name of a Fasta file, and creates a hash with labels encountered as keys, and a Bag with the nucleotide letters and their frequencies.

sequences
---------

```raku
my %sequences = Fasta.sequences($file);
say %sequences{"Carsonella ruddii"};  # sequence as string
```

Takes the name of a Fasta file, and creates a hash with labels encountered as keys, and a string with the actual sequence.

INSPIRATION
===========

Inspired by the Suman Khanal's:

    https://sumankhanal.netlify.app/post/raku/count_dna/

AUTHOR
======

Elizabeth Mattijsen <liz@raku.rocks>

Source can be located at: https://github.com/lizmat/Fasta . Comments and Pull Requests are welcome.

If you like this module, or what I’m doing more generally, committing to a [small sponsorship](https://github.com/sponsors/lizmat/) would mean a great deal to me!

COPYRIGHT AND LICENSE
=====================

Copyright 2020, 2021, 2024, 2025 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

