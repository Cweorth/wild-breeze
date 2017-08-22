package WBM::Driver;

use v5.26;
use utf8;
use strict;
use warnings;

use feature     qw(signatures);
no  warnings    qw(experimental::signatures);

use Data::Dumper;

sub new($class, %args) {
    my $self = bless {}, $class;
    ($self->{log}) = delete $args{-log};
    return $self;
}

sub log($self) { $self->{log}; }

sub refresh_on_event($) { 0; }
sub invoke($self) {
    $self->log->fatal("invoke called on WBM::Driver, perhaps forgotten override?");
}

sub on_left_click($) {}
sub on_middle_click($) {}
sub on_right_click($) {}
sub on_wheel_up($) {}
sub on_wheel_down($) {}
sub on_back($) {}
sub on_next($) {}
sub on_event($) {}

# vim: syntax=perl5-24

1;