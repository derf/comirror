#!/usr/bin/env perl
use strict;
use warnings;
use 5.010;
use Cwd;
use Test::More tests => 9;
use Test::Cmd;

my $test = Test::Cmd->new( prog => 'bin/comirror-setup', workdir => q{} );
my $cwd  = $test->workdir();

my $next_base = 'file://' . getcwd() . '/test/next-loop';
my ($str, $exit);
my @links;

ok($test, 'Create Test::Cmd object');

$exit = $test->run(
	chdir => $cwd
);

ok($exit != 0, 'Not enough arguments: non-zero return');

is  ($test->stdout, q{}, 'Not enough arguments: Nothing to stdout');
isnt($test->stderr, q{}, 'Not enough arguments: Something to stderr');

for my $i (1 .. 5) {
	push(@links, "${next_base}/${i}.xhtml");
}

$exit = $test->run(
	chdir => $cwd,
	args => join(q{ }, @links[0, 1, 3]),
);

ok($exit == 0, 'Correct usage: return zero');

isnt($test->stdout, q{}, 'Correct usage: Something to stdout');
is  ($test->stderr, q{}, 'Correct usage: Nothing to stderr');

$test->read(\$str, 'last_uri');
is($str, "$links[0]\n", 'Correct last_uri');

$test->read(\$str, 'image_re');
is($str, "${next_base}/.+\n", 'Correct image_re');
