package Log::Selective;


# Log::Selective
# Copyright 2019 Alexander Hajnal, All rights reserved
# 
# Alex Kent Hajnal
# --------------------------------------
# akh@cpan.org
# https://alephnull.net/software
# https://github.com/Alex-Kent/Log-Selective
# 
# This module is free software; you can redistribute it and/or modify it under 
# the same terms as Perl itself.  See the LICENSE file or perlartistic(1).


use strict;
use warnings;

=encoding utf8

=head1 NAME

Log::Selective - Selective logging to the console.

=cut

use vars qw ($VERSION);
$VERSION = 'v0.0.1';

=head1 VERSION

This document describes Log::Selective version 0.0.1

=head1 DESCRIPTION

Log::Selective is a way for commandline programs to display status messages.  
The level of verbosity can be controlled without having to change the program's 
code.  Messages at different levels of verbosity can have different colors and 
styles applied.  The module also allows extra verbosity for specific functions 
or methods.

Some additional functions are also provided.  A summary of all warnings or 
errors that were encountered can be displayed.  Stack traces can been shown 
either on demand or whenever there are warnings or errors.


=head1 USAGE

=head3 Basic usage

  use Log::Selective;
  set_verbosity( 1 );                # Only show messages at or below level 1
  
  LOG( 0, "Normal output" );
  LOG( 1, "Debug output" );
  LOG( 2, "More debug output" );     # Not output to console
  WARNING( "Foo looks funny" );
  ERROR( "Bar not found" );
  
  LOG( 0, "All done" );
  show_warnings();                   # Show summary of warnings
  show_errors();                     # Show summary of errors

Further examples can be found in the C<examples/> directory.

=head3 Non-Unix platforms

This module should be usable on Windows platforms by including the following in your script:

=over

C<use Win32::Console::ANSI;>

=back

Note that use of this module on Windows has not been tested by the author.

=head3 Logging

Each time a logging call is made the Lib::Selective compare's the message's log 
level to the current verbosity level.  If the message's level is the same or 
lower than the current verbosity it is displayed, if not it is discarded.

Logging level C<0> is for normal messages, level C<-1> is for warnings, and C<-2> 
is for errors.  Levels C<1> and greater are meant for more verbose or debug 
output with higher levels being more verbose.  By default, stack traces use 
level C<-3>.

By default the verbosity level is C<0>.  This can be changed using 
C<L<set_verbosity(...)|/set_verbosity(_..._)>> to set the verbosity to an 
arbitrary level, C<L<be_quiet()|/be_quiet(_)>> to only display warnings and 
errors, or C<L<be_silent()|/be_silent(_)>> to disable all logging output.  The 
current verbosity can be determined using C<L<get_verbosity()|/get_verbosity(_)>>.

The logging level for messages is specified via the logging call.  For 
C<L<LOG(...)|/LOG(_..._)>> the logging level is explicitly specified in the call, 
for C<L<WARN(...)|/WARN(_..._)>> and C<L<WARNING(...)|/WARNING(_..._)>> it is set 
to C<-1>, and for C<L<ERROR(...)|/ERROR(_..._)>> it is set to C<-2>.  Stack 
traces, whether explicitly or automatically generated, are output at level C<-3> 
by default; this can be changed using C<L<set_stack_trace_level(...)|/set_stack_trace_level(_..._)>>.

When messages are logged using C<L<WARN(...)|/WARN(_..._)>> or C<L<WARNING(...)|/WARN(_..._)>> 
a copy of the message is saved to a list.  The contents of this list can be 
displayed to the console (at the warning log level C<-1>) using C<L<show_warnings()|/show_warnings(_)>>.  
Typically this will be done at the end of a program's run.  Likewise, when 
messages are logged using C<L<ERROR(...)|/ERROR(_..._)>> a copy of the message 
is saved to a separate list.  The contents of this list can be displayed to the 
console (at the error log level C<-2>) using C<L<show_errors()|/show_errors(_)>>.
The contents of the two lists can be retrieved using C<L<get_warnings()|/get_warnings(_)>> and 
C<L<get_errors()|/get_errors(_)>>.

=head3 Extra logging for select functions

Extra logging verbosity can be specified for specific functions or methods.
This done using C<L<extra_logging(...)|/extra_logging(_..._)>> which is given an extended logging level 
along with a regex specifying which functions to show extra output for.  For
example:

  sub A() {
      LOG( 3, "In A()" );
  }
  
  sub B() {
      LOG( 3, "In B()" );       # Not output to console
  }
  
  sub C() {
      LOG( 3, "In C()" );
  }
  
  sub D() {
      LOG( 1, "In D()" );
  }
  
  use Log::Selective;
  set_verbosity(1);             # Normally only show levels 1 and below
  extra_logging(3, 'A|C');      # Show up to level 3 for A() and C()
  
  A(); B(); C(); D();

This outputs:

  In A()
  In C()
  In D()

=head3 Stack traces

To get stack traces one can use:

  # Immediately output a stack trace
  stack_trace();
  
  # Request stack traces when warnings or errors occur:
  stack_trace_on_warnings();
  stack_trace_on_errors();

The C<L<set_stack_trace_level(...)|/set_stack_trace_level(_..._)>> function can be used to control when and how 
stack traces are displayed.

The call stack can also be displayed in abbreviated form using C<L<call_trace()|/call_trace(_)>>.

Full stack traces and abbreviated stack traces can be gotten in list or string 
form using C<L<get_stack_trace()|/get_stack_trace(_)>> and C<L<get_call_trace()|/get_call_trace(_)>>, 
respectively.

=head3 Output locations

By default, output is to the console using C<STDOUT> for regular messages and 
C<STDERR> for warnings, errors, and stack traces.  The C<L<log_to(...)|/log_to(_..._)>>, 
C<L<warnings_to(...)|/warnings_to(_..._)>>, and C<L<errors_to(...)|/errors_to(_..._)>> 
functions can be used to change this.  For example, to write all output to 
C<STDOUT> one could use:

  log_to      (\*STDOUT);  # This is the default
  warnings_to (\*STDOUT);
  errors_to   (\*STDOUT);

