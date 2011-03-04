#!/usr/bin/env perl
use strict;
use warnings;
use 5.010;
use Cwd;
use Test::More tests => 18;
use Test::Cmd;

my $test;

sub check_key {
	my ($filetype, $key, $value) = @_;
	my @lines;
	$test->read(\@lines, "comirror.${filetype}");

	if(grep { $_ eq "$key\t$value\n" } @lines) {
		pass("${filetype}: ${key} = ${value}");
	}
	else {
		fail("${filetype}: ${key} = ${value}");
	}
}

for my $test_type (qw/loop unicroak/) {

	$test = Test::Cmd->new( prog => 'bin/comirror-setup', workdir => q{} );
	my $cwd  = $test->workdir();

	my $next_base = 'file://' . getcwd() . "/t/next-${test_type}";
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
		args => '--batch ' . join(q{ }, @links[0, 1, 3]),
	);

	ok($exit == 0, 'Correct usage: return zero');

	isnt($test->stdout, q{}, 'Correct usage: Something to stdout');
	is  ($test->stderr, q{}, 'Correct usage: Nothing to stderr');

	check_key('state', 'uri', $links[0]);

	check_key('conf', 'image_re', "${next_base}/.+");

}
