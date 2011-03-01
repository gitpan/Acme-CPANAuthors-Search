#!perl

use Test::More tests => 1;

use Acme::CPANAuthors::Search;

my $search = Acme::CPANAuthors::Search->new();
my $name   = $search->by_id('MANWAR');
is($name, 'Mohammad S Anwar');