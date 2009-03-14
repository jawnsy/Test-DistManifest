#!/usr/bin/perl -T

# t/01pod-coverage.t
#  Ensures all subroutines are documented with POD
#
# $Id$
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

eval 'use Test::Pod::Coverage 1.04';
if ($@) {
  plan skip_all => 'Test::Pod::Coverage required to test POD Coverage';
}

all_pod_coverage_ok();
