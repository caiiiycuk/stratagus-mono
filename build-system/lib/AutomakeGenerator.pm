package AutomakeGenerator;

use AMFileGenerator;
use ACFileGenerator;

sub generate {
  my ($stratagus, $projectName, $projectFolder, $libpng) = @_;

  `mkdir m4`;
  `echo > NEWS`;
  `echo > README`;
  `echo > AUTHORS`;
  `echo > ChangeLog`;

  AMFileGenerator::generate($stratagus, $projectName, $projectFolder, $libpng);
  ACFileGenerator::generate($stratagus, $projectName, $projectFolder, $libpng);
}

1;