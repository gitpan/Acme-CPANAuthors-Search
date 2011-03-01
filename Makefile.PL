use strict;use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'Acme::CPANAuthors::Search',
    AUTHOR        => q{Mohammad S Anwar <mohammad.anwar@yahoo.com>},
    VERSION_FROM  => 'lib/Acme/CPANAuthors/Search.pm',
    ABSTRACT_FROM => 'lib/Acme/CPANAuthors/Search.pm',
    dist          => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean         => { FILES => 'Acme-CPANAuthors-Search-*' },
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PREREQ_PM     => {
        'Test::More'        => 0,
        'HTTP::Request'     => '1.40',
        'LWP::UserAgent'    => '2.33',
        'HTML::Entities'    => '1.35',
    },
);