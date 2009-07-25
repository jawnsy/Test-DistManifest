#!/usr/bin/perl -T

# t/01critic.t
#  Test the distribution using Perl::Critic for guidelines
#
# $Id$

use strict;
use warnings;

use Test::More;
use File::Spec;

unless ($ENV{RELEASE_TESTING}) {
  plan skip_all => 'Author tests not required for installation';
}

my %MODULES = (
  'Test::Perl::Critic'  => 1.01,
  'Perl::Critic'        => 1.098,
);

while (my ($module, $version) = each %MODULES) {
  eval "use $module $version";
  if ($@) {
    die 'Could not load release-testing module ' . $module;
  }
}

my $rcfile = File::Spec->catfile('t', '01critic.rc');
Test::Perl::Critic->import(-profile => $rcfile);

all_critic_ok();
