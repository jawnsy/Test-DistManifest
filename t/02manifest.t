#!/usr/bin/perl

# Ensures MANIFEST file is up-to-date

use strict;
use warnings;

use Test::DistManifest;
use Config;

# ensure the #!include in MANIFEST.SKIP is expanded - works around RT#85685
system($Config{make}, 'manifest') && die "$Config{make} manifest failed";

manifest_ok();
