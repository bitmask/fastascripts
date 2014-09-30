use strict;
use warnings;
use Test::More tests => 6;
use Data::Dumper;
use FindBin qw( $RealBin );
use lib "$RealBin/../lib";

use FA;

# create a scalar filehandle that will write into $output
my $output;
my $fh;
open $fh, ">", \$output;

my $file = "data/small.fna";
my $query = "ATG";
my $colour = "magenta";

is(fagrepif($fh, $file, $query, $colour), 1, 'fagrepif returned successfully for ATG');
like($output, qr/>Q0080 tab separated long description here\n\S+ATG/, 'Q0080 correct');
like($output, qr/>YGR155W.*\n\S+ATG/, 'YGR155W correct');

$output = "";
$query = "TGA";

is(fagrepif($fh, $file, $query, $colour), 1, 'fagrepif returned successfully for ATG');
like($output, qr/>Q0080 tab separated long description here\n\S+ATG/, 'Q0080 correct');
unlike($output, qr/>YGR155W/, 'YGR155W correct');