=head3 Output colors and styles

The colors and styles used at each logging level is currently fixed.  In future 
these will be settable using the C<L<set_colors(...)|/set_colors(_..._)>> 
function.  Custom colors and styling can, however, be specified for an 
individual message using the long form of C<L<LOG(...)|/LOG(_..._)>>.

Most terminals support coloring and styling.  For those that don't one can use 
C<L<set_color_mode('off');|/set_color_mode(_..._)>> to force the use of plain text for all output.

By default all log messages have a newline (C<\n>) appended.  If you want to 
manually add newlines in your own code, call C<L<no_append_newlines()|/no_append_newlines(_)>> or 
C<L<append_newlines(0)|/append_newlines(_..._)>> to disable the automatic ones.  To re-enable adding of 
newlines call C<L<append_newlines()|/append_newlines(_..._)>> or  C<L<append_newlines(1)|/append_newlines(_..._)>>.


=head3 Colors

16-color support (ANSI colors) is ubiquitous; to specify these colors use the 
constants provided by this module (see B<Constants>, below).

Many terminals support 8-bit color.  To specifiy this one should use "C<;I<NNN>>" 
where C<I<NNN>> is the decimal color to use (0..255).  The available colors are:

  0-7     -> Standard colors:
             BLACK, RED, GREEN, YELLOW, BLUE, MAGENTA, CYAN, WHITE
             
  8-15    -> Bright colors:
             BRIGHT_BLACK, BRIGHT_RED, BRIGHT_GREEN, BRIGHT_YELLOW, 
             BRIGHT_BLUE, BRIGHT_MAGENTA, BRIGHT_CYAN, BRIGHT_WHITE
             
  16-231  -> 216 color cube (6x6x6)
             The equation to determine the values is:
             16 + ( 36 * r ) + ( 6 * g ) + b
             where r, g, and b are in the range 0 to 5
             
  232-255 -> 24 greyscale values (dark to light, excluding black and white)
             To determine the value given an intensity between 0.0 and 1.0:
             $value = int($intensity * 25.0);
             $value = ( $value <= 0 )  ? 0
                    : ( $value >= 25 ) ? 15
                    :                    $value + 231;

Not many terminals suport 24-bit color.  To specify this one should use 
"C<;I<RRR>;I<GGG>;I<BBB>>" where C<I<RRR>> is the red component, C<I<GGG>> is 
the green component, and C<I<RRR>> is the green component (all values are 0.255).

=head3 Constants

Note that these constants currently have similar values to the ANSI ones but 
this may change in future.  The user should not rely on them having any 
particular value.

The following constants are used to specify text colors and styles:

=over

=over

=item To specify use of the default color:

  DEFAULT

=item Greys:

  BLACK         DARK_GREY       LIGHT_GREY        WHITE

These correspond to the ANSI colors BLACK, BRIGHT_BLACK, WHITE, and 
BRIGHT_WHITE, respectively.

=item Normal colors:

  RED           GREEN           YELLOW
  BLUE          MAGENTA         CYAN


=item Bright colors:

  BRIGHT_RED    BRIGHT_GREEN    BRIGHT_YELLOW
  BRIGHT_BLUE   BRIGHT_MAGENTA  BRIGHT_CYAN

=item Font weight:

  FAINT         NORMAL          BOLD

Almost no terminals support C<FAINT>

=item Underlining:

  UNDERLINE     NO_UNDERLINE

=item Italic:

  ITALIC        NO_ITALIC

Very few terminals support C<ITALIC>.  The only one known to the author that 
does is C<rxvt> (though using italics with it will remove any underlining).

=item Blink:

  BLINK         NO_BLINK

Note that blink does not work in C<rxvt> when a background color is specified.
Some terminals stop blinking text when the window is not focused; with C<xterm> 
blinking text might not be visible when the window does not have focus.

=back

=back



=head3 Importing functions


Functions can always be called using a long form C<Log::Selective-E<gt>function()>.
Likewise, constants can always be specified using a long form C<Log::Selective-E<gt>CONSTANT>.
If a function or constant has been imported one can also use the short forms C<function()> 
and C<CONSTANT>, respectively.

To import everything in C<Log::Selective> into your namespace use:

=over

C<use Log::Selective;>

=back

One can also selectively import symbols using:

=over

C<use Log::Selective qw( I<SYMBOLS> );>.  

=back

Any desired functions or constants to import should be listed in C<I<SYMBOLS>> 
(space-delimited).  In addition, the following shortcuts are available:

=over

=item * B<C<:constants>> E<rarr> Color and style constants

These are described in B<Constants>, below.

=item * B<C<:loggers>> E<rarr> Logging functions

These are:

  LOG    WARN    WARNING    ERROR

=item * B<C<:minimal>> E<rarr> Logging functions and basic functions

These are the logging functions plus:

  set_verbosity    show_warnings
  get_verbosity    show_errors
  set_color_mode   stack_trace
  extra_logging    call_trace

=item * B<C<:typical>> E<rarr> Constants, logging functions, and basic functions

This is the same as C<:constants :minimal>

=item * B<C<:all>> E<rarr> All constants and functions (this is the default)

Everything included by C<:typical> plus the following functions:

  log_to              stack_trace_on_warnings
  warnings_to         stack_trace_on_errors
  errors_to           no_stack_trace_on_warnings
  be_quiet            no_stack_trace_on_errors
  be_silent           set_stack_trace_level
  append_newlines     get_stack_trace
  no_append_newlines  get_call_trace
  no_extra_logging    get_warnings
  set_colors          get_errors

=back



=head1 FUNCTIONS


=head3 Logging

C<L<B<LOG( $level, $message>, $fore, $back, \@style B<)>|/LOG(_..._)>>

=over

Selectively write a message to the console

=back

B<C<L<WARN( $message )|/WARN(_..._)>>>

=over

Write a warning message to the console.

=back

B<C<L<ERROR( $message )|/ERROR(_..._)>>>

=over

Write a error message to the console

=back

B<C<L<show_warnings( )|/show_warnings(_)>>>

=over

Write saved warning messages to the console

