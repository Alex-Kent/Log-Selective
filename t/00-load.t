#!perl
# was: #!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Log::Selective' ) || print "Bail out!
";
}

diag( "Testing Log::Selective $Log::Selective::VERSION, Perl $], $^X" );
