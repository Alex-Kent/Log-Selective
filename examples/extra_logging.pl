#!/usr/bin/perl

# Shows use of the extra_logging(...) function

use strict;
use warnings;

use Log::Selective;


sub A() {
	LOG( 3, "In A()" );
}

sub B() {
	LOG( 3, "In B()" );            # Not output to console
}

sub C() {
	LOG( 3, "In C()" );
}

sub D() {
	LOG( 1, "In D()" );
}


set_verbosity( 1 );                # Normally only show messages at or below level 1
extra_logging( 3, 'A|C' );         # Show up to level 3 for A() and C()

LOG( 0, "Normal output" );
LOG( 1, "Debug output" );
LOG( 2, "More debug output" );     # Not output to console

A(); B(); C(); D();
