use strict;
use warnings;
use Test::More tests => 9;
use Data::Dumper;
use FindBin qw( $RealBin );
use lib "$RealBin/../lib";

use FA;

# create a scalar filehandle that will write into $output
my $output;
my $fh;
open $fh, ">", \$output;

my $file = "data/small.fna";
my @query = ("Q0080");
my $exact = 0;

is(fagrep($fh, $file, \@query, $exact), 1, 'fagrep returned successfully with exact=F');
like($output, qr/>Q0080/, 'Q0080 correct');
unlike($output, qr/>YGR155W/, 'YGR155W correct');

$output = "";
$exact = 1;

is(fagrep($fh, $file, \@query, $exact), 1, 'fagrep returned successfully with exact=T');
unlike($output, qr/>Q0080\n/, 'Q0080 correct');
unlike($output, qr/>YGR155W\n/, 'YGR155W correct');

$output = "";
$exact = 0;
my @query = ("Q0080", "YGR155W");

is(fagrep($fh, $file, \@query, $exact), 1, 'fagrep returned successfully with multiple queries and exact=F');
like($output, qr/>Q0080/, 'Q0080 correct');
like($output, qr/>YGR155W/, 'YGR155W correct');
