#!/usr/bin/perl

# Shows use of all available functions

use strict;
use warnings;
use Log::Selective;


sub A() {  LOG( 1, "In A()" );        B();  }
sub B() {  LOG( 2, "In B()" );        C();  }
sub C() {  LOG( 3, "In C()" );        D();  }
sub D() {  LOG( 4, "In D()" );              }

sub E() {  WARN( "Warning in E()" );  F();  }
sub F() {  ERROR( "Error in F()" );         }


# === Verbosity ================================================================

# ------------------------------------------------------------------------------

my $level = 4;
print "\n\nSetting verbosity to $level\n";

set_verbosity( $level );  # Set the level of logging verbosity

# ------------------------------------------------------------------------------

print "\n\nGetting verbosity...\n";

$level = get_verbosity();  # Returns the current level of logging verbosity

print "Verbosity is $level\n";

# ------------------------------------------------------------------------------

print "\n\nNormal output at verbosity $level:\n";

LOG( 0, "Normal" );
WARN( "Warning" );
ERROR( "Error" );
A();
E();

# ------------------------------------------------------------------------------

print "\n\nOutput in quiet mode:\n";

be_quiet();  # Only output warnings, errors, and (by default) stack traces

LOG( 0, "Normal" );
WARN( "Warning" );
ERROR( "Error" );
A();
E();

# ------------------------------------------------------------------------------

print "\n\nOutput in silent mode:\n";

be_silent();  # Do not output anything.

LOG( 0, "Normal" );
WARN( "Warning" );
ERROR( "Error" );
A();
E();

# ------------------------------------------------------------------------------

print "\n\nSetting verbosity to 0\n";

set_verbosity(0);  # Set verbosity to normal

# ------------------------------------------------------------------------------

print "\n\nNormal output:\n";

LOG( 0, "Normal" );
WARN( "Warning" );
ERROR( "Error" );
A();
E();

# ------------------------------------------------------------------------------

print "\n\nNormal output, extra logging for B() and D():\n";

extra_logging( 4, 'B|D' );  # Selectively use a higher logging level

LOG( 0, "Normal" );
WARN( "Warning" );
ERROR( "Error" );
A();
E();

# ------------------------------------------------------------------------------

print "\n\nNormal output, No extra logging:\n";

no_extra_logging();  # Do not perform extra logging

LOG( 0, "Normal" );
WARN( "Warning" );
ERROR( "Error" );
A();
E();


# === Stack traces =============================================================

print "\n\nStack traces:\n";

sub G() {
	stack_trace();  # Writes a stack trace to the console
}

G();
stack_trace( "Stack trace from main:" );  # Writes a stack trace to the console

# ------------------------------------------------------------------------------

print "\n\nCall trace:\n";

sub H() {
	call_trace();  # Writes an abbreviated stack trace to the console
}

H();

print "\n\nCall trace from main:\n";

call_trace();


# ------------------------------------------------------------------------------

print "\n\nGetting stack trace...\n";

sub I() {
	return get_stack_trace();  # Returns a stack trace as a list
}

my @stack_trace = I();

print "Got stack trace:\n";
print join("\n\n", @stack_trace) . "\n\n";

# ------------------------------------------------------------------------------

print "\n\nGetting call trace...\n";

sub J() {
	return get_call_trace();  # Return an abbreviated call trace as a string
}

my $call_trace = J();

print "Got call trace:\n";
print "$call_trace\n";

# ------------------------------------------------------------------------------

sub K() {
	WARN( "An warning happened in K()" );
	ERROR( "An error happened in K()" );
}

# ------------------------------------------------------------------------------

print "\n\nDefault warnings and errors:\n";

K();

# ------------------------------------------------------------------------------

print "\n\nStack traces on warnings and errors:\n";

stack_trace_on_warnings();  # Control whether warnings generate stack traces
stack_trace_on_errors();  # Control whether errors generate stack traces

K();

# ------------------------------------------------------------------------------

print "\n\nNo stack traces on warnings or errors:\n";

no_stack_trace_on_errors( );    # Do not show a stack trace after errors
no_stack_trace_on_warnings( );  # Do not show a stack trace after warnings.

K();

# ------------------------------------------------------------------------------

sub L() {
	LOG( 1, "At level 1" );
	stack_trace();
	M();
}

sub M() {
	LOG( 2, "At level 2" );
	stack_trace();
	N();
	stack_trace();
}

sub N() {
	LOG( 3, "At level 3" );
	stack_trace();
}

# ------------------------------------------------------------------------------

print "\n\nDefault stack traces output:\n";

stack_trace();
L();

