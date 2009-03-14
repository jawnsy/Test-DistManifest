#!/usr/bin/perl -T

# examples/checkmanifest.t
#  Ensures MANIFEST file is up-to-date
#
# $Id$
#
# All rights to this test script are hereby disclaimed and its contents
# released into the public domain by the author. Where this is not possible,
# you may use this file under the same terms as Perl itself.

use strict;
use warnings;

use Test::DistManifest;

manifest_ok();