=back

B<C<L<show_errors( )|/show_errors(_)>>>

=over

Write saved error messages to the console

=back

B<C<L<get_warnings( )|/get_warnings(_)>>>

=over

Returns the list of saved warning messages

=back

B<C<L<get_errors( )|/get_errors(_)>>>

=over

Returns the list of saved error messages

=back

=head3 Verbosity

B<C<L<set_verbosity( $level )|/set_verbosity(_..._)>>>

=over

Set the level of logging verbosity

=back

B<C<L<get_verbosity( )|/get_verbosity(_)>>>

=over

Returns the current level of logging verbosity

=back

B<C<L<be_quiet( )|/be_quiet(_)>>>

=over

Only output warnings, errors, and (by default) stack traces

=back

B<C<L<be_silent( )|/be_silent(_)>>>

=over

Do not output anything.

=back

B<C<L<extra_logging( $verbosity, $pattern )|/extra_logging(_..._)>>>

=over

Selectively use a higher logging level

=back

B<C<L<no_extra_logging( )|/no_extra_logging(_)>>>

=over

Do not perform extra logging

=back

=head3 Colors and styles

B<C<L<set_color_mode( $mode )|/set_color_mode(_..._)>>>

=over

Choose when colors and styles are used

=back

B<C<L<set_colors( \%colors )|/set_colors(_..._)>>>

=over

Specify the colors and styles used at each log level

=back

C<L<B<append_newlines( >$switchB< )>|/append_newlines(_..._)>>

=over

Choose whether to append newlines to log messages

=back

B<C<L<no_append_newlines( )|/no_append_newlines(_)>>>

=over

Do not append newlines to strings passed to logging functions

=back

=head3 Output file handles

B<C<L<log_to( $handle )|/log_to(_..._)>>>

=over

Specify handle to write normal log output to

=back

B<C<L<warnings_to( $handle )|/warnings_to(_..._)>>>

=over

Specify handle to write warnings to

=back

B<C<L<errors_to( $handle )|/errors_to(_..._)>>>

=over

Specify handle to write errors (and, by default, stack traces) to

=back

=head3 Stack traces

C<L<B<stack_trace(> $message B<)>|/stack_trace(_..._)>>

=over

Writes a stack trace to the console

=back

C<L<B<get_stack_trace( )>|/get_stack_trace(_)>>

=over

Returns a stack trace as a list

=back

B<C<L<call_trace( )|/call_trace(_)>>>

=over

Writes an abbreviated stack trace to the console

=back

B<C<L<get_call_trace( )|/get_call_trace(_)>>>

=over

Return an abbreviated call trace as a string

=back

B<C<L<set_stack_trace_level( $level )|/set_stack_trace_level(_..._)>>>

=over

Control how stack traces are displayed

=back

C<L<B<stack_trace_on_warnings( >$switchB< )>|/stack_trace_on_warnings(_..._)>>

=over

Control whether warnings generate stack traces

=back

B<C<L<no_stack_trace_on_warnings( )|/no_stack_trace_on_warnings(_)>>>

=over

Do not show a stack trace after warnings.

=back

C<L<B<stack_trace_on_errors( >$switchB< )>|/stack_trace_on_errors(_..._)>>

=over

Control whether errors generate stack traces

=back

B<C<L<no_stack_trace_on_errors( )|/no_stack_trace_on_errors(_)>>>

=over

Do not show a stack trace after errors

=back

=cut



# *** Export functions ***

use Exporter 'import';

my @constants  = qw( FAINT  NORMAL  BOLD  BLACK  DARK_GREY  LIGHT_GREY  WHITE  RED  GREEN  YELLOW  BLUE  MAGENTA  CYAN  BRIGHT_RED  BRIGHT_GREEN  BRIGHT_YELLOW  BRIGHT_BLUE  BRIGHT_MAGENTA  BRIGHT_CYAN  DEFAULT  NO_UNDERLINE  UNDERLINE  NO_ITALIC  ITALIC  NO_BLINK  BLINK );
my @logggers   = qw( LOG  WARN  WARNING  ERROR );
my @basic      = qw( set_verbosity  get_verbosity  set_color_mode  extra_logging  show_warnings  show_errors  stack_trace  call_trace );
my @extra      = qw( 
                     log_to  warnings_to  errors_to  
                     be_quiet  be_silent  
                     append_newlines  no_append_newlines  
                     stack_trace_on_warnings  stack_trace_on_errors  
                     no_stack_trace_on_warnings  no_stack_trace_on_errors  
                     set_stack_trace_level  
                     no_extra_logging  
                     get_stack_trace  get_call_trace
                     get_warnings  get_errors
                     set_colors
                   );
my @functions = ( @logggers, @basic, @extra );

our @EXPORT      = ( @constants, @functions );
our @EXPORT_OK   = ( );

our %EXPORT_TAGS = (
                     'constants'          => [ @constants                            ],
                     'minimal'            => [             @logggers, @basic         ],
                     'typical'            => [ @constants, @logggers, @basic         ],
                     'all'                => [ @constants, @logggers, @basic, @extra ]
                  );




# *** Define colors and styles ***

# === Used for LOG(...) function ===


# === Text foreground and background colors ===


# === Basic colors ===

#. Actual foreground/background codes in comments, traditional names in quotes  
#.                                                                              
#. Virtually all terminals support this mode                                    

use constant BLACK           => 0;  # 30 / 40   "Black"
use constant DARK_GREY       => 60; # 90 / 100  "Bright black"
use constant LIGHT_GREY      => 7;  # 37 / 47   "White"
use constant WHITE           => 67; # 97 / 107  "Bright white"

use constant RED             => 1;  # 31 / 41   "Red"
use constant GREEN           => 2;  # 32 / 42   "Green"
use constant YELLOW          => 3;  # 33 / 43   "Yellow"
use constant BLUE            => 4;  # 34 / 44   "Blue"
use constant MAGENTA         => 5;  # 35 / 45   "Magenta"
use constant CYAN            => 6;  # 36 / 46   "Cyan"

