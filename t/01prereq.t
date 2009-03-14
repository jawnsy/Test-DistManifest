#!/usr/bin/perl

# t/01prereq.t
#  Checks that Build.PL prerequisites are correct
#
# $Id: 01pod.t 4994 2009-01-19 21:05:22Z FREQUENCY@cpan.org $
#
# All rights to this test script are hereby disclaimed and its contents
# released into the public domain by the author. Where this is not possible,
# you may use this file under the same terms as Perl itself.

use strict;
use warnings;

use Test::More;

unless ($ENV{TEST_AUTHOR}) {
  plan skip_all => 'Set TEST_AUTHOR to enable module author tests';
}

eval {
  require Test::Prereq::Build;
};
if ($@) {
  plan(skip_all => 'Test::Prereq::Build required to test prerequsites');
}

plan tests => 1;

Test::Prereq::Build->import();

prereq_ok();
