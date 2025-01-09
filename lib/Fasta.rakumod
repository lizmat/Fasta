my constant @nucleotides = <A C G T>;

class Fasta {

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

# vim: expandtab shiftwidth=4
