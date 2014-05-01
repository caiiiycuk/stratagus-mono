package AMFileGenerator;

my @srcgroups = qw(
  action animation 
  ai editor 
  game guichan 
  map missile
  network particle 
  pathfinder sound 
  spell stratagusmain 
  ui unit 
  video);

  #wargus);

sub generate {
  my ($stratagus, $projectName, $projectFolder, $libpng, $lua, $tolua, $zlib)  = @_;

  $lua = $lua . "/src";
  
  my $src = "$stratagus/src";
  my $stratagusGroups = findSources("$stratagus");
  my $projectGroups = findSources("$projectFolder");
  my %merged = (%$projectGroups, %$stratagusGroups);
  my $groups = \%merged;

  my $sources = "";

  foreach my $group (@srcgroups) {
    die "Source $group not found!" unless exists $groups->{$group};
    #grep { $_ = $stratagus . "/" . $_ } @{$groups->{$group}};
    $sources .= " \\\n" . join(" \\\n", @{$groups->{$group}});
  }

  my $makefile = <<"MAKEFILE_AM";
AUTOMAKE_OPTIONS = subdir-objects

if DEBUG
AM_CXXFLAGS = -g3 -O0
else
AM_CXXFLAGS = -O2
endif

AM_CXXFLAGS += -I$src/include \\
 -I$src/guichan/include \\
 -I$src/guichan/include/guichan \\
 -I$stratagus/gameheaders \\
 -I$libpng \\
 -I$lua \\
 -I$tolua/include \\
 -I$zlib

AM_CFLAGS = \$(AM_CXXFLAGS)

${projectName}_LDADD = \$(REQUIRED_LIBS_LIBS)

bin_PROGRAMS = $projectName
${projectName}_SOURCES = $sources \\
./tolua.cpp \\
 $libpng/png.c \\
 $libpng/pngmem.c \\
 $libpng/pngerror.c \\
 $libpng/pngwrite.c \\
 $libpng/pngset.c \\
 $libpng/pngwutil.c \\
 $libpng/pngtrans.c \\
 $libpng/pngread.c \\
 $libpng/pngrutil.c \\
 $libpng/pngget.c \\
 $libpng/pngrio.c \\
 $libpng/pngrtran.c \\
 $libpng/pngwio.c \\
 $libpng/pngwtran.c \\
 $lua/lapi.c \\
 $lua/lauxlib.c \\
 $lua/lbaselib.c \\
 $lua/lcode.c \\
 $lua/ldblib.c \\
 $lua/ldebug.c \\
 $lua/ldo.c \\
 $lua/ldump.c \\
 $lua/lfunc.c \\
 $lua/lgc.c \\
 $lua/linit.c \\
 $lua/liolib.c \\
 $lua/llex.c \\
 $lua/lmathlib.c \\
 $lua/lmem.c \\
 $lua/loadlib.c \\
 $lua/lobject.c \\
 $lua/lopcodes.c \\
 $lua/loslib.c \\
 $lua/lparser.c \\
 $lua/lstate.c \\
 $lua/lstring.c \\
 $lua/lstrlib.c \\
 $lua/ltable.c \\
 $lua/ltablib.c \\
 $lua/ltm.c \\
 $lua/lundump.c \\
 $lua/lvm.c \\
 $lua/lzio.c \\
 $lua/print.c \\
 $tolua/src/lib/tolua_event.c \\
 $tolua/src/lib/tolua_is.c \\
 $tolua/src/lib/tolua_map.c \\
 $tolua/src/lib/tolua_push.c \\
 $tolua/src/lib/tolua_to.c \\
 $zlib/adler32.c \\
 $zlib/compress.c \\
 $zlib/crc32.c \\
 $zlib/deflate.c \\
 $zlib/gzclose.c \\
 $zlib/gzlib.c \\
 $zlib/gzread.c \\
 $zlib/gzwrite.c \\
 $zlib/infback.c \\
 $zlib/inffast.c \\
 $zlib/inflate.c \\
 $zlib/inftrees.c \\
 $zlib/trees.c \\
 $zlib/uncompr.c \\
 $zlib/zutil.c

MAKEFILE_AM

  open F, ">encoding(:utf-8)", "Makefile.am";
  print F $makefile;
  close F;
}

sub findSources {
  my $folder = shift;
  my $cmake = "$folder/CMakeLists.txt";
  my $sourceMap = {};
  open F, "<encoding(:utf-8)", $cmake or die $1;
  while (<F>) {
    if (m/^set\((.*)_SRCS/) {
      my $group = $1;
      $sourceMap->{$group} = [];
      while (<F>) {
        chomp;
        s/^\s+//g;
        last if (m/^\)$/);
        push $sourceMap->{$group}, $folder."/".$_ unless m/^#/;
      }
    }
  }
  close F;

  return $sourceMap;
}

1;