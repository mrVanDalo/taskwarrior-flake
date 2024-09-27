{
  python311Packages,
  taskwarrior3,
  fetchFromGitHub,
  ...
}:
(python311Packages.bugwarrior.override {
  taskw =
    (python311Packages.taskw.override {
      taskwarrior2 = taskwarrior3;
    }).overrideAttrs
      (old: {
        doCheck = false;
        doInstallCheck = false;
      });
}).overrideAttrs
  (old: {
    version = "2024-08-27-r1";
    src = fetchFromGitHub {
      owner = "ralphbean";
      repo = "bugwarrior";
      rev = "25e99834ef79e0a8c7141943810e0aa5152d6710";
      sha256 = "sha256-JPmFP6i/7Ji5LyrKT9WCngWqMyrM00rEXV8QVLwxx1A=";
    };
    propagatedBuildInputs = old.propagatedBuildInputs ++ [
      python311Packages.pydantic_1
      python311Packages.tomli
      python311Packages.email-validator
      python311Packages.packaging
      python311Packages.pbr
    ];
  })
