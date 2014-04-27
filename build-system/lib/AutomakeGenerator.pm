package AutomakeGenerator;

use AMFileGenerator;
use ACFileGenerator;

sub generate {
  my ($stratagus, $projectName, $projectFolder, $libpng, $lua, $tolua, $zlib) = @_;

  `mkdir m4`;
  `echo > NEWS`;
  `echo > README`;
  `echo > AUTHORS`;
  `echo > ChangeLog`;

  AMFileGenerator::generate($stratagus, $projectName, $projectFolder, $libpng, $lua, $tolua, $zlib);
  ACFileGenerator::generate($stratagus, $projectName, $projectFolder, $libpng, $lua, $tolua, $zlib);
}

1;