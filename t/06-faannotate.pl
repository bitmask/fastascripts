use strict;
use warnings;
use Test::More tests => 4;
use Data::Dumper;
use FindBin qw( $RealBin );
use lib "$RealBin/../lib";

use FA;

my $file = "data/annotate.fna";
my $table = "data/annotate.csv";

# create a scalar filehandle that will write into $output
my $output;
my $fh;
open $fh, ">", \$output;

my $sep = ",";
my $idcol = 1;
my $datacol = 4;

my $lookup;
$lookup = parsetable($table, $sep, $idcol, $datacol);
isnt($lookup, undef, 'parsetable returned results');

is(faannotate($fh, $file, $lookup), 1, 'faannotate returned successfully');
like($output, qr/>BroadDengue_V1000_Vietnam_something\nAAAAAAAAAATTATTA/, 'faannotate correct for V1000');
like($output, qr/>BroadDengue_V9900_Cambodia\nGGCGGCCGGGCCGCCC/, 'faannotate correct for V9900');

