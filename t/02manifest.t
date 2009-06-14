#!/usr/bin/perl -T

# t/02manifest.t
#  Ensures MANIFEST file is up-to-date
#
# By Jonathan Yu <frequency@cpan.org>, 2008-2009. All rights reversed.
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
