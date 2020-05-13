use v6.d;

my @nucleotides = <A C G T>;

class Fasta:ver<0.0.1>:auth<cpan:ELIZABETH> {

    multi method count-bases($file) {
        self.count-bases: $file, my %labels
    }

    multi method count-bases($file, %labels) {
        my $io := $file.IO;
        return Failure.new("'$file' not found")    unless $io.e;
        return Failure.new("'$file' not readable") unless $io.r;

        # create the bags
        my $current;
        for $io.lines {
            if .starts-with(">") {
                $current := %labels{.substr(1)} := BagHash.new;
            }
            elsif $current.defined {
                $current.add: .comb;
            }
            else {
                $current := %labels{"NOLABEL"} := BagHash.new: .comb;
            }
        }

        # clean up garbage
        for %labels.values -> $bag {
            for $bag.keys -> $nucleotide {
                $bag{$nucleotide} = 0 unless $nucleotide (elem) @nucleotides;
            }
        }

        %labels
    }
}

=begin pod

=head1 NAME

Fasta - Library of FASTA related functionality

=head1 SYNOPSIS

  use Fasta;

  my %labels = Fasta.count-bases($file);
  say %label{"Carsonella ruddii"};  # bag with frequencies

=head1 DESCRIPTION

A library for Fasta processing related logic.

=head2 count-bases

  my %labels = Fasta.count-bases($file);
  say %label{"Carsonella ruddii"};  # bag with frequencies

Takes the name of a Fasta file, and creates a hash with labels encountered
as keys, and a Bag with the nucleotide letters and their frequencies.

=head1 INSPIRATION

Inspired by the Suman Khanal's:

  https://sumankhanal.netlify.app/post/raku/count_dna/

=head1 AUTHOR

Elizabeth Mattijsen <liz@wenzperl.nl>

Source can be located at: https://github.com/lizmat/Fasta . Comments and
Pull Requests are welcome.

=head1 COPYRIGHT AND LICENSE

Copyright 2020 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under
the Artistic License 2.0.

=end pod

# vim: ft=perl6 expandtab sw=4
