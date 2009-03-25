#!/usr/bin/perl

# Build.PL
#  Script to build and install this distribution
#
# $Id$
#
# All rights to this helper script are hereby disclaimed and its contents
# released into the public domain by the author. Where this is not possible,
# you may use this file under the same terms as Perl itself.

use strict;
use warnings;

use Module::Build;

my $builder = Module::Build->new(
  module_name           => 'Test::DistManifest',
  license               => 'perl',
  dist_author           => 'Jonathan Yu <frequency@cpan.org>',
  dist_version_from     => 'lib/Test/DistManifest.pm',
  dynamic_config        => 0,
  create_readme         => 1,
  recursive_test_files  => 1,
  sign                  => 1,
  create_packlist       => 1,

  # Maintain compatibility with ExtUtils::MakeMaker installations
  create_makefile_pl    => 'traditional',

  requires => {
    'perl'              => 5.006,

    # Pragmatic and special modules
    'Carp'              => 1.04,
    'version'           => 0.76,
    'warnings'          => 0,
    'strict'            => 0,

    # File manipulation modules
    'Cwd'               => 0,
    'File::Spec'        => 0,
    'File::Spec::Unix'  => 0,
    'File::Find'        => 0,

    # The tests are based on Test::More
    'Test::More'        => 0.62,
    'Test::Builder'     => 0.86,

    # Other modules
    'Module::Manifest'  => 0.05,
  },
  build_requires => {
    # User tests for good functionality
    'Test::Builder::Tester'   => 0,
    'Test::NoWarnings'        => 0.084,
  },
  recommends => {
    # Author tests
    'Test::Perl::Critic'        => 1.01,
    'Perl::Critic'              => 1.096,
    'Test::YAML::Meta'          => 0.11,
    'Test::Kwalitee'            => 1.01,
    'Test::Signature'           => 1.10,
    'Test::Pod'                 => 1.14,
    'Test::Pod::Coverage'       => 1.04,
    'Test::Portability::Files'  => 0.05,
    'Test::MinimumVersion'      => 0.008,
  },
  conflicts => {
  },

  add_to_cleanup => [ 'Test-DistManifest-*' ],
  script_files => [],

  meta_merge => {
    resources => {
      # Custom resources (must begin with an uppercase letter)
      Ratings      => 'http://cpanratings.perl.org/d/Test-DistManifest',

      # Official keys (homepage, license, bugtracker)
      repository   => 'http://svn.ali.as/cpan/trunk/Test-DistManifest',
      bugtracker   => 'http://rt.cpan.org/NoAuth/Bugs.html?Dist=Test-DistManifest',
      license      => 'http://dev.perl.org/licenses/',
    },
  },
);

$builder->create_build_script();
