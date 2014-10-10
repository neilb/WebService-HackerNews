package WebService::HackerNews;

use 5.006;
use Moo;
use HTTP::Tiny;
use JSON qw(decode_json);

use WebService::HackerNews::Item;
use WebService::HackerNews::User;

has ua => (
    is => 'ro',
    default => sub {
        require HTTP::Tiny;
        HTTP::Tiny->new;
    },
);

has base_url => (
    is      => 'ro',
    default => sub { 'https://hacker-news.firebaseio.com/v0' },
);

my $get = sub
{
    my ($self, $relpath) = @_;
    my $url      = $self->base_url.'/'.$relpath;
    my $response = $self->ua->get($url);

    # This is a hack. Can I use JSON->allow_nonref to handle
    # the fact that maxitem returns an int rather than [ int ]?
    return $response->{content} =~ m!^\s*[{[]!
           ? decode_json($response->{content})
           : $response->{content}
           ;
};

sub top_story_ids
{
    my $self   = shift;
    my $result = $self->$get('topstories.json');

    return @$result;
}

sub item
{
    my $self   = shift;
    my $id     = shift;
    my $result = $self->$get("item/$id.json");

    return WebService::HackerNews::Item->new($result);
}

sub user
{
    my $self   = shift;
    my $id     = shift;
    my $result = $self->$get("user/$id.json");

    return WebService::HackerNews::User->new($result);
}

sub max_item_id
{
    my $self   = shift;
    my $result = $self->$get('maxitem.json');

    return $result;
}

1;

=head1 NAME

WebService::HackerNews - interface to the official HackerNews API

=head1 SYNOPSIS

 use WebService::HackerNews;
 my $hn     = WebService::HackerNews->new;
 my @top100 = $hn->top_story_ids;
 my $item   = $hn->item( $top100[0] );
 my $user   = $hn->user($item->by);

 printf qq{"%s" by %s (karma: %d)\n},
        $item->title, $item->by, $user->karma;

=head1 DESCRIPTION

This module provides an interface to the official
L<Hacker News API|https://github.com/HackerNews/API>.
This is very much a lash-up at the moment, and liable to change.
Feel free to hack on it and send me pull requests.

=head1 METHODS

Most of the methods in the official doc are implemented.

=head2 top_story_ids

Returns a list of ids for the current top 100 stories.

 my @ids = $hn->top_story_ids;

You can then call C<item()> to get the details for specific items.

=head2 item($ID)

Takes an item id and returns an instance of L<WebService::HackerNews::Item>,
which has attributes named exactly the same as the properties listed in
the official doc.

 $item = $hn->item($id);
 printf "item %d has type %s\n", $item->id, $item->type;

=head2 user($ID)

Takes a user id and returns an instance of L<WebService::HackerNews::User>,
which has attributes named exactly the same as the
L<user properties|https://github.com/HackerNews/API#users>
listed in the official doc.

 $user = $hn->user($username);
 printf "user %s has %d karma\n", $user->id, $user->karma;

=head2 max_item_id

Returns the max item id.

=head1 SEE ALSO

L<Blog post about the API|http://blog.ycombinator.com/hacker-news-api>.

L<API Documentation|https://github.com/HackerNews/API>.

=head1 REPOSITORY

L<https://github.com/neilbowers/WebService-HackerNews>

=head1 AUTHOR

Neil Bowers E<lt>neilb@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Neil Bowers <neilb@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
