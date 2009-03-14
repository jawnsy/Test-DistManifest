#!/usr/bin/perl

# t/01kwalitee.t
#  Uses the CPANTS Kwalitee metrics to test the distribution
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

eval {
  require Test::Kwalitee;
};
if ($@) {
  plan skip_all => 'Test::Kwalitee required to test distribution Kwalitee';
}

Test::Kwalitee->import();
