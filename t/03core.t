#!/usr/bin/perl -T

# Ensures the MANIFEST test output looks reasonable

use strict;
use warnings;

use Test::Builder::Tester tests => 8;
use Test::DistManifest;
use Test::NoWarnings; # 1 test
use File::Spec;

# If MANIFEST_WARN_ONLY is set, unset it
if (exists($ENV{MANIFEST_WARN_ONLY})) {
  delete($ENV{MANIFEST_WARN_ONLY});
}

# This one is already tested as part of 02manifest.t
#manifest_ok();

manifest_ok('MANIFEST', 'MANIFEST.SKIP');

# Run the test when MANIFEST is invalid but the MANIFEST.SKIP file is okay
#  1 test
test_out('not ok 1 - Parse MANIFEST or equivalent');
test_out('not ok 2 - All files are listed in MANIFEST or skipped');
test_out('ok 3 - All files listed in MANIFEST exist on disk');
test_diag('No such file or directory');
test_fail(+1);
test_out('ok 4 - No files are in both MANIFEST and MANIFEST.SKIP');
manifest_ok('INVALID.FILE', 'MANIFEST.SKIP');
test_test(
  name      => 'Fails when MANIFEST cannot be parsed',
  skip_err  => 1,
);

# Test what happens when MANIFEST contains some extra files
#  1 test
test_out('ok 1 - Parse MANIFEST or equivalent');
test_out('not ok 2 - All files are listed in MANIFEST or skipped');
test_out('not ok 3 - All files listed in MANIFEST exist on disk');
test_out('ok 4 - No files are in both MANIFEST and MANIFEST.SKIP');
test_fail(+1);
manifest_ok(File::Spec->catfile('t', 'extra'), 'MANIFEST.SKIP');
test_test(
  name      => 'Fails when MANIFEST contains extra files',
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
  name      => 'Fails when files are in both MANIFEST and MANIFEST.SKIP',
  skip_err  => 1,
);
