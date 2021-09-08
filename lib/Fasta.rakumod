use v6.d;

my constant @nucleotides = <A C G T>;

class Fasta:ver<0.0.4>:auth<zef:lizmat> {

    multi method count-bases($file) {
        self.count-bases: $file, my %labels
    }

    multi method count-bases($file, %labels) {
        my $io := $file.IO;
        return Failure.new("'$file' not found")    unless $io.e;
        return Failure.new("'$file' not readable") unless $io.r;

        # create the bags
        my str $label = "NOLABEL";
        my int @counts;

        sub finalize() {
            if @counts {
                %labels{$label} := @nucleotides.map( {
                    $_ => @counts[.ord]
                } ).Bag;
                @counts = ();
            }
        }

        for $io.lines -> str $line {
            use nqp;  # hot stuff, so we're going to cheat

            if nqp::eqat($line,">",0) {
                finalize;
                $label = nqp::substr($line,1);
            }
            else {
                my int $i     = -1;
                my int $chars = nqp::chars($line);
                nqp::while(
                  nqp::islt_i(($i = nqp::add_i($i,1)),$chars),
                  ++nqp::atposref_i(@counts,nqp::ordat($line,$i))
                );
            }
        }
        finalize;

        %labels
    }

    multi method sequences($file) {
        self.sequences: $file, my %labels
    }

    multi method sequences($file, %labels) {
        my $io := $file.IO;
        return Failure.new("'$file' not found")    unless $io.e;
        return Failure.new("'$file' not readable") unless $io.r;

        # create the sequences
        my $current;
        for $io.lines {
            if .starts-with(">") {
                $current := %labels{.substr(1)} := my str @;
            }
            elsif $current.defined {
                $current.push: .trim;
            }
            else {
                $current := %labels{"NOLABEL"} := (my str @ = .trim);
            }
        }

        # merge the parts
        for %labels.keys -> $label {
            %labels{$label} := %labels{$label}.join;
        }

        %labels
    }
}

=begin pod

=head1 NAME

Fasta - Library of FASTA related functionality

=head1 SYNOPSIS

  use Fasta;

  my %counts = Fasta.count-bases($file);
  say %counts{"Carsonella ruddii"};     # bag with frequencies

  my %sequences = Fasta.sequences($file);
  say %sequences{"Carsonella ruddii"};  # sequence as string

=head1 DESCRIPTION

A library for Fasta processing related logic.

=head2 count-bases

  my %labels = Fasta.count-bases($file);
  say %label{"Carsonella ruddii"};  # bag with frequencies

Takes the name of a Fasta file, and creates a hash with labels encountered
as keys, and a Bag with the nucleotide letters and their frequencies.

=head2 sequences

  my %sequences = Fasta.sequences($file);
  say %sequences{"Carsonella ruddii"};  # sequence as string

Takes the name of a Fasta file, and creates a hash with labels encountered
as keys, and a string with the actual sequence.

=head1 INSPIRATION

Inspired by the Suman Khanal's:

  https://sumankhanal.netlify.app/post/raku/count_dna/

=head1 AUTHOR

Elizabeth Mattijsen <liz@raku.rocks>

Source can be located at: https://github.com/lizmat/Fasta . Comments and
Pull Requests are welcome.

=head1 COPYRIGHT AND LICENSE

Copyright 2020, 2021 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under
the Artistic License 2.0.

=end pod

# vim: expandtab shiftwidth=4
