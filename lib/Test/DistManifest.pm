# Test::DistManifest
#  Tests that your manifest matches the distribution as it exists.
#
# $Id$
#
# Copyright (C) 2008 by Jonathan Yu <frequency@cpan.org>
#
# This package is distributed with the same licensing terms as Perl itself.
# For additional information, please read the included `LICENSE' file.

package Test::DistManifest;

use strict;
use warnings;
use Carp ();

=head1 NAME

Test::DistManifest - Tests that your MANIFEST matches the distribution as it
exists, excluding those in your MANIFEST.SKIP

=head1 VERSION

Version 1.1 ($Id$)

=cut

use version; our $VERSION = qv('1.1');

=head1 EXPORTS

By default, this module exports the following functions:

=over

=item * manifest_ok

=back

=cut

# File management commands
use Cwd 'getcwd';
use File::Spec; # Portability
use File::Find (); # Traverse the filesystem tree

use Module::Manifest ();
use Test::Builder;

my $test = Test::Builder->new;

my @EXPORTS = (
  'manifest_ok',
);

# Looking at other Test modules this seems to be an ad-hoc standard
sub import {
  my ($self, @plan) = @_;
  my $caller = caller;

  {
    ## no critic (ProhibitNoStrict, ProhibitNoisyQuotes)
    no strict 'refs';
    for my $func (@EXPORTS) {
      *{$caller . '::' . $func} = \&{$func};
    }
  }

  $test->exported_to($caller);
  $test->plan(@plan);
  return;
}

=head1 DESCRIPTION

This module provides a simple method of testing that a MANIFEST matches the
distribution.

=head1 SYNOPSIS

  use Test::More;

  eval 'use Test::DistManifest';
  if ($@) {
    plan skip_all => 'Test::DistManifest required to test MANIFEST';
  }

  manifest_ok('MANIFEST', 'MANIFEST.SKIP'); # Default options

  manifest_ok(); # Functionally equivalent to above

=head1 COMPATIBILITY

This module was tested under Perl 5.10.0, using Debian Linux. However, because
it's Pure Perl and doesn't do anything too obscure, it should be compatible
with any version of Perl that supports its prerequisite modules.

If you encounter any problems on a different version or architecture, please
contact the maintainer.

=head1 FUNCTIONS

=head2 manifest_ok( $manifest , $skipfile )

This subroutine checks the manifest list contained in C<$manifest> by using
C<Module::Manifest> to determine the list of files and then checking for the
existence of all such files. Then, it checks if there are any files in the
distribution that were not specified in the C<$manifest> file but do not match
any regular expressions provided in the C<$skipfile> exclusion file.

If your MANIFEST file is generated by C<ExtUtils::MakeMaker> or
C<Module::Build>, then you shouldn't have any problems with these files. It's
just a helpful test to remind you to update these files, using:

  $ make dist # For ExtUtils::MakeMaker
  $ ./Build dist # For Module::Build

=cut

sub manifest_ok {
  my $manifile = shift || 'MANIFEST';
  my $skipfile = shift || 'MANIFEST.SKIP';

  my $root = getcwd(); # the regular expression is Build.PL's Cwd
  my $manifest = Module::Manifest->new;

  unless ($test->has_plan) {
    $test->plan(tests => 4);
  }

  # Try to parse the MANIFEST and MANIFEST.SKIP files
  eval {
    $manifest->open(manifest => $manifile);
  };
  if ($@) {
    $test->diag($!);
  }
  $test->ok(!$@, 'Parse MANIFEST or equivalent');

  eval {
    $manifest->open(skip     => $skipfile);
  };
  if ($@) {
    $test->diag($!);
  }
  $test->ok(!$@, 'Parse MANIFEST.SKIP or equivalent');

  my @files;
  # Callback function called by File::Find
  my $closure = sub {
    # Trim off the package root to determine the relative path.
    my $path = File::Spec->abs2rel($File::Find::name, $root);

    # Test that the path is a file and then make sure it's not skipped
    if (-f $path && !$manifest->skipped($path)) {
      push @files, $path;
    }
    return;
  };

  # Traverse the directory recursively
  File::Find::find({
    wanted            => $closure,
    untaint           => 1,
    no_chdir          => 1,
  }, $root);

  # The two arrays have no duplicates. Thus we loop through them and
  # add the result to a hash.
  my %seen;
  # Allocate buckets for the hash
  keys(%seen) = 2 * scalar(@files);
  foreach my $path (@files, $manifest->files) {
    $seen{$path}++;
  }

  my $flag = 1;
  foreach my $path (@files) {
    # Skip the path if it was seen twice (the expected condition)
    next if ($seen{$path} == 2);

    # Oh no, we have files in @files not in $manifest->files
    if ($flag == 1) {
      $test->diag('Distribution files are missing in MANIFEST:');
      $flag = 0;
    }
    $test->diag($path);
  }
  $test->ok($flag, 'All files are listed in MANIFEST or skipped');

  # Reset the flag and test $manifest->files now
  $flag = 1;
  foreach my $path ($manifest->files) {
    # Skip the path if it was seen twice (the expected condition)
    next if ($seen{$path} == 2);

    # Oh no, we have files in $manifest->files not in @files
    if ($flag == 1) {
      $test->diag('MANIFEST lists the following missing files:');
      $flag = 0;
    }
    $test->diag($path);
  }
  $test->ok($flag, 'All files listed in MANIFEST exist on disk');

  return;
}

