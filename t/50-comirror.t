#!/usr/bin/env perl
use strict;
use warnings;
use 5.010;
use Cwd;
use Test::More tests => 26;
use Test::Cmd;

sub check_key {
	my ($test, $filetype, $key, $value) = @_;
	my @lines;
	$test->read(\@lines, "comirror.${filetype}");

	if(grep { $_ eq "$key\t$value\n" } @lines) {
		pass("${filetype}: ${key} = ${value}");
	}
	else {
		fail("${filetype}: ${key} = ${value}");
	}
}

for my $next_type (qw/ loop none /) {

	my $test = Test::Cmd->new( prog => 'bin/comirror', workdir => q{} );
	my $cwd  = $test->workdir();

	my $next_base = 'file://' . getcwd() . "/t/next-${next_type}";
	my ($str, $exit);

	ok($test, "Create Test::Cmd object ($next_type)");

	$test->write('comirror.conf', "image_re\t${next_base}/.+\n");

	$exit = $test->run(
		chdir => $cwd,
		args => "${next_base}/1.xhtml",
	);

	ok($exit == 0, 'First run: return 0');

	isnt($test->stdout, q{}, 'First run: Non-empty stdout');
	is  ($test->stderr, q{}, 'First run: Empty stderr');

	check_key($test, 'state', 'uri', "${next_base}/4.xhtml");

	for my $i (1 .. 5) {
		ok(-e "$cwd/$i.jpg",
			"$i.jpg was downloaded successfully ($next_type)");
	}

	$exit = $test->run(
		chdir => $cwd,
	);

	ok(($exit >> 8) == 1, 'Second run: return 1 (no new images loaded)');

	isnt($test->stdout, q{}, 'Second run: Non-empty stdout');
	is  ($test->stderr, q{}, 'Second run: Empty stderr');
}