use constant BRIGHT_RED      => 61; # 91 / 101  "Bright red"
use constant BRIGHT_GREEN    => 62; # 92 / 102  "Bright green"
use constant BRIGHT_YELLOW   => 63; # 93 / 103  "Bright yellow"
use constant BRIGHT_BLUE     => 64; # 94 / 104  "Bright blue"
use constant BRIGHT_MAGENTA  => 65; # 95 / 105  "Bright magenta"
use constant BRIGHT_CYAN     => 66; # 96 / 106  "Bright cyan"

use constant DEFAULT         => 9;  # 39 / 49   Default foreground or background


# === 8-bit color ===

#. Most terminals support this mode                                             
#.                                                                              
#. For 8-bit color use ";N" where N specifies the color:                        
#.                                                                              
#.   0-7     -> Standard colors                                                 
#.   8-15    -> Bright colors                                                   
#.   16-231  -> 216 color cube (6x6x6)                                          
#.   232-255 -> 24 greyscale values (excluding black and white)                 
#.                                                                              
#. See https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit for exact colors    


# === 24-bit color ===

#. Few terminals support this mode                                              
#.                                                                              
#. For 24-bit color use ";R;G;B" where R, G, and B specify the color's red,     
#. green, and blue component (each an integer string between 0 and 255).        



# === Font weight ===
use constant FAINT     => 2;  # Not implimented on many terminals
use constant NORMAL    => 22;
use constant BOLD      => 1;


# === Underline ===
use constant NO_UNDERLINE => 24;
use constant UNDERLINE    => 4;


# === ITALIC ===
use constant NO_ITALIC   => 23;
use constant ITALIC      => 3;   # Not implimented on many terminals


# === Blink ===
use constant NO_BLINK     => 25;
use constant BLINK        => 5;


# *** Global variables ***

# Errors encountered are stored in this array
# They can be output using show_errors()
my @errors = ();

# Warnings encountered are stored in this array
# They can be output using show_warnings()
my @warnings = ();

my $VERBOSE = 0;                # Current verbosity level; only messages at or lower than this level will be shown
my $OUTPUT = *STDOUT;           # File handle to send normal messages to (when level >= 0)
my $WARNINGS = *STDERR;         # File handle to send warning-level messages to (when level == -1)
my $ERRORS = *STDERR;           # File handle to send error-level messages to (when level < -1)
my $STACKTRACE_ON_WARNINGS = 0; # If true then append a stack trace for all calls to WARN(...) or WARNING(...)
my $STACKTRACE_ON_ERRORS = 0;   # If true then append a stack trace for all calls to ERROR(...)
my $COLOR_MODE = 'auto';        # Whether to output colors and styles (One of 'auto', 'on', or 'off')
my $NEWLINE = "\n";             # Appended to all log messages (may be the empty string)
my $EXTRA_VERBOSITY = undef;    # Maximum log level to display when extra logging is active
my $EXTRA_PATTERN = undef;      # Regular expression matching functions to be included in extra logging
my $LAST_SEEN_LEVEL  = undef;   # Keeps track of last used log level for stack_trace's sake
my $STACKTRACE_LEVEL = -3;      # The log level to use for stack traces (undef = last seen level)





# .-----------.
# |  Logging  |
# '-----------'


=head2 LOG( ... )

=over

C<LOG( $level, $message );>

C<LOG( $level, $message, $fore, $back, @style );>

Selectively write a message to the console

The specified C<$message> will only be displayed if the specified log C<$level> 
is either of:

=over

=item * No higher than the current logging verbosity (as set with C<L<set_verbosity(...)|/set_verbosity(_..._)>>)

=item * No higher than the current extra logging verbosity and the calling 
functions match the extra logging pattern.  
See C<L<extra_logging(...)|/extra_logging(_..._)>> for details.

=back

The message shown will be colored and styled as appropriate for its level.

Output coloring and styling will only be done if the current color mode is 'C<on>' 
or is 'C<auto>' and the output is going to a terminal.  The colors and styles 
used at each level can be specified using C<L<set_colors(...)|/set_colors(_..._)>>.

To specify specific colors and styling for a single log message one can use the 
second (longer) syntax of this function.  The C<$fore> and C<$back> colors are 
as described in the B<Colors> section, above.  Any custom styling can be passed 
via C<@style> (note that this is not a reference) with the styles being as 
described in B<Constants>, above.  Any colors or styles that would normally be 
used for a given log message will remain in effect unless explicitly overridden.

=back

=cut


