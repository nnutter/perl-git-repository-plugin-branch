use warnings;
use strict;

package Git::Repository::Plugin::Branch;
use base 'Git::Repository::Plugin';
sub _keywords { qw(branch branches remotes ref_is_local_branch ref_is_remote_branch) };

use Git::Repository::Branch::Local;
use Git::Repository::Remote;

sub ref_is_local_branch {
    my $full_name = shift;
    return ($full_name && index($full_name, 'refs/heads/') == 0);
}

sub ref_is_remote_branch {
    my $full_name = shift;
    return ($full_name && index($full_name, 'refs/remotes/') == 0);
}

sub branch {
    my $self = shift;

    my $full_name = $self->run('rev-parse', '--symbolic-full-name', 'HEAD');
    if (ref_is_local_branch($full_name)) {
        return Git::Repository::Branch::Local->new(
            repository => $self,
            full_name => $full_name,
        );
    } else {
        return;
    }
}

sub remotes {
    my $self = shift;

    my @names = $self->run('remote');
    return map { Git::Repository::Remote->new(
        repository => $self,
        name => $_,
    ) } @names;
}

1;
