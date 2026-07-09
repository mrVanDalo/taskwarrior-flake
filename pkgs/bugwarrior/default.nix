{
  python3Packages,
  taskwarrior3,
  fetchFromGitHub,
  pyac,
  kanboard,
  phabricator,
  ...
}:
(python3Packages.bugwarrior.override {
  taskw =
    (python3Packages.taskw.override {
      taskwarrior2 = taskwarrior3;
    }).overrideAttrs
      (old: {
        doCheck = false;
        doInstallCheck = false;
      });
}).overrideAttrs
  (old: {
    version = "1.8.0";
    src = fetchFromGitHub {
      owner = "ralphbean";
      repo = "bugwarrior";
      rev = "25e99834ef79e0a8c7141943810e0aa5152d6710";
      sha256 = "sha256-JPmFP6i/7Ji5LyrKT9WCngWqMyrM00rEXV8QVLwxx1A=";
    };
    propagatedBuildInputs =
      (builtins.filter (p: (p.pname or "") != "pydantic") old.propagatedBuildInputs)
      ++ [
        python3Packages.pydantic_1
        python3Packages.tomli
        python3Packages.email-validator
        python3Packages.packaging
        python3Packages.pbr
      ];
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
      python3Packages.pypandoc
      pyac
      kanboard
      phabricator
    ];
    disabledTestPaths = [ ];
  })
