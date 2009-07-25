#!/usr/bin/perl -T

# t/02manifest.t
#  Ensures MANIFEST file is up-to-date
#
# $Id$

use strict;
use warnings;

use Test::DistManifest;

manifest_ok();
