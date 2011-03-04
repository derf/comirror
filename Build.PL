#!/usr/bin/env perl

use strict;
use warnings;
use Module::Build;

my $build = Module::Build->new(
	build_requires => {
		'Test::Cmd' => 0,
		'Test::Compile' => 0,
		'Test::More' => 0,
		'Test::Pod' => 0,
	},
	dist_name => 'comirror',
	dist_version_from => 'bin/comirror',
	license => 'unrestricted',
	requires => {
		'perl' => '5.10.0',
		'WWW::Mechanize' => 0,
	},
);
$build->create_build_script();