sub LOG($$;$$$@) {
	my ( $level, $message, $FORE, $BACK, @STYLE );
	if ( $_[0] eq 'Log::Selective' ) {
		( undef, $level, $message, $FORE, $BACK, @STYLE ) = @_;
	} else {
		( $level, $message, $FORE, $BACK, @STYLE ) = @_;
	}
	
	if (defined $EXTRA_VERBOSITY) {
		# Check whether logging should be extra verbose
		my @path = ();
		my $n=1;
		while (1) {
			my (undef, undef, undef, $subroutine, undef, undef, undef, undef, undef, undef, undef) = caller($n);
			last unless (defined $subroutine);
			push @path, $subroutine;
			$n++;
		}
		my $path = join ' ', reverse @path;
		
		if ( $path =~ /(?:$EXTRA_PATTERN)/) {
			return unless ( ( $VERBOSE >= $level) || ( $EXTRA_VERBOSITY >= $level ) );
		} else {
			return unless ( $VERBOSE >= $level);
		}
		
	} else {
		# Normal verbosity
		return unless ( $VERBOSE >= $level);
	}
	
	# Record level for stack_trace's sake
	$LAST_SEEN_LEVEL = $level;
	
	my %SUPPLIED_STYLE = ();
	map { $SUPPLIED_STYLE{$_} = 1 } @STYLE;
	
	@STYLE = ();
	
	
	if (
	     ( ( $COLOR_MODE eq 'auto' ) && ( -t $OUTPUT ) ) ||
	       ( $COLOR_MODE eq 'on' )
		 ) {
		
		$FORE         = ( defined $FORE ) 
		                ? ($FORE =~ /^;\d+;\d+;\d+$/)           ? "38;2;$FORE"  # 24-bit color:
		                                                                      #   ;R;G;B
		                                                                      #   R, G, B -> Red, Green and Blue compentent (0 .. 255)
		                  : ($FORE =~ /^;\d+$/)                 ? "38;5;$FORE"  # 8-bit color:
		                                                                        #   0-7     -> Standard colors
		                                                                        #   8-15    -> Bright colors
		                                                                        #   16-231  -> 216 color cube (6x6x6)
		                                                                        #   232-255 -> 24 greyscale values (excluding black and white)
		                  : ($FORE == DEFAULT)                  ? undef         # Forced default foreground color
		                  :                                       30 + $FORE    # Forced foreground color
		                : ($level < -2)                         ? 30 + MAGENTA  # Fix me: Magenta text
		                : ($level <  0)                         ? 30 + RED      # Error:  Red text
		                : ($level == 0)                         ? 30 + BLUE     # Blue text
		                : ($level == 1)                         ? undef         # Default text color
		                : ($level == 2)                         ? 30 + YELLOW   # Yellow text
		                : ($level == 3)                         ? 30 + CYAN     # Cyan text
		                :                                         undef;        # No special foreground color
		
		$BACK         = ( defined $BACK ) 
		                ? ($BACK =~ /^;\d+;\d+;\d+$/)           ? "48;2;$BACK"  # 24-bit color:
		                                                                        #   ;R;G;B
		                                                                        #   R, G, B -> Red, Green and Blue compentent (0 .. 255)
		                  : ($BACK =~ /^;\d+$/)                 ? "48;5;$BACK"  # 8-bit color:
		                                                                        #   0-7     -> Standard colors
		                                                                        #   8-15    -> Bright colors
		                                                                        #   16-231  -> 216 color cube (6x6x6)
		                                                                        #   232-255 -> 24 greyscale values (excluding black and white)
		                  : ($BACK == DEFAULT)                  ? undef         # Forced default background color
		                  :                                       40 + $BACK    # Forced background color
		                :                                         undef;        # No special background color
		
		my $BOLD      = ( $SUPPLIED_STYLE{(&FAINT)} )           ? FAINT         # Forced faint
		              : ( $SUPPLIED_STYLE{(&NORMAL)} )          ? NORMAL        # Forced normal
		              : ( $SUPPLIED_STYLE{(&BOLD)} )            ? BOLD          # Forced bold
		              : ($level <  0)                           ? BOLD          # <0: Bold text (Fix me, Error)
		              : ($level == 0)                           ? BOLD          #  0: Bold text
		              : ($level == 2)                           ? BOLD          #  3: Bold text (i.e. yellow not brown)
		              :                                           undef;        # No special text style
		
		my $UNDERLINE = ( $SUPPLIED_STYLE{&NO_UNDERLINE} ) ? NO_UNDERLINE
		              : ( $SUPPLIED_STYLE{&UNDERLINE} )    ? UNDERLINE
		              :                                           undef;
		
		my $ITALIC    = ( $SUPPLIED_STYLE{&NO_ITALIC} )    ? NO_ITALIC
		              : ( $SUPPLIED_STYLE{&ITALIC} )       ? ITALIC
		              :                                           undef;
		
		my $BLINK     = ( $SUPPLIED_STYLE{&NO_BLINK} )     ? NO_BLINK
		              : ( $SUPPLIED_STYLE{&BLINK} )        ? BLINK
		              :                                          undef;
		
		push @STYLE, $FORE      if (defined $FORE);
		push @STYLE, $BACK      if (defined $BACK);
		push @STYLE, $BOLD      if (defined $BOLD);
		push @STYLE, $ITALIC    if (defined $ITALIC);
		push @STYLE, $UNDERLINE if (defined $UNDERLINE);
		push @STYLE, $BLINK     if (defined $BLINK);
	}
	
	my $TO = ( $level < -1 ) ? $ERRORS
	       : ( $level <  0 ) ? $WARNINGS
	       :                   $OUTPUT;
	
	$message .= $NEWLINE;
	
	if (scalar @STYLE) {
		my $ON  = "\e[" . join(';', @STYLE) . "m";
		my $OFF = "\e[0m";
		$message =~ s/\n/${OFF}\n${ON}/gs;
		print $TO "${ON}${message}${OFF}";
	} else {
		print $TO $message;
	}
}



=head2 WARN( ... )

=over

C<WARN( $message );>

C<WARNING( $message );>

Write a warning message to the console.

Logging is done via C<L<LOG(...)|/LOG(_..._)>> so all of its effects apply.
The log level used is C<-1>.
Optionally, a stack trace will be output after the message; see 
C<L<stack_trace_on_warnings(...)|/stack_trace_on_warnings(_..._)>>.

All warnings will be saved to a list irrespective of whether they are 
displayed.  The list can be output to the console using C<L<show_warnings( )|/show_warnings(_)>>; 
this can be useful for showing an error summary at the end of a program's run.
The list can also be retrieved using C<L<get_warnings( )|/get_warnings(_)>>.

=back

=cut

sub WARN($) {
	my ($message) = ( $_[0] eq 'Log::Selective' )
	              ? $_[1]
	              : $_[0];
	
	LOG(-1, $message, RED, DEFAULT, NORMAL);
	push @warnings, $message;
	if ($STACKTRACE_ON_WARNINGS) {
		stack_trace();
		push @warnings, get_stack_trace();
	}
}



=head2 ERROR( ... )

=over

C<ERROR( $message );>

Write a error message to the console

Logging is done via C<L<LOG(...)|/LOG(_..._)>> so all of its effects apply.
The log level used is C<-2>.
Optionally, a stack trace will be output after the message; see 
C<L<stack_trace_on_errors(...)|/stack_trace_on_errors(_..._)>>.

All error messages will be saved to a list irrespective of whether they are 
displayed.  The list can be output to the console using C<L<show_errors( )|/show_errors(_)>>; 
this can be useful for showing an error summary at the end of a program's run.
The list can also be retrieved using C<L<get_errors( )|/get_errors(_)>>.  

=back

=cut

