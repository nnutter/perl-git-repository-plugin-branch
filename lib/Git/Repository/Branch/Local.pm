use strict;
use warnings;

package Git::Repository::Branch::Local;
use base 'Git::Repository::Branch::Base';

use Git::Repository::Branch::Local;
use Git::Repository::Branch::Remote;

sub upstream {
    my $self = shift;

    my $r = $self->{repository};
    my $full_name = $r->run('rev-parse', '--symbolic-full-name', '@{u}');

    if (Git::Repository::ref_is_local_branch($full_name)) {
        return Git::Repository::Branch::Local->new(
            repository => $r,
            full_name => $full_name,
        );
    } elsif (Git::Repository::ref_is_remote_branch($full_name)) {
        return Git::Repository::Branch::Remote->new(
            repository => $r,
            full_name => $full_name,
        );
    } else {
        return;
    }
}

1;
