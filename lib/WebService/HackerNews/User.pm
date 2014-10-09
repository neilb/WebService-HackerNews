package WebService::HackerNews::User;

use Moo;

has id        => (is => 'ro');
has delay     => (is => 'ro');
has created   => (is => 'ro');
has karma     => (is => 'ro');
has about     => (is => 'ro');
has submitted => (is => 'ro');

1;
