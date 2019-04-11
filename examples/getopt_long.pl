#!/usr/bin/perl

# Demo of using Log::Selective with Getopt::Long

use strict;
use warnings;

use Getopt::Long;
use Log::Selective;

sub show_usage();


# Parse commandline options

my $help          = undef;
my $verbose       = 0;
my $quiet         = undef;
my $silent        = undef;
my $extra_verbose = undef;
my $color         = 'auto';
my $style         = undef;
my $unbuffer      = undef;

Getopt::Long::Configure ("no_ignore_case", "bundling");

unless ( GetOptions( 
	                   'help|h'          => \$help, 
	                   'verbose|v+'      => \$verbose, 
	                   'quiet|q'         => \$quiet, 
	                   'silent|Q'        => \$silent, 
	                   'extra-verbose=s' => \$extra_verbose, 
	                   'color|c=s'       => \$color, 
	                   'style=s'         => \$style, 
	                   'unbuffer'        => \$unbuffer 
	                 ) ) {
	ERROR("Run '$0 --help' for available options");
	exit;
}


# Configure Log::Selective based on commandline options

set_verbosity($verbose);
be_quiet()  if (defined $quiet);
be_silent() if (defined $silent);

if (defined $extra_verbose) {
	my ($level, $regex) = split ',', $extra_verbose, 2;
	extra_logging($level, $regex);
}

set_color_mode($color);

if ( defined $style ) {
	if ( $style eq 'list' ) {
		print "Available styles:\n";
		print "@{[ get_styles() ]}\n";
		exit;
	} else {
		set_style($style);
		if ( get_style() ne $style ) {
			ERROR( "Unknown style '$style'" );
			exit;
		}
	}
}

unbuffer_output() if (defined $unbuffer);

show_usage() if ( $help );



# Display some output via Log::Selective

LOG( 0, "Run '$0 --help' for available options" );
LOG( 1, "Level 1 debug message" );

sub alpha() {
	LOG( 2, "Level 2 debug message" );
	LOG( 3, "Level 3 debug message" );
}

sub beta() {
	LOG( 4, "Level 4 debug message" );
	LOG( 5, "Level 5 debug message" );
}

alpha();
beta();

WARN( "Warning message" );
ERROR( "Error message" );

exit;



sub show_usage() {
	print <<EOF;
Usage: $0 [OPTIONS]

Options:

--help | -h ............. Display this message

--verbose | -v .......... Increase the amount of logging shown on the console.
                          This option can be given multiple times to show more 
                          detailed information.

--quiet | -q ............ Only show warnings and errors
		
--silent | -Q ........... Show no messages (not even warnings or errors)
		
--extra-verbose=STRING .. Show more verbose output for specific functions
                          The syntax of STRING is "LEVEL,REGEX" where LEVEL is 
                          the maximum verbosity level and REGEX is the regular 
                          expression matching the function names to show extra 
                          verbosity for.
                          
                          For example, to show messages up to level 4 for 
                          alpha() and beta() one could use:
                          --extra-verbose="4,(alph|bet)a"

--color=STRING | ........ Whether to use colors and styles for log messages
-c STRING                 Valid:   'auto', 'on', 'off'
                          Default: 'auto'
                          
                          In 'auto' mode logging messages will only receive 
                          color and styling if output is to a terminal (not a 
                          pipe or a file).  To force color output use 'on', to 
                          force plain text output use 'off'.

--style=STRING .......... Specify the color theme to use for console output
                          or use 'list' to see available styles

--unbuffer .............. Unbuffer logging output

Try running the following to see how Log::Selective handles output:

    $0
    $0 -v
    $0 -vvvvv
    $0 --quiet
    $0 --silent
    $0 --extra-verbose="4,(alph|bet)a"
    $0 | cat
    $0 --color=on | cat
EOF
	exit;
}
