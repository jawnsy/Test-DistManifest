#!/usr/bin/perl -T

# t/03warn-only.t
#  Ensures the nonfatal mode works properly
#
# $Id$
#
# All rights to this test script are hereby disclaimed and its contents
# released into the public domain by the author. Where this is not possible,
# you may use this file under the same terms as Perl itself.

use strict;
use warnings;

use Test::Builder::Tester tests => 5; # The sum of all subtests
use Test::DistManifest;
use Test::NoWarnings; # 1 test

# Set MANIFEST_WARN_ONLY to true
$ENV{MANIFEST_WARN_ONLY} = 1;

# Run the same tests as 03core.t, but make sure they are all non-fatal now.

# Run the test when MANIFEST is invalid but the MANIFEST.SKIP file is okay
#  1 test
test_out('ok 1 - Parse MANIFEST or equivalent');
test_out('ok 2 - Parse MANIFEST.SKIP or equivalent');
test_out('ok 3 - All files are listed in MANIFEST or skipped');
test_out('ok 4 - All files listed in MANIFEST exist on disk');
test_diag('No such file or directory');
test_fail(+1);
test_out('ok 5 - No files are in both MANIFEST and MANIFEST.SKIP');
manifest_ok('INVALID.FILE', 'MANIFEST.SKIP');
test_test(
  name        => 'Succeeds even MANIFEST cannot be parsed',
  skip_err    => 1,
);

# Run the test when MANIFEST is valid but the MANIFEST.SKIP file is missing
#  1 test
test_out('ok 1 - Parse MANIFEST or equivalent');
test_out('ok 2 - Parse MANIFEST.SKIP or equivalent');
test_out('ok 3 - All files are listed in MANIFEST or skipped');
test_out('ok 4 - All files listed in MANIFEST exist on disk');
test_diag('No such file or directory');
test_out('ok 5 - No files are in both MANIFEST and MANIFEST.SKIP');
test_fail(+1);
manifest_ok('MANIFEST', 'INVALID.FILE');
test_test(
  name        => 'Succeeds even when MANIFEST.SKIP cannot be parsed',
  skip_err    => 1,
);

# Test what happens when MANIFEST contains some extra files
#  1 test
test_out('ok 1 - Parse MANIFEST or equivalent');
test_out('ok 2 - Parse MANIFEST.SKIP or equivalent');
test_out('ok 3 - All files are listed in MANIFEST or skipped');
test_out('ok 4 - All files listed in MANIFEST exist on disk');
test_out('ok 5 - No files are in both MANIFEST and MANIFEST.SKIP');
test_fail(+1);
manifest_ok('MANIFEST.EXTRA', 'MANIFEST.SKIP');
test_test(
  name        => 'Succeeds even when MANIFEST contains extra files',
  skip_err    => 1,
);

# Test what happens when we have some strange circular logic; that is,
# when MANIFEST and MANIFEST.SKIP point to the same file!
#  1 test
test_out('ok 1 - Parse MANIFEST or equivalent');
test_out('ok 2 - Parse MANIFEST.SKIP or equivalent');
test_out('ok 3 - All files are listed in MANIFEST or skipped');
test_out('ok 4 - All files listed in MANIFEST exist on disk');
test_out('not ok 5 - No files are in both MANIFEST and MANIFEST.SKIP');
test_fail(+1);
manifest_ok('MANIFEST', 'CIRCULAR.SKIP');
test_test(
  name        => 'Fails when files are in both MANIFEST and MANIFEST.SKIP',
  skip_err    => 1,
);