=head1 GUTS

This module internally plans 3 tests:

=over

=item 1

B<MANIFEST> and B<MANIFEST.SKIP> can be parsed by C<Module::Manifest>

=item 2

Check which files exist in the distribution directory that do not match an
existing regular expression in B<MANIFEST.SKIP> and not listed in the
B<MANIFEST> file. These files should either be excluded from the test by
addition of a mask in MANIFEST.SKIP (in the case of temporary development
or test files) or should be included in the MANIFEST.

=item 3

Check which files are specified in B<MANIFEST> but do not exist on the disk.
This usually occurs when one deletes a test or similar script from the
distribution, or accidentally moves it.

=back

If you want to run tests on multiple different MANIFEST files, you can simply
pass 'no_plan' to the import function, like so:

  use Test::DistManifest 'no_plan';

  # Multiple tests work properly now
  manifest_ok('MANIFEST', 'MANIFEST.SKIP');
  manifest_ok();
  manifest_ok('MANIFEST.OTHER', 'MANIFEST.SKIP');

I doubt this will be useful to users of this module. However, this is used
internally for testing and it might be helpful to you. You can also plan more
tests, but keep in mind that the idea of "3 internal tests"  may change in the
future.

Example code:

  use Test::DistManifest tests => 4;
  manifest_ok(); # 3 tests
  ok(1, 'is 1 true?');

=head1 AUTHOR

Jonathan Yu E<lt>frequency@cpan.orgE<gt>

=head2 CONTRIBUTORS

Your name here ;-)

=head1 ACKNOWLEDGEMENTS

=over

=item * Thanks to Adam Kennedy E<lt>adamk@cpan.orgE<gt>, developer of
Module::Manifest, which is used in this module.

=back

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Test::DistManifest

You can also look for information at:

=over

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Test-Dist-Manifest>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Test-Dist-Manifest>

=item * Search CPAN

L<http://search.cpan.org/dist/Test-Dist-Manifest>

=item * CPAN Request Tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Test-Dist-Manifest>

=item * CPAN Testing Service (Kwalitee Tests)

L<http://cpants.perl.org/dist/overview/Test-DistManifest>

=back

=head1 FEEDBACK

Please send relevant comments, rotten tomatoes and suggestions directly to the
maintainer noted above.

If you have a bug report or feature request, please file them on the CPAN
Request Tracker at L<http://rt.cpan.org>. If you are able to submit your bug
report in the form of failing unit tests, you are B<strongly> encouraged to do
so. Regular bug reports are always accepted and appreciated via the CPAN bug
tracker.

=head1 SEE ALSO

L<Test::CheckManifest>, a module providing similar functionality

=head1 CAVEATS

=head2 KNOWN BUGS

There are no known bugs as of this release.

=head2 LIMITATIONS

=over

=item *

There is currently no way to test a MANIFEST/MANIFEST.SKIP without having the
files actually exist on disk. I am planning for this to change in the future.

=item *

This module has not been tested very thoroughly with Unicode.

=back

=head1 LICENSE

Copyright (C) 2008 by Jonathan Yu <frequency@cpan.org>

This package is distributed under the same terms as Perl itself. At time of
writing, this means that you are entitled to enjoy the covenants of, at your
option:

=over

=item 1

The Free Software Foundation's GNU General Public License (GPL), version 2 or
later; or

=item 2

The Perl Foundation's Artistic License, version 2.0 or later

=back

=head1 DISCLAIMER OF WARRANTY

This software is provided by the copyright holders and contributors "AS IS"
and ANY EXPRESS OR IMPLIED WARRANTIES, including, but not limited to, the
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED.

In no event shall the copyright owner or contributors be liable for any
direct, indirect, incidental, special, exemplary or consequential damages
(including, but not limited to, procurement of substitute goods or services;
loss of use, data or profits; or business interruption) however caused and on
any theory of liability, whether in contract, strict liability or tort
(including negligence or otherwise) arising in any way out of the use of this
software, even if advised of the possibility of such damage.

=cut

1;
