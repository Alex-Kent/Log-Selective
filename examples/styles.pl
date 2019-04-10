#!/usr/bin/perl

# Shows use of styles

use strict;
use warnings;

use Log::Selective;

log_to     (\*STDOUT);
warnings_to(\*STDOUT);
errors_to  (\*STDOUT);
set_verbosity(5);
set_color_mode('on');   # Force use of color
no_append_newlines( );  # Do not append newlines to strings passed to logging functions

my @styles = get_styles();
my $max_len = 0;
map { $max_len=length($_) if (length($_) > $max_len); } @styles;

my %custom_style = (
                     'description' => 'Custom style',
                     '<0'  =>  [  RED,            undef,   BOLD   | BLINK  ], 
                     '-3'  =>  [  MAGENTA,        WHITE,   BOLD            ], 
                     '-2'  =>  [  RED,            ';240',  BOLD   | BLINK  ], 
                     '-1'  =>  [  BRIGHT_YELLOW,  ';240',  NORMAL | BLINK  ], 
                      '0'  =>  [  undef,          undef,   BOLD            ], 
                      '1'  =>  [  undef,          undef,   NORMAL          ], 
                      '2'  =>  [  BRIGHT_GREEN,   ';240',  BOLD            ], 
                      '3'  =>  [  GREEN,          ';240',  NORMAL          ], 
                      '4'  =>  [  CYAN,           ';240',  NORMAL          ], 
                     '>0'  =>  [  BRIGHT_CYAN,    ';240',  NORMAL          ]
                   );

foreach my $style ( @styles, undef, 'custom' ) {
	
	if ( ! defined $style ) {
		print "\n";
		next;
		
	} elsif ( $style eq 'custom' ) {
		set_style( \%custom_style );
		
	} else {
		set_style( $style );
	}
	
	printf( "%${max_len}s ", $style);
	LOG( -3, " Stack " );
	LOG( -2, " Error " );
	LOG( -1, " Warning " );
	LOG(  0, " Normal " );
	LOG(  1, " <L1> " );
	LOG(  2, " <L2> " );
	LOG(  3, " <L3> " );
	LOG(  4, " <L4> " );
	LOG(  5, " <L5> " );
	print "\n";
}