sub ERROR($) {
	my ($message) = ( $_[0] eq 'Log::Selective' )
	              ? $_[1]
	              : $_[0];
	
	LOG(-2, $message, RED, DEFAULT, BOLD);
	push @errors, $message;
	if ($STACKTRACE_ON_ERRORS) {
		stack_trace();
		push @errors, get_stack_trace();
	}
}



# Function aliases

sub WARNING;  *WARNING = *WARN;

#sub Log;      *Log     = *LOG;
#sub Warn;     *Warn    = *WARN;
#sub Warning;  *Warning = *WARN;
#sub Error;    *Error   = *ERROR;



=head2 show_warnings( )

=over

C<show_warnings( );>

Write saved error messages to the console

All warnings logged using C<L<WARN(...)|/WARN(_..._)>> or C<L<WARNING(...)|/WARN(_..._)>> 
are saved to a list.  This function outputs that list to the console; this can 
be useful for showing a warning summary at the end of a program's run.

=back

=cut

sub show_warnings() {
	if (scalar @warnings) {
		if ($VERBOSE >= 0) {
			LOG(-1, "Warnings encountered:\n" . join($NEWLINE, @warnings) );
		}
	}
}

#sub ShowWarnings; *ShowWarnings = *show_warnings;




=head2 show_errors( )

=over

C<show_errors( );>

Write saved error messages to the console

All error messages logged using C<L<ERROR(...)|/ERROR(_..._)>> are saved to a 
list.  This function outputs that list to the console; this can be useful for 
showing an error summary at the end of a program's run.

=back

=cut

sub show_errors() {
	if (scalar @errors) {
		if ($VERBOSE >= 0) {
			LOG(-2, "Errors encountered:\n" . join($NEWLINE, @errors) );
		}
	}
}

#sub ShowErrors; *ShowErrors = *show_errors;




=head2 get_warnings( )

=over

C<@warnings = get_warnings( );>

C<$warnings = get_warnings( );>

Returns the list of saved warning messages

All warnings logged using C<L<WARN(...)|/WARN(_..._)>> or C<L<WARNING(...)|/WARN(_..._)>> 
are saved to a list.  This function returns either that list (when called in 
list context) or a reference to that list (when called in scalar context).

=back

=cut

sub get_warnings() {
	return (wantarray) ? @warnings : \@warnings;
}

#sub GetWarnings; *GetWarnings = *get_warnings;




=head2 get_errors( )

=over

C<@errors = get_errors( );>

C<$errors = get_errors( );>

Returns the list of error messages

All error messages logged using C<L<ERROR(...)|/ERROR(_..._)>> are saved to a 
list.  This function returns either that list (when called in list context) or 
a reference to that list (when called in scalar context).

=back

=cut

sub get_errors() {
	return (wantarray) ? @errors : \@errors;
}

#sub GetErrors; *GetErrors = *get_errors;




# .-------------.
# |  Verbosity  |
# '-------------'


=head2 set_verbosity( ... )

=over

C<set_verbosity( $level );>

Set the level of logging verbosity

C<$level>

=over

The verbosity level

Only log messages at or below this level will be output.
Higher number result in more console output.

Message levels:

  -999 → None
    -3 → Stack traces (by default)
    -2 → Errors
    -1 → Warnings
     0 → Normal output
    >0 → Verbose output

=back

The default logging verbosity is C<0>.

=back



=head2 get_verbosity( )

=over

C<$level = get_verbosity( );>

Return the current level of logging verbosity

This can be useful to only call C<L<show_warnings()|/show_warnings(_)>> 
and C<L<show_errors()|/show_errors(_)>> at elevated logging levels:

  if ( get_verbosity() > 0 ) {
       show_warnings();
       show_errors();
  }

=back



=head2 be_quiet( )

=over

C<be_quiet( );>

Only output warnings, errors, and (by default) stack traces

Sets verbosity to C<-1>.

=back



=head2 be_silent( )

=over

C<be_silent( );>

Do not output anything.

Sets verbosity to C<-999>.

=back

=cut

sub set_verbosity($;$) {
	if ( $_[0] eq 'Log::Selective' ) {
		$VERBOSE = $_[1];
	} else {
		$VERBOSE = $_[0];
	}
}

sub get_verbosity(;$) {
	return $VERBOSE;
}

# Only output warning and error messages
sub be_quiet() {
	$VERBOSE = -1;
}

# Don't output any log messages
sub be_silent() {
	$VERBOSE = -999;
}

#sub SetVerbosity; *SetVerbosity = *set_verbosity;
#sub BeQuiet;      *BeQuiet      = *be_quiet;
#sub BeSilent;     *BeSilent     = *be_silent;




=head2 extra_logging( ... )

=over

C<extra_logging( $verbosity, $pattern );>

Selectively use a higher logging level

This function sets the logging level to at least C<$verbosity> when the name of 
the current function (or one of its callers) matches the regex C<$pattern>.

Each time C<L<LOG(...)|/LOG(_..._)>> is called a list of callers is contructed and 
concatenated into a string.  Extra logging is then done if that string matches 
the regex C</(?:$pattern)/>.  For example, if C<a()> is called from the top 
level of the script which the calls, in turn, C<b()> and C<Some::Module::c()> 
which in turn calls C<L<Log::Selective::LOG(...)|/LOG(_..._)>> then the string constructed will 
be "C<main::a main::b Some::Module::c>".  The string used at a particular point 
in one's program can be determined using a call to C<L<call_trace()|/call_trace(_)>>.

By default no extra logging is done.

=back

=head2 no_extra_logging( )

=over

C<no_extra_logging( );>

Do not perform extra logging

=back

=cut


sub extra_logging($$) {
	my ($verbosity, $pattern) = ( $_[0] eq 'Log::Selective' )
	                          ? @_[1..2]
	                          : @_[0..1];
	
	$EXTRA_VERBOSITY = $verbosity;
	$EXTRA_PATTERN   = $pattern;
}

sub no_extra_logging() {
	$EXTRA_VERBOSITY = undef;
	$EXTRA_PATTERN   = undef;
}

