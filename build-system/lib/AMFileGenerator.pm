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

sub generate {
  my ($stratagus, $projectName, $projectFolder)  = @_;

  my $src = "$stratagus/src";
  my $groups = findSources("$stratagus/CMakeLists.txt");
  my $sources = "";

  foreach my $group (@srcgroups) {
    die "Source $group not found!" unless exists $groups->{$group};
    grep { $_ = $stratagus . "/" . $_ } @{$groups->{$group}};
    # $groups->{$group}->[0] .= "  # ($group)";
    $sources .= " \\\n" . join(" \\\n", @{$groups->{$group}});
  }

  $sources .= "\n";

  my $makefile = <<"MAKEFILE_AM";
AUTOMAKE_OPTIONS = subdir-objects

AM_CXXFLAGS = \$(REQUIRED_LIBS_CFLAGS) \\
 -I$src/include \\
 -I$src/guichan/include \\
 -I$src/guichan/include/guichan

${projectName}_LDADD = \$(REQUIRED_LIBS_LIBS)

bin_PROGRAMS = $projectName
${projectName}_SOURCES = $sources

MAKEFILE_AM

  open F, ">encoding(:utf-8)", "Makefile.am";
  print F $makefile;
  close F;
}

sub findSources {
  my $cmake = shift;
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
        push $sourceMap->{$group}, $_ unless m/^#/;
      }
    }
  }
  close F;

  return $sourceMap;
}

1;