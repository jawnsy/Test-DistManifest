#!/usr/bin/perl

# Ensures MANIFEST file is up-to-date

use strict;
use warnings;

use Test::DistManifest;

# since we have no MANIFEST.SKIP in the repo, a default one is used.
manifest_ok();