#sub ExtraLogging;   *ExtraLogging   = *extra_logging;
#sub NoExtraLogging; *NoExtraLogging = *no_extra_logging;




# .---------------------.
# |  Colors and styles  |
# '---------------------'

=head2 set_color_mode( ... )

=over

C<set_color_mode( $mode );>

Choose when colors and styles are used

C<$mode>

=over

B<'auto'> - Automatically decide whether to use colors and styles

If output is going to a terminal then colors and styles are used otherwise they are not

B<'on'> - Always use colors and styles

B<'off'> - Never use colors and styles

=back

By default the color mode is B<'auto'>.

=back

=cut

sub set_color_mode($;$) {
	my $requested = ( $_[0] eq 'Log::Selective' ) ? $_[1] : $_[0];
	$COLOR_MODE = $requested;
}

#sub SetColorMode; *SetColorMode = *set_color_mode;




=head2 set_colors( ... )

=over

C<set_colors( \%colors );>

Specify the colors and styles used at each log level

This function is currently unimplemented.

=back

=cut

sub set_colors($) {
	my ($_colors) = ( $_[0] eq 'Log::Selective' )
	              ? $_[1]
	              : $_[0];
	
	WARN( "SetColors(...) is not implemented." );
}

#sub SetColors; *SetColors = *set_colors;




=head2 append_newlines( ... )

=over

C<append_newlines( );>

C<append_newlines( $switch );>

If C<$switch> is omitted then append newlines to strings passed to logging functions.

If C<$switch> is B<TRUE> then append newlines to strings passed to logging functions.

If C<$switch> is B<FALSE> then do not append newlines to strings passed to logging functions.

By default newlines are appended to strings passed to logging functions.

=back

=head2 no_append_newlines( )

=over

C<no_append_newlines( );>

Do not append newlines to strings passed to logging functions

=back

=cut

sub append_newlines(;$$) {
	my ($requested) = ( scalar @_ )
	                ? ( $_[0] eq 'Log::Selective' )
	                  ? $_[1]
	                  : $_[0]
	                : undef;
	$NEWLINE = ( ( ! defined $requested) || ($requested) ) ? "\n" : '';
}

sub no_append_newlines() {
	$NEWLINE = '';
}

#sub AppendNewlines;   *AppendNewlines   = *append_newlines;
#sub NoAppendNewlines; *NoAppendNewlines = *no_append_newlines;




# .-----------------------.
# |  Output file handles  |
# '-----------------------'


=head2 log_to( ... )

=over

C<log_to( $handle );>

Specify handle to write normal log output to

C<$mode>

=over

Reference to a writable file handle

Defaults to C<\*STDOUT>.

=back

Technically, this option sets the handle used for all messages at levels 0 and above.

=back


=head2 warnings_to( ... )

=over

C<warnings_to( $handle );>

Specify handle to write warnings to

C<$mode>

=over

Reference to a writable file handle

Defaults to C<\*STDERR>.

=back

Technically, this option sets the handle used for all messages at level -1.

=back


=head2 errors_to( ... )

=over

C<errors_to( $handle );>

Specify handle to write errors (and, by default, stack traces) to

C<$mode>

=over

Reference to a writable file handle

Defaults to C<\*STDERR>.

=back

Technically, this option sets the handle used for all messages at levels -2 and below.

=back

=cut

sub log_to ($) {
	if ( $_[0] eq 'Log::Selective' ) {
		$OUTPUT = $_[1];
	} else {
		$OUTPUT = $_[0];
	}
}

sub warnings_to($) {
	if ( $_[0] eq 'Log::Selective' ) {
		$WARNINGS = $_[1];
	} else {
		$WARNINGS = $_[0];
	}
}

sub errors_to($) {
	if ( $_[0] eq 'Log::Selective' ) {
		$ERRORS = $_[1];
	} else {
		$ERRORS = $_[0];
	}
}

#sub LogTo;      *LogTo      = *log_to;
#sub WarningsTo; *WarningsTo = *warnings_to;
#sub ErrorsTo;   *ErrorsTo   = *errors_to;




# .----------------.
# |  Stack traces  |
# '----------------'


=head2 stack_trace( ... )

=over

C<stack_trace( );>

C<stack_trace( $message );>

Writes a stack trace to the console

If a C<$message> is provided then it will be output before the stack trace is 
shown.  If none is provided then "C<Stack trace:\n>" will be output instead.

By default output is done at log level C<-3>; this can be changed using 
C<L<set_stack_trace_level(...)|/set_stack_trace_level(_..._)>>.

=back

=cut

sub stack_trace(;$$) {
	my ($message) = ( scalar @_ )
	              ? ( $_[0] eq 'Log::Selective' )
	                ? $_[1]
	                : $_[0]
	              : undef;
	
	$message = "\nStack trace:" unless ($message);
	
	my $level = (defined $STACKTRACE_LEVEL) ? $STACKTRACE_LEVEL : $LAST_SEEN_LEVEL;
	
	my $newline = ($NEWLINE) ? '' : "\n";
	
	LOG( $level, sprintf("%s%s", $message, $newline ) );
	
	for ( my $l=0; ; $l++ ) {
		my ($package, $filename, $line, $subroutine, $hasargs, $wantarray, $evaltext, $is_require, $hints, $bitmask, $hinthash) = caller($l);
		last unless (defined $package);
		
		LOG( $level, sprintf( "%i: In %s (called from %s:%i)%s", $l, $subroutine, $filename, $line, $newline ) );
	}
	LOG( $level, $newline );
}

#sub StackTrace; *StackTrace = *stack_trace;




=head2 get_stack_trace( )

=over

C<get_stack_trace( );>

Return a stack trace as a list

=back

=cut

sub get_stack_trace(;$) {
	my @stack = ();
	
	for ( my $l=0; ; $l++ ) {
		my ($package, $filename, $line, $subroutine, $hasargs, $wantarray, $evaltext, $is_require, $hints, $bitmask, $hinthash) = caller($l);
		last unless (defined $package);
		
		push @stack, sprintf( "%i: In %s (called from %s:%i)", $l, $subroutine, $filename, $line);
	}
	
	return @stack;
}

