use strict;
use warnings;

package Git::Repository::Branch::Base;

use Carp qw(croak);

sub new {
    my $class = shift;
    my %args = @_;

    if ($class eq __PACKAGE__) {
        croak __PACKAGE__ . ' is abstract';
    }

    my $self = bless {}, $class;

    # TODO: Should I use Params::Validate?  Mouse?  Upstream author does not
    # like Moose.
    $self->{repository} = delete $args{repository};
    $self->{full_name} = delete $args{full_name};

    return $self;
}

sub full_name { return $_[0]{full_name} }

sub name {
    my $self = shift;
    my $r = $self->{repository};
    return $r->run('rev-parse', '--abbrev-ref', $self->full_name);
}

1;
