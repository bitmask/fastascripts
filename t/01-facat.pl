use strict;
use warnings;
use Test::More tests => 16;
use Data::Dumper;
use FindBin qw( $RealBin );
use lib "$RealBin/../lib";

use FA;

my $file = "data/small.fna";
my $prefix = "chr1";
my $sep = "-";
my $normspace = "0";

# create a scalar filehandle that will write into $output
my $output;
my $fh;
open $fh, ">", \$output;

is(facat($fh, $file, $prefix, $sep, $normspace), 1, 'facat returned successfully with rmspace');
like($output, qr/>chr1-YGR155W-with-descr\n/, 'YGR155W correct');
like($output, qr/>chr1-YOR276W-long-descr-here\n/, 'YOR276W correct');
like($output, qr/>chr1-Q0080-tab-separated-long-description-here\n/, 'YOR276W correct');

$output = "";
$normspace = "1";

is(facat($fh, $file, $prefix, $sep, $normspace), 1, 'facat returned successfully with normspcae');
like($output, qr/>chr1 YGR155W-with-descr\n/, 'YGR155W correct');
like($output, qr/>chr1 YOR276W long descr here\n/, 'YOR276W correct');
like($output, qr/>chr1 Q0080 tab separated long description here\n/, 'YOR276W correct');

$output = "";
$prefix = "";

is(facat($fh, $file, $prefix, $sep, $normspace), 1, 'facat returned successfully with normspcae and no prefix');
like($output, qr/>YGR155W-with-descr\n/, 'YGR155W correct');
like($output, qr/>YOR276W long descr here\n/, 'YOR276W correct');
like($output, qr/>Q0080 tab separated long description here\n/, 'YOR276W correct');

$output = "";
$normspace = "0";

is(facat($fh, $file, $prefix, $sep, $normspace), 1, 'facat returned successfully with rmspace and no prefix');
like($output, qr/>YGR155W-with-descr\n/, 'YGR155W correct');
like($output, qr/>YOR276W-long-descr-here\n/, 'YOR276W correct');
like($output, qr/>Q0080-tab-separated-long-description-here\n/, 'YOR276W correct');


