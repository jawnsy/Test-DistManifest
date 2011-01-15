#!/usr/bin/perl -T

# Ensures MANIFEST file is up-to-date

use strict;
use warnings;

use Test::DistManifest;

manifest_ok();
