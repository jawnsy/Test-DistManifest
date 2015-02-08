# Ensures MANIFEST file is up-to-date

use strict;
use warnings;

use Test::More;
use Test::DistManifest;

plan skip_all => 'this test only works in a fully-built repository'
    if -d '.git' || !-f 'META.yml' || !-f 'MANIFEST';

# since we have no MANIFEST.SKIP in the repo, a default one is used.
manifest_ok();
