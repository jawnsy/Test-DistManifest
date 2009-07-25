#!/usr/bin/perl -T

# t/01compile.t
#  Check that the module can be compiled and loaded properly.
#
# $Id$

use strict;
use warnings;

use Test::More tests => 2;
use Test::NoWarnings; # 1 test

# Check that we can load the module
BEGIN {
  use_ok('Test::DistManifest'); # 1 test
}
