#!perl

use Test::More;
use Acme::CPANAuthors::Search;

my ($search, $name);
$search = Acme::CPANAuthors::Search->new();
eval { $name   = $search->by_id('MANWAR'); };
plan skip_all => "It appears you don't have internet access."
    if ($@ =~ /ERROR\: Couldn\'t connect to search\.cpan\.org/);
is($name, 'Mohammad S Anwar');

done_testing();