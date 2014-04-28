use warnings;
use diagnostics;
use strict;

use FindBin;
use lib "$FindBin::Bin/lib";
use File::Spec;

use AutomakeGenerator;

my $stratagusVersion = "2.2.7";
my $root = File::Spec->rel2abs("$FindBin::Bin");
my $build = File::Spec->rel2abs('.');

$root =~ s|(.*)/.*|$1|;

if (-d "$build/build-system" || @ARGV == 0) {
  print <<"USAGE";
USAGE:
\tcd <build-folder>
\tperl -w ../build-system/gen.pl <project(wargus)>
USAGE

  exit(1);
}

my $stratagus = File::Spec->abs2rel("$root/stratagus", $build);
my $projectName = $ARGV[0];
my $projectFolder = File::Spec->abs2rel("$root/$ARGV[0]", $build);
my $libpng = File::Spec->abs2rel("$root/libpng", $build);
my $lua = File::Spec->abs2rel("$root/lua", $build);
my $tolua = File::Spec->abs2rel("$root/tolua++", $build);
my $zlib = File::Spec->abs2rel("$root/zlib", $build);

print <<"CONFIG";
Root folder: $root
Build folder: $build

stratagus version: $stratagusVersion
stratagus folder: $stratagus
$projectName folder: $projectFolder
--
Continue? [y]/n
CONFIG

if (getc() eq 'n') {
  exit(1);
}

print `rm -rf $build/*`;

print "Patching stratagus\n";
print `cd $stratagus && bzr revert` or die $!;
print `patch -p0 -d $stratagus < ../pathces/emscripten.patch` or die $!;

print "Generating stratagus version file\n";
print `$stratagus/tools/genversion ./version-generated.h "$stratagusVersion"` or die;

print "Generating tolua.cpp\n";
print `cd $stratagus/src/tolua && tolua++5.1 -L stratagus.lua -o $build/tolua.cpp stratagus.pkg` or die;

AutomakeGenerator::generate($stratagus, $projectName, $projectFolder, $libpng, $lua, $tolua, $zlib);

print <<"SHELL";

Well done!

To build run:
\tautoreconf --install --force
\t./configure
\tVERBOSE=1 make clean && make -j3
SHELL
