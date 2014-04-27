package AutomakeGenerator;

use AMFileGenerator;
use ACFileGenerator;

sub generate {
  my ($stratagus, $projectName, $projectFolder, $libpng, $lua, $tolua) = @_;

  `mkdir m4`;
  `echo > NEWS`;
  `echo > README`;
  `echo > AUTHORS`;
  `echo > ChangeLog`;

  AMFileGenerator::generate($stratagus, $projectName, $projectFolder, $libpng, $lua, $tolua);
  ACFileGenerator::generate($stratagus, $projectName, $projectFolder, $libpng, $lua, $tolua);
}

1;