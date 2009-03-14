#!/usr/bin/perl -T

# t/01pod.t
#  Checks that POD commands are correct
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

eval 'use Test::Pod 1.14';
if ($@) {
  plan skip_all => 'Test::Pod 1.14 required to test POD';
}

all_pod_files_ok();
