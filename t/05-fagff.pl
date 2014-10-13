use strict;
use warnings;
use Test::More tests => 14;
use Data::Dumper;
use FindBin qw( $RealBin );
use lib "$RealBin/../lib";

use FA;

my $file = "data/alignment.fna";
my $gff = "data/alignment.gff";

# create a scalar filehandle that will write into $output
my $output;
my $fh;
open $fh, ">", \$output;

my $nogaps = 0;

is(fagff($fh, $file, $gff, $nogaps), 1, 'fagff returned successfully');
like($output, qr/>one_4-12 description of one here\nATGGGGTAA\n/, 'one 4-12 correct');
like($output, qr/>one_13-15 description of one here\nCCA\n/, 'one 13-15 correct');
like($output, qr/>two_4-12\nATG---TAA\n/, 'two 4-12 correct');
like($output, qr/>two_13-15\nCCC\n/, 'two 13-15 correct');
like($output, qr/>three_4-12\nATGAAATAA\n/, 'three 4-12 correct');
like($output, qr/>three_13-15\nCCG\n/, 'three 13-15 correct');

close $fh;
open $fh, ">", \$output;

$nogaps = 1;

is(fagff($fh, $file, $gff, $nogaps), 1, 'fagff returned successfully');
like($output, qr/>one_4-12 description of one here\nATGGGGTAA\n/, 'one 4-12 correct');
like($output, qr/>one_13-15 description of one here\nCCA\n/, 'one 13-15 correct');
like($output, qr/>two_4-12\nATGTAA\n/, 'two 4-12 correct');
like($output, qr/>two_13-15\nCCC\n/, 'two 13-15 correct');
like($output, qr/>three_4-12\nATGAAATAA\n/, 'three 4-12 correct');
like($output, qr/>three_13-15\nCCG\n/, 'three 13-15 correct');