# ------------------------------------------------------------------------------

print "\n\nStack traces displayed at level 0:\n";

set_stack_trace_level( 0 );  # Control how stack traces are displayed

stack_trace();
L();

# ------------------------------------------------------------------------------

print "\n\nStack traces follow last-used level's style:\n";

set_verbosity(4);                # More verbose
set_stack_trace_level( undef );  # Stack trace style follows last-used level's style

LOG( 0, "At level 0" );
stack_trace();
L();




# === Colors and styles ========================================================


print "\n\nColor mode is 'off':\n";

set_color_mode( 'off' );   # Never use colors and styles (plain text output)

WARN( "Warning" );
ERROR( "Error" );
LOG(0, "Level 0");
A();

# ------------------------------------------------------------------------------

print "\n\nColor mode is 'on':\n";

set_color_mode( 'on' );    # Always use colors and styles

WARN( "Warning" );
ERROR( "Error" );
LOG(0, "Level 0");
A();

# ------------------------------------------------------------------------------

print "\n\nColor mode is 'auto':\n";

set_color_mode( 'auto' );  # Automatically decide when to use colors and styles

WARN( "Warning" );
ERROR( "Error" );
LOG(0, "Level 0");
A();

# ------------------------------------------------------------------------------

print "\n\nSetting levels' colors and styles is not yet implemented\n";

#set_colors( \%colors ); # Specify the colors and styles used at each log level

# ------------------------------------------------------------------------------

print "\n\nUser-supplied newlines for log messages:\n";

no_append_newlines( );  # Do not append newlines to strings passed to logging functions

LOG(0, "Multiple ");
LOG(1, "log ");
LOG(2, "messages\n");

# ------------------------------------------------------------------------------

print "\n\nLog::Selective appends newlines to all log messages:\n";

append_newlines();  # Append newlines to log messages

LOG(0, "Multiple ");
LOG(1, "log ");
LOG(2, "messages");




# === Output file handles ======================================================

print "\n\nAll output to STDOUT:\n";

log_to     ( \*STDOUT );
warnings_to( \*STDOUT );
errors_to  ( \*STDOUT );

LOG( 0, "Normal message" );
WARN( "Warning" );
ERROR( "Error" );

# ------------------------------------------------------------------------------

print "\n\nAll output to STDERR:\n";

log_to     ( \*STDERR );
warnings_to( \*STDERR );
errors_to  ( \*STDERR );

LOG( 0, "Normal message" );
WARN( "Warning" );
ERROR( "Error" );

# ------------------------------------------------------------------------------

if (0) {
	print "\n\nLogging output can be written to a file:\n";
	
	print "Logging to 'log.txt'\n";
	
	my $LOG;
	open $LOG, ">log.txt";
	
	log_to     ($LOG);
	warnings_to($LOG);
	errors_to  ($LOG);
	
	LOG( 0, "Normal message" );
	WARN( "Warning" );
	ERROR( "Error" );
	
	close $LOG;
}

# ------------------------------------------------------------------------------

print "\n\nDefault (normal and verbose output to STDOUT, warnings and errors to STDERR):\n";

log_to     ( \*STDOUT );
warnings_to( \*STDERR );
errors_to  ( \*STDERR );

LOG( 0, "Normal message" );
WARN( "Warning" );
ERROR( "Error" );




# === Logging functions ========================================================


print "\n\nNormal log message:\n";

LOG( 0, "Normal log message" );

# ------------------------------------------------------------------------------

print "\n\nColors and style applied to log message:\n";

LOG( 0, "Text with styles applied", CYAN, WHITE, BOLD, UNDERLINE, BLINK );

# ------------------------------------------------------------------------------

print "\n\nWarning message:\n";

WARN( "Something odd happened" );

# ------------------------------------------------------------------------------

print "\n\nError message:\n";

ERROR( "Something bad happened" );

# ------------------------------------------------------------------------------

print "\n\nShow all warnings that were encountered:\n";

show_warnings( );  # Write saved warning messages to the console

# ------------------------------------------------------------------------------

print "\n\nShow all errors that were encountered:\n";

show_errors( );  # Write saved error messages to the console

# ------------------------------------------------------------------------------

print "\n\nGet list of all warnings that were encountered:\n";

my @warnings = get_warnings();  # Returns the list of saved warning messages

print "Encountered ".scalar(@warnings)." warnings\n";

# ------------------------------------------------------------------------------

print "\n\nGet list of all errors that were encountered:\n";

my @errors = get_errors( );  # Returns the list of saved error messages

print "Encountered ".scalar(@errors)." errors\n";
