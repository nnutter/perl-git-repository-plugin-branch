package Git::Repository::Remote;

sub new {
    my $class = shift;
    my %args = @_;

    my $self = bless {}, $class;

    # TODO: Should I use Params::Validate?  Mouse?  Upstream author does not
    # like Moose.
    $self->{repository} = delete $args{repository};
    $self->{name} = delete $args{name};

    return $self;
}

sub name { return $_[0]{name} }

sub url {
    my $self = shift;
    my $r = $self->{repository};
    my $key = sprintf('remote.%s.url', $self->name);
    return $r->run('config', $key);
}

sub push {
    my $self = shift;
    my $from = shift;
    my $to = shift;

    my $refspec = ($to ? join(':', $from, $to) : $from);

    my $r = $self->{repository};
    return $r->run('push', $self->name, $refspec);
}

1;
