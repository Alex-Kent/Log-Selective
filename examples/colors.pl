#!/usr/bin/perl

# ANSI color sampler

use strict;
use warnings;
use Log::Selective;

no_append_newlines( );  # Do not append newlines to strings passed to logging functions

my @colors = ( 
               DEFAULT, 
               BLACK, RED, GREEN, YELLOW, BLUE, MAGENTA, CYAN, LIGHT_GREY, 
               DARK_GREY, BRIGHT_RED, BRIGHT_GREEN, BRIGHT_YELLOW, 
               BRIGHT_BLUE, BRIGHT_MAGENTA, BRIGHT_CYAN, WHITE
             );

my %color_names = (
                    &DEFAULT        => 'default',
                    &BLACK          => 'black', 
                    &RED            => 'red', 
                    &GREEN          => 'green', 
                    &YELLOW         => 'yellow', 
                    &BLUE           => 'blue', 
                    &MAGENTA        => 'magenta', 
                    &CYAN           => 'cyan', 
                    &LIGHT_GREY     => 'light grey', 
                    &DARK_GREY      => 'dark grey', 
                    &BRIGHT_RED     => 'bright red', 
                    &BRIGHT_GREEN   => 'bright green', 
                    &BRIGHT_YELLOW  => 'bright yellow', 
                    &BRIGHT_BLUE    => 'bright blue', 
                    &BRIGHT_MAGENTA => 'bright magenta', 
                    &BRIGHT_CYAN    => 'bright cyan', 
                    &WHITE          => 'white'
                  );

foreach my $back ( @colors ) {
	LOG( 0, "Background: $color_names{$back}\n\n", DEFAULT, DEFAULT, NORMAL );
	LOG( 0, sprintf("%14s  %-11s  %-11s  %-11s  %-11s\n", 'Foreground', 'Normal', 'Bold', 'Underline', 'Bold+UL'), DEFAULT, DEFAULT, NORMAL );
	foreach my $fore (@colors ) {
		LOG( 0, sprintf("%14s", $color_names{$fore}), DEFAULT, DEFAULT, NORMAL );
		LOG( 0, " ",                                  DEFAULT, DEFAULT, NORMAL );
		LOG( 0, " ",                                  $fore, $back, NORMAL );
		LOG( 0, sprintf("%11s", 'ABC abc 123'),       $fore, $back, NORMAL );
		LOG( 0, "  ",                                 $fore, $back, NORMAL );
		LOG( 0, sprintf("%11s", 'ABC abc 123'),       $fore, $back, BOLD );
		LOG( 0, "  ",                                 $fore, $back, NORMAL );
		LOG( 0, sprintf("%11s", 'ABC abc 123'),       $fore, $back, NORMAL, UNDERLINE );
		LOG( 0, "  ",                                 $fore, $back, NORMAL );
		LOG( 0, sprintf("%11s", 'ABC abc 123'),       $fore, $back, BOLD, UNDERLINE );
		LOG( 0, " ",                                  $fore, $back, NORMAL );
		LOG( 0, " ",                                  DEFAULT, DEFAULT, NORMAL );
		LOG( 0, "\n",                                 DEFAULT, DEFAULT, NORMAL );
	}
	LOG( 0, "\n\n", DEFAULT, DEFAULT, NORMAL );
}
