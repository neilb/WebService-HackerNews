package WebService::HackerNews::Item;

use Moo;

has id      => (is => 'ro');
has deleted => (is => 'ro');
has type    => (is => 'ro');
has by      => (is => 'ro');
has time    => (is => 'ro');
has text    => (is => 'ro');
has dead    => (is => 'ro');
has parent  => (is => 'ro');
has kids    => (is => 'ro');
has url     => (is => 'ro');
has score   => (is => 'ro');
has title   => (is => 'ro');
has parts   => (is => 'ro');

1;
