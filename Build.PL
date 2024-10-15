use strict;
use warnings;
use utf8;

use Module::Build;

my @libpaths = qw(libsystemd-journal libsystemd); # recently system is libsystemd but some platform has both paths.
my $libpath  = '';

for my $path ( @libpaths ) {
	next unless `pkg-config --exists $path && echo 1`;
	$libpath = $path;
}

my $libsystemd_journal_CFLAGS = `pkg-config --cflags $libpath`
	or warn 'Could not determine systemd-journal compiler flags';
my $libsystemd_journal_LDFLAGS = `pkg-config --libs $libpath`
	or warn 'Could not determine systemd-journal compiler flags';

my $build = Module::Build->new(
	module_name		=> 'Log::Journald',
	license			=> 'perl',
	dist_author		=> 'Andre Klärner <kandre@ak-online.be>',
	create_readme		=> 1,
	create_makefile_pl	=> 'small',
	meta_merge		=> {
		resources	=> {
			bugtracker	=> 'https://github.com/klaernie/perl-Log-Journald/issues',
			repository	=> {
				web => 'https://github.com/klaernie/perl-Log-Journald',
				url => 'https://github.com/klaernie/perl-Log-Journald.git',
				type => 'git',
			},
		}
	},
	extra_compiler_flags	=> $libsystemd_journal_CFLAGS,
	extra_linker_flags	=> $libsystemd_journal_LDFLAGS,
	configure_requires		=> {
		'Module::Build'		=> 0,
	},
	build_requires		=> {
		'ExtUtils::CBuilder'	=> 0,
	}
);

$build->create_build_script;
