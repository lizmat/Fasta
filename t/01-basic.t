use v6.c;
use Test;
use Fasta;

plan 5;

sub check-bag(
  Str:D $description, Int:D $A, Int:D $C, Int:D $G, Int:D $T, \bag
) {
    subtest "check contents of bag" => {
        plan 6;

        isa-ok bag, BagHash, "$description: did we get a BagHash";
        is bag.elems, 4, "$description: number of nucleotides ok?";
        is bag<A>, $A, "$description: A nucleotides ok?";
        is bag<C>, $C, "$description: C nucleotides ok?";
        is bag<G>, $G, "$description: G nucleotides ok?";
        is bag<T>, $T, "$description: T nucleotides ok?";
    }
}

my %labels := Fasta.count-bases($?FILE.IO.sibling("carsonella.nfa"));
is %labels.elems, 1, 'did we find one label';

check-bag 
  'carsonella', 66734, 13501, 12946, 66481,
  %labels{"NC_008512.1 Candidatus Carsonella ruddii PV DNA, complete genome"};

%labels := Fasta.count-bases($?FILE.IO.sibling("twofasta.nfa"));
is %labels.elems, 2, 'did we find two labels';

check-bag
  'bone-gla', 217, 409, 373, 232,
  %labels{'HSBGPG Human gene for bone gla protein (BGP)'};

check-bag
  'theta', 146, 362, 357, 155,
  %labels{'HSGLTH1 Human theta 1-globin gene'};
