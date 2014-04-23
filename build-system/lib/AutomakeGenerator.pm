package AutomakeGenerator;

use AMFileGenerator;
use ACFileGenerator;

sub generate {
  my ($stratagus, $projectName, $projectFolder) = @_;

  `mkdir m4`;
  `echo > NEWS`;
  `echo > README`;
  `echo > AUTHORS`;
  `echo > ChangeLog`;

  AMFileGenerator::generate($stratagus, $projectName, $projectFolder);
  ACFileGenerator::generate($stratagus, $projectName, $projectFolder);
}

1;