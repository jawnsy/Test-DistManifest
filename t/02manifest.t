#!/usr/bin/perl -T

# t/02manifest.t
#  Ensures MANIFEST file is up-to-date
#
# $Id$
#
# This test script is hereby released into the public domain.

use strict;
use warnings;

use Test::DistManifest;

manifest_ok();
