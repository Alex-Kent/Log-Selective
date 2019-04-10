use strict;
use warnings;
use Test::More;

# Ensure a recent version of Test::Pod::Coverage
my $min_tpc = 1.08;
eval "use Test::Pod::Coverage $min_tpc";
plan skip_all => "Test::Pod::Coverage $min_tpc required for testing POD coverage"
    if $@;

# Test::Pod::Coverage doesn't require a minimum Pod::Coverage version,
# but older versions don't recognize some common documentation styles
my $min_pc = 0.18;
eval "use Pod::Coverage $min_pc";
plan skip_all => "Pod::Coverage $min_pc required for testing POD coverage"
    if $@;


all_pod_coverage_ok(
                     {
                       trustme => [
                                    # Aliases:
                                    qw( WARNING ), 
                                    
                                    # Constants:
                                    qw( FAINT NORMAL BOLD ITALIC NO_ITALIC UNDERLINE NO_UNDERLINE BLINK NO_BLINK ),
                                    
                                    # Internal functions:
                                    qw( make_background make_foreground )
                                    
                                    # Experimental methods:
                                    
                                  ]
                     }
                   );

