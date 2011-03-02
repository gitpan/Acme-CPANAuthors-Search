package Acme::CPANAuthors::Search;

use strict; use warnings;

=head1 NAME

Acme::CPANAuthors::Search - A very simple module for searching CPAN module authors.

=head1 VERSION

Version 0.03

=cut

our $VERSION = '0.03';
our $DEBUG   = 0;

use Carp;
use Data::Dumper;
use HTTP::Request;
use LWP::UserAgent;
use HTML::Entities qw/decode_entities/;

=head1 SYNOPSIS

    use Acme::CPANAuthors::Search;
    my $search = Acme::CPANAuthors::Search->new();
    
    my $name   = $search->by_id('MANWAR');
    # $name should have 'Mohammad S Anwar'
    
    my $list   = $search->where_name_contains('MAN');
    # $list should have
    # {
    #    'umvue'  => 'Yee Man Chan',
    #    'lwall'  => 'Larry Wall. Author of Perl. Busy man.',
    #    'kinman' => 'Kin man, Cheung'
    # }

=cut

sub new
{
    my $class = shift;
    my $self  = { _browser => LWP::UserAgent->new() };
    
    bless $self, $class;
    return $self;
}

=head1 METHODS

=head2 by_id

This method accepts CPAN ID exactly as provided by CPAN. It does realtime search on CPAN site and fetch
the author name for the given CPAN ID. However it would return nothing if it can't access the CPAN site
or unable to get any response for the given CPAN ID.

=cut

sub by_id
{
    my $self     = shift;
    my $id       = shift;
    
    my $browser  = $self->{_browser};
    my $request  = HTTP::Request->new(POST=>qq[http://search.cpan.org/search?query=$id&mode=author]);
    my $response = $browser->request($request);
    print {*STDOUT} "Search By Id [$id] Status: " . $response->status_line . "\n" if $DEBUG;
    return unless $response->is_success;
    
    my $contents = $response->content;
    my @contents = split(/\n/,$contents);
    foreach (@contents)
    {
        chomp;
        s/^\s+//g;
        s/\s+$//g;
        if (/\<p\>\<h2 class\=sr\>\<a href\=\"\/\~(.*)\/\"\><b>(.*)<\/b\>/)
        {
            return decode_entities($2)
                if (uc($id) eq uc($1));
        }
    }
    return;
}

=head2 where_id_starts_with

This method accepts an alphabet (A-Z) and get the list of authors that start with the given
alphabet from CPAN site realtime.

=cut

sub where_id_starts_with
{
    my $self     = shift;
    my $letter   = shift;
    
    my $browser  = $self->{_browser};
    my $request  = HTTP::Request->new(POST=>qq[http://search.cpan.org/author/?$letter]);
    my $response = $browser->request($request);
    print {*STDOUT} "Search Id Starts With [$letter] Status: " . $response->status_line . "\n" if $DEBUG;
    return unless $response->is_success;
    
    my $contents = $response->content;
    my @contents = split(/\n/,$contents);
    
    my @authors;
    foreach (@contents)
    {
        chomp;
        s/^\s+//g;
        s/\s+$//g;
        if (/<a href\=\"\/\~(.*)\/\"/)
        {
            push @authors, $1;
        }
    }
    return @authors;
}

=head2 where_name_contains

This method accepts a search string and look for the string in the author's name of all the CPAN modules
realtime and returns the a reference to a hash containing id, name pair containing the search string.

=cut

sub where_name_contains
{
    my $self     = shift;
    my $query    = shift;
    
    my $browser  = $self->{_browser};
    my $request  = HTTP::Request->new(POST=>qq[http://search.cpan.org/search?query=$query&mode=author]);
    my $response = $browser->request($request);
    print {*STDOUT} "Search By Name Contains [$query] Status: " . $response->status_line . "\n" if $DEBUG;
    return unless $response->is_success;
    
    my $contents = $response->content;
    my @contents = split(/\n/,$contents);
    
    my $authors;
    foreach (@contents)
    {
        chomp;
        s/^\s+//g;
        s/\s+$//g;
        if (/\<p\>\<h2 class\=sr\>\<a href\=\"\/\~(.*)\/\"\><b>(.*)<\/b\>/)
        {
            $authors->{$1} = decode_entities($2);
        }
    }
    return $authors;
}

=head1 AUTHOR

Mohammad S Anwar, C<< <mohammad.anwar at yahoo.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-acme-cpanauthors-search at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Acme-CPANAuthors-Search>.  
I will be notified, and then you'll automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Acme::CPANAuthors::Search

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Acme-CPANAuthors-Search>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Acme-CPANAuthors-Search>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Acme-CPANAuthors-Search>

=item * Search CPAN

L<http://search.cpan.org/dist/Acme-CPANAuthors-Search/>

=back

=head1 LICENSE AND COPYRIGHT

Copyright 2011 Mohammad S Anwar.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=head1 DISCLAIMER

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

=cut

1; # End of Acme::CPANAuthors::Search