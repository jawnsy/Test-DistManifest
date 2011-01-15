#!/usr/bin/perl -T

# Test loading of a default MANIFEST.SKIP

use strict;
use warnings;

use Test::DistManifest;
use Test::More; # for plan
use File::Spec;
require Test::Builder::Tester;
require Test::NoWarnings;

unless ($ENV{RELEASE_TESTING}) {
  plan skip_all => 'Author tests not required for installation';
}

Test::Builder::Tester->import( tests => 2 );
Test::NoWarnings->import(); # 1 test

# If MANIFEST_WARN_ONLY is set, unset it
if (exists($ENV{MANIFEST_WARN_ONLY})) {
  delete($ENV{MANIFEST_WARN_ONLY});
}

# Test default MANIFEST.SKIP when none is present
#  1 test
test_out('ok 1 - Parse MANIFEST or equivalent');
test_diag('Unable to parse MANIFEST.SKIP file:');
test_diag('No such file or directory');
test_diag('Using default skip data from ExtUtils::Manifest 1.58');
test_out('ok 2 - All files are listed in MANIFEST or skipped');
test_out('ok 3 - All files listed in MANIFEST exist on disk');
test_out('ok 4 - No files are in both MANIFEST and MANIFEST.SKIP');
manifest_ok('MANIFEST', 'INVALID.FILE');
test_test(
  name      => 'Uses default MANIFEST.SKIP on failure to parse',
  skip_err  => 1,
);
