package AutomakeGenerator;

use AMFileGenerator;
use ACFileGenerator;

sub generate {
  my ($stratagus, $projectName, $projectFolder, $libpng, $lua, $tolua, $zlib, $buildType) = @_;

  `mkdir m4`;
  `echo > NEWS`;
  `echo > README`;
  `echo > AUTHORS`;
  `echo > ChangeLog`;

  AMFileGenerator::generate($stratagus, $projectName, $projectFolder, $libpng, $lua, $tolua, $zlib, $buildType);
  ACFileGenerator::generate($stratagus, $projectName, $projectFolder, $libpng, $lua, $tolua, $zlib, $buildType);
}

1;