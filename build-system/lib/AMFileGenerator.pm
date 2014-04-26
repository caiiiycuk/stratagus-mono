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
  my ($stratagus, $projectName, $projectFolder, $libpng)  = @_;

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

AM_CXXFLAGS = \$(REQUIRED_LIBS_CFLAGS) \\
 -I$src/include \\
 -I$src/guichan/include \\
 -I$src/guichan/include/guichan \\
 -I$stratagus/gameheaders \\
 -I$libpng

${projectName}_LDADD = \$(REQUIRED_LIBS_LIBS) \\
 -ltolua++5.1

bin_PROGRAMS = $projectName
${projectName}_SOURCES = $sources \\
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
 ./tolua.cpp

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