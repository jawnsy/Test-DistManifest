#!/usr/bin/perl

# Build.PL
#  Script to build and install this distribution
#
# $Id$

use strict;
use warnings;

use Module::Build;

my $builder = Module::Build->new(
  module_name           => 'Test::DistManifest',
  license               => 'perl',
  dist_author           => 'Jonathan Yu <frequency@cpan.org>',
  dist_version_from     => 'lib/Test/DistManifest.pm',
  dynamic_config        => 0,
  create_readme         => 0,
  recursive_test_files  => 1,
  sign                  => 1,
  create_packlist       => 1,

  # Maintain compatibility with ExtUtils::MakeMaker installations
  create_makefile_pl    => 'passthrough',

  requires => {
    'perl'              => 5.006,

    # The tests are based on Test::More
    'Test::More'        => 0.62,
    'Test::Builder'     => 0.72,

    # Other modules
    'Module::Manifest'  => 0.07,
  },
  build_requires => {
    # User tests for good functionality
    'Test::Builder::Tester'   => 0,
    'Test::NoWarnings'        => 0.084,
  },
  recommends => {
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
