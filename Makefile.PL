use strict;
use warnings;
use ExtUtils::MakeMaker;

my %config = (
    NAME                => 'Log::Selective',
    AUTHOR              => q{Alex Kent Hajnal <akh@cpan.org>},
    VERSION_FROM        => 'lib/Log/Selective.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Log-Selective-*' },
);

WriteMakefile( %config );

# Remove the Makefile dependency. Causes problems on a few systems.
sub MY::makefile { '' }
