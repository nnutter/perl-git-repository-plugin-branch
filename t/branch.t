use strict;
use warnings;

use Test::More;
use Test::Git qw(has_git test_repository);

use Git::Repository qw(Branch);

has_git();

plan tests => 3;

my $remote_repo = test_repository(init => ['--bare']);

my $repo = test_repository();
$repo->run('commit', '--allow-empty', '-m', 'first');
$repo->run('commit', '--allow-empty', '-m', 'second');
$repo->run('remote', 'add', 'origin', $remote_repo->git_dir);
$repo->run('push', '-u', 'origin', 'master', { quiet => 1 });

my $branch = $repo->branch();
subtest 'branch' => sub {
    plan tests => 3;
    ok($branch->isa('Git::Repository::Branch::Base'), 'got branch object');
    attr_is($branch, 'full_name', 'refs/heads/master');
    attr_is($branch, 'name', 'master');
};

my $upstream = $branch->upstream;
subtest 'upstream' => sub {
    plan tests => 4;
    ok($upstream->isa('Git::Repository::Branch::Base'), 'got upstream object');
    attr_is($upstream, 'full_name', 'refs/remotes/origin/master');
    attr_is($upstream, 'name', 'origin/master');
    attr_is($upstream, 'remote_branch_name', 'master');
};

my $remote = $upstream->remote;
subtest 'remote' => sub {
    plan tests => 3;
    ok($remote->isa('Git::Repository::Remote'), 'got remote object');
    attr_is($remote, 'name', 'origin');
    attr_is($remote, 'url', $remote_repo->git_dir);
};

sub attr_is {
    my ($object, $attr, $expected) = @_;
    is($object->$attr, $expected, qq($attr = $expected));
}
