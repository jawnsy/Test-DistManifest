#!/usr/bin/perl -T

# t/01critic.t
#  Test the distribution using Perl::Critic for guidelines
#
# $Id$

use strict;
use warnings;

use Test::More;
use File::Spec;

unless ($ENV{AUTOMATED_TESTING} or $ENV{RELEASE_TESTING}) {
  plan skip_all => 'Author tests not required for installation';
}

my %MODULES = (
  'Test::Perl::Critic'  => 1.01,
  'Perl::Critic'        => 1.098,
);

while (my ($module, $version) = each %MODULES) {
  eval "use $module $version";
  next unless $@;

  if ($ENV{RELEASE_TESTING}) {
    die 'Could not load release-testing module ' . $module;
  }
  else {
    plan skip_all => $module . ' not available for testing';
  }
}

my $rcfile = File::Spec->catfile('t', '01critic.rc');
Test::Perl::Critic->import(-profile => $rcfile);

all_critic_ok();
