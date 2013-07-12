use strict;
use warnings;

package Git::Repository::Branch::Remote;
use base 'Git::Repository::Branch::Base';

sub remote_branch_name {
    my $self = shift;
    my $remote_name = $self->remote->name;
    return ($self->full_name =~ /refs\/remotes\/$remote_name\/(.*)/)[0];
}

sub remote {
    my $self = shift;

    my $r = $self->{repository};

    my @matching_remotes;
    my @parts = split('/', $self->full_name);
    for (my $i = 2; $i < $#parts; $i++) {
        my $remote = join('/', @parts[2..$i]);
        push @matching_remotes, grep { $_->name =~ /^$remote$/ } $r->remotes;
    }

    if (@matching_remotes == 0) {
        die sprintf('failed to determine remote: %s', $self->full_name);
    } elsif (@matching_remotes > 1) {
        die sprintf('ambiguous remote: %s', join(', ', @matching_remotes));
    }

    return $matching_remotes[0];
}

1;
