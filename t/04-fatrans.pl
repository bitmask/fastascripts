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

my $file = "data/one.fna";
my $frame = 0;
my $gencode = 1;

is(fatrans($fh, $file, $gencode, $frame), 1, 'fatrans returned successfully with gencode=1 and frame=0');
like($output, qr/MLQLVPFYFMNQLTYGFLLMILLLILFSQFFLPMILRLYVSRLFISKL\*\n/ , 'Q0080 correct gencode=1 and frame=0');

close $fh;
open $fh, ">", \$output;
$frame = 1;

is(fatrans($fh, $file, $gencode, $frame), 1, 'fatrans returned successfully with gencode=1 and frame=1');
like($output, qr/CFN\*FHFIL\*IN\*HMVSY\*\*FYY\*FYSHNSFYL\*S\*DYMYLDYLFLNY\n/ , 'Q0080 correct gencode=1 and frame=1');

close $fh;
open $fh, ">", \$output;
$frame = 2;

is(fatrans($fh, $file, $gencode, $frame), 1, 'fatrans returned successfully with gencode=1 and frame=2');
like($output, qr/ASISSILFYESINIWFLINDSIINFILTILFTYDLKIICI\*IIYF\*IM\n/ , 'Q0080 correct gencode=1 and frame=2');

close $fh;
open $fh, ">", \$output;
$frame = 0;
$gencode = 3;

is(fatrans($fh, $file, $gencode, $frame), 1, 'fatrans returned successfully with gencode=3 and frame=0');
like($output, qr/MTQLVPFYFMNQLTYGFLLMITLLILFSQFFLPMILRLYVSRLFISKLW\n/ , 'Q0080 correct gencode=3 and frame=0');
