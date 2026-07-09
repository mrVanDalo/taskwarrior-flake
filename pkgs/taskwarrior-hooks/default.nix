{
  rustPlatform,
  fetchFromGitHub,
  lib,
  ...
}:

rustPlatform.buildRustPackage rec {

  name = "taskwarrior-hooks-${version}";

  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "mrVanDalo";
    repo = "taskwarrior-hooks";
    rev = "${version}";
    sha256 = "sha256-mdRBg10WszTEJXIkPXM+kPfjysFi8pqF+V7H6ExMH+Y=";
  };

  #cargoHash = lib.fakeHash;
  cargoHash = "sha256-+RBwR7O1V8oQgvNVMIGcXeADtGEDZN154NjiY4I40KE=";

  meta = with lib; {
    description = "A fast line-oriented regex search tool, similar to ag and ack";
    homepage = "https://github.com/mrvandalo/taskwarrior-hooks";
    license = licenses.gpl3;
    maintainers = [ maintainers.mrVanDalo ];
    platforms = platforms.all;
  };
}
