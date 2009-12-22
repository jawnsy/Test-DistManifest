#!/usr/bin/perl -T

# t/03warn-only.t
#  Ensures the nonfatal mode works properly
#
# $Id$

use strict;
use warnings;

use Test::Builder::Tester tests => 4; # The sum of all subtests
use Test::DistManifest;
use Test::NoWarnings; # 1 test

# Set MANIFEST_WARN_ONLY to true
$ENV{MANIFEST_WARN_ONLY} = 1;

# Run the same tests as 03core.t, but make sure they are all non-fatal now.

# Run the test when MANIFEST is invalid but the MANIFEST.SKIP file is okay
#  1 test
test_out('not ok 1 - Parse MANIFEST or equivalent');
test_out('ok 2 - All files are listed in MANIFEST or skipped');
test_out('ok 3 - All files listed in MANIFEST exist on disk');
test_diag('No such file or directory');
test_fail(+1);
test_out('ok 4 - No files are in both MANIFEST and MANIFEST.SKIP');
manifest_ok('INVALID.FILE', 'MANIFEST.SKIP');
test_test(
  name        => 'Fails when MANIFEST cannot be parsed',
  skip_err    => 1,
);

# Test what happens when MANIFEST contains some extra files
#  1 test
test_out('ok 1 - Parse MANIFEST or equivalent');
test_out('ok 2 - All files are listed in MANIFEST or skipped');
test_out('ok 3 - All files listed in MANIFEST exist on disk');
test_out('ok 4 - No files are in both MANIFEST and MANIFEST.SKIP');
test_fail(+1);
manifest_ok(File::Spec->catfile('t', 'extra'), 'MANIFEST.SKIP');
test_test(
  name      => 'Succeeds even when MANIFEST contains extra files',
  skip_err  => 1,
);

# Test what happens when we have some strange circular logic; that is,
# when MANIFEST and MANIFEST.SKIP point to the same file!
#  1 test
test_out('ok 1 - Parse MANIFEST or equivalent');
test_out('ok 2 - All files are listed in MANIFEST or skipped');
test_out('ok 3 - All files listed in MANIFEST exist on disk');
test_out('not ok 4 - No files are in both MANIFEST and MANIFEST.SKIP');
test_fail(+1);
manifest_ok('MANIFEST', File::Spec->catfile('t', 'circular'));
test_test(
  name        => 'Fails when files are in both MANIFEST and MANIFEST.SKIP',
  skip_err    => 1,
);
