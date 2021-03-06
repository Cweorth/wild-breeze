package Leaf::Backlight;

use utf8;
use strict;
use warnings;

use parent      "Stalk::Driver";
use feature     qw(signatures);
no  warnings    qw(experimental::signatures);

use Breeze::Grad;
use File::Slurp;

sub new($class, %args) {
    my $self = $class->SUPER::new(%args);

    $self->log->fatal("missing 'video' parameter in constructor")
        unless defined $args{video};

    $self->{video} = $args{video};
    return $self;
}

sub invoke($self) {
    my $path = "/sys/class/backlight/$self->{video}";
    my $max = read_file("$path/max_brightness");
    my $cur = read_file("$path/brightness");

    chomp($max, $cur);

    my $p = int ((100 * $cur) / $max);

    my $ret = {
        icon      => "",
        text      => sprintf("%3d%%", $p),
        color     => [
            $p,
            '%{backlight.@grad,gray white}'
        ],
    };

    if (($self->{last} // $p) != $p) {
        $ret->{invert} = 1;
    }

    $self->{last} = $p;
    return $ret;
}

sub on_wheel_up($) {
    system(qw(xbacklight -inc 5% -time 50 -steps 5));
    return { reset_all => 1, invert => 1 };
}

sub on_wheel_down($) {
    system(qw(xbacklight -dec 5% -time 50 -steps 5));
    return { reset_all => 1, invert => 1 };
}

sub on_middle_click($) {
    if ($_[0]->{last} < 10) {
        system(qw(xbacklight -set 40% -time 400 -steps 30));
    } else {
        system(qw(xbacklight -set  0% -time 400 -steps 30));
    }

    return { reset_all => 1, blink => 4 };
}

1;
