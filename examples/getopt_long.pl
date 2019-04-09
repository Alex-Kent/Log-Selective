#!/usr/bin/perl

# Demo of using Log::Selective with Getopt::Long

use strict;
use warnings;

use Getopt::Long;
use Log::Selective;

sub show_usage();


# Parse commandline options

my $help                      = undef;
my $verbose                   = 0;
my $quiet                     = undef;
my $silent                    = undef;
my $color                     = 'auto';

Getopt::Long::Configure ("no_ignore_case", "bundling");

unless ( GetOptions( 
	                   'help|h'     => \$help, 
	                   'verbose|v+' => \$verbose, 
	                   'quiet|q'    => \$quiet, 
	                   'silent|Q'   => \$silent, 
	                   'color|c=s'  => \$color 
	                 ) ) {
	ERROR("Run '$0 --help' for available options");
	exit;
}


# Configure Log::Selective based on commandline options

set_verbosity($verbose);
be_quiet()  if (defined $quiet);
be_silent() if (defined $silent);

set_color_mode($color);

show_usage() if ( $help );


# Display some output via Log::Selective

LOG( 0, "Run '$0 --help' for available options" );
LOG( 1, "Level 1 debug message" );
LOG( 2, "Level 2 debug message" );
LOG( 3, "Level 3 debug message" );
LOG( 4, "Level 4 debug message" );
WARN( "Warning message" );
ERROR( "Error message" );

exit;


sub show_usage() {
	print <<EOF;
Usage: $0 [OPTIONS]

Options:

--help | -h .......... Display this message

--verbose | -v ....... Increase the amount of logging shown on the console.
                       This option can be given multiple times to show more 
                       detailed information.

--quiet | -q ......... Only show warnings and errors
		
--silent | -Q ........ Show no messages (not even warnings or errors)
		
--color=STRING | ..... Specify whether to use colors and styles for log messages
-c STRING              Valid:   'auto', 'on', 'off'
                       Default: 'auto'
                       
                       In 'auto' mode logging messages will only receive color 
                       and styling if output is to a terminal (not a pipe or a 
                       file).  To force color output use 'on', to force plain 
                       text output use 'off'.

Try running the following to see how Log::Selective handles output:

    $0
    $0 -v
    $0 -vvvv
    $0 --quiet
    $0 --silent
    $0 | cat
    $0 --color=on | cat
EOF
	exit;
}
