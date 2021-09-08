use v6.c;
use Test;
use Fasta;

plan 10;

sub check-bag(
  Str:D $description, Int:D $A, Int:D $C, Int:D $G, Int:D $T,
  \bag
) {
    subtest "$description: check contents of bag" => {
        plan 6;

        isa-ok bag, Bag, "$description: did we get a Bag";
        is bag.elems, 4, "$description: number of nucleotides ok?";
        is bag<A>, $A, "$description: A nucleotides ok?";
        is bag<C>, $C, "$description: C nucleotides ok?";
        is bag<G>, $G, "$description: G nucleotides ok?";
        is bag<T>, $T, "$description: T nucleotides ok?";
    }
}

sub check-sequence(
  Str:D $description, Str:D $sequence, Str:D $start, Str:D $end
) {
    subtest "$description: check contents of sequence" => {
        plan 2;
        ok $sequence.starts-with($start), "$description: start ok?";
        ok $sequence.ends-with($end), "$description: end ok?";
    }
}

my %labels := Fasta.count-bases($?FILE.IO.sibling("carsonella.nfa"));
is %labels.elems, 1, 'did we find one bag';

check-bag 
  'carsonella', 66734, 13501, 12946, 66481,
  %labels{"NC_008512.1 Candidatus Carsonella ruddii PV DNA, complete genome"};

%labels := Fasta.count-bases($?FILE.IO.sibling("twofasta.nfa"));
is %labels.elems, 2, 'did we find two bags';

check-bag
  'bone-gla', 217, 409, 373, 232,
  %labels{'HSBGPG Human gene for bone gla protein (BGP)'};

check-bag
  'theta', 146, 362, 357, 155,
  %labels{'HSGLTH1 Human theta 1-globin gene'};

my %sequences := Fasta.sequences($?FILE.IO.sibling("carsonella.nfa"));
is %sequences.elems, 1, 'did we find one sequence';

check-sequence 
  'carsonella',
  %sequences{"NC_008512.1 Candidatus Carsonella ruddii PV DNA, complete genome"},
  "ATGAATACTATATTTTCAAGAATAACACCAT",
  "TTAAAAATAATAAATTGTTTAAATTAACCAT";

%sequences := Fasta.sequences($?FILE.IO.sibling("twofasta.nfa"));
is %sequences.elems, 2, 'did we find two bags';

check-sequence
  'bone-gla',
  %sequences{'HSBGPG Human gene for bone gla protein (BGP)'},
  "GGCAGATTCCCCCTAGACCCGCCCGCACCATGGTC",
  "CATCATCCCAGCTGCTCCCAAATAAACTCCAGAAG";

check-sequence
  'theta',
  %sequences{'HSGLTH1 Human theta 1-globin gene'},
  "CCACTGCACTCACCGCACCCGGCCAATTTTTGTGT",
  "TGCTCTCTCGAGGTCAGGACGCGAGAGGAAGGCGC";

# vim: expandtab shiftwidth=4
