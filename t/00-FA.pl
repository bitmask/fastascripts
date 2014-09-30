
use strict;
use warnings;
use Test::More tests => 2;
use Data::Dumper;
use FindBin qw( $RealBin );
use lib "$RealBin/../lib";

# does the module load?
BEGIN { 
	use_ok( 'FA' ); 
}
require_ok( 'FA' );