#sub GetStackTrace; *GetStackTrace = *get_stack_trace;




=head2 call_trace( )

=over

C<call_trace( );>

Writes an abbreviated stack trace to the console

The string displayed is the same as is used by C<L<LOG(...)|/LOG(_..._)>> 
when determining whether to display extra logging.

When called from the top level of the program the output will be the empty 
string.

By default output is done at log level C<-3>; this can be changed using 
C<L<set_stack_trace_level(...)|/set_stack_trace_level(_..._)>>.

=back

=cut

sub call_trace(;$) {
	my @path = ();
	my $n=1;
	while (1) {
		my (undef, undef, undef, $subroutine, undef, undef, undef, undef, undef, undef, undef) = caller($n);
		last unless (defined $subroutine);
		push @path, $subroutine;
		$n++;
	}
	my $path = join ' ', reverse @path;
	
	my $level = (defined $STACKTRACE_LEVEL) ? $STACKTRACE_LEVEL : $LAST_SEEN_LEVEL;
	LOG( $level, $path );
}

#sub CallTrace; *CallTrace = *call_trace;



=head2 get_call_trace( )

=over

C<get_call_trace( );>

Return an abbreviated call trace as a string

=back

=cut

sub get_call_trace(;$) {
	my @path = ();
	my $n=1;
	while (1) {
		my (undef, undef, undef, $subroutine, undef, undef, undef, undef, undef, undef, undef) = caller($n);
		last unless (defined $subroutine);
		push @path, $subroutine;
		$n++;
	}
	my $path = join ' ', reverse @path;
	
	return $path;
}

#sub GetCallTrace; *GetCallTrace = *get_call_trace;




=head2 set_stack_trace_level( ... )

=over

C<set_stack_trace_level( $level );>

Control how stack traces are displayed

If C<$level> is C<undef> then the level of the last C<L<LOG(...)|/LOG(_..._)>> 
output is used for stack traces.

If C<$level> is defined then the specified level will be used for all stack 
traces.

By default the stack trace level is C<-3>.

=back

=cut

sub set_stack_trace_level($) {
	$STACKTRACE_LEVEL = ( scalar @_ )
	                  ? ( $_[0] eq 'Log::Selective' )
	                    ? $_[1]
	                    : $_[0]
	                  : undef;
}

#sub SetStackTraceLevel; *SetStackTraceLevel = *set_stack_trace_level;




=head2 stack_trace_on_warnings( ... )

=over

C<stack_trace_on_warnings( );>

C<stack_trace_on_warnings( $switch );>

Control whether warnings generate stack traces

If C<$switch> is omitted then show a stack trace after all warnings.

If C<$switch> is B<TRUE> then show a stack trace after all warnings.

If C<$switch> is B<FALSE> then do not show a stack trace after warnings.

By default stack traces are not shown after warnings.

=back

=head2 no_stack_trace_on_warnings( )

=over

C<no_stack_trace_on_warnings( );>

Do not show a stack trace after warnings.

=back

=head2 stack_trace_on_errors( ... )

=over

C<stack_trace_on_errors( );>

C<stack_trace_on_errors( $switch );>

Control whether errors generate stack traces

If C<$switch> is omitted then show a stack trace after all errors.

If C<$switch> is B<TRUE> then show a stack trace after all errors.

If C<$switch> is B<FALSE> then do not show a stack trace after errors.

By default stack traces are not shown after errors.

=back

=head2 no_stack_trace_on_errors( )

=over

C<no_stack_trace_on_errors( );>

Do not show a stack trace after errors

=back

=cut


sub stack_trace_on_warnings(;$$) {
	my ($requested) = ( scalar @_ )
	                ? ( $_[0] eq 'Log::Selective' )
	                  ? $_[1]
	                  : $_[0]
	                : undef;
	$STACKTRACE_ON_WARNINGS = ( defined $requested ) ? $requested : 1;
}

sub no_stack_trace_on_warnings($) {
	$STACKTRACE_ON_WARNINGS = 0;
}


sub stack_trace_on_errors(;$$) {
	my ($requested) = ( scalar @_ )
	                ? ( $_[0] eq 'Log::Selective' )
	                  ? $_[1]
	                  : $_[0]
	                : undef;
	$STACKTRACE_ON_ERRORS = ( defined $requested ) ? $requested : 1;
}

sub no_stack_trace_on_errors($) {
	$STACKTRACE_ON_ERRORS = 0;
}

#sub StackTraceOnWarnings;   *StackTraceOnWarnings   = *stack_trace_on_warnings;
#sub NoStackTraceOnWarnings; *NoStackTraceOnWarnings = *no_stack_trace_on_warnings;
#sub StackTraceOnErrors;     *StackTraceOnErrors     = *stack_trace_on_errors;
#sub NoStackTraceOnErrors;   *NoStackTraceOnErrors   = *no_stack_trace_on_errors;




=head1 BUGS AND DEFICIENCIES

=head3 Known issues

=over

=item * The colors and styles used at the various levels is fixed.

C<set_colors(...)> needs to be written (it is currently a stub) and C<LOG(...)> 
needs to be modified.

=item * Examples need to be written.

=item * Tests need to be written.

=back

=head3 Reporting bugs

Please submit any bugs or feature requests either to C<bug-geo-index at rt.cpan.org>, 
through L<CPAN's web interface|http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Log-Selective>,
or through L<Github|https://github.com/Alex-Kent/Log-Selective/issues>.  In any case I will 
receive notification when you do and you will be automatically notified of progress 
on your submission as it takes place. Any other comments can be sent to C<akh@cpan.org>.


=head1 VERSION HISTORY

B<0.0.1> (2018-04-08) - Initial release


=head1 AUTHOR

Alex Kent Hajnal S<  > C<akh@cpan.org> S<  > L<https://alephnull.net/software>


=head1 COPYRIGHT

Log::Selective

Copyright 2019 Alexander Hajnal, All rights reserved

This module is free software; you can redistribute it and/or modify it under 
the same terms as Perl itself.  See L<perlartistic>.


=cut

1;
