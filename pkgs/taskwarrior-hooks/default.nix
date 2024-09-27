{
  rustPlatform,
  fetchFromGitHub,
  lib,
  ...
}:

rustPlatform.buildRustPackage rec {
  name = "taskwarrior-hooks-${version}";
  version = "0.2.2";
  src = fetchFromGitHub {
    owner = "mrVanDalo";
    repo = "taskwarrior-hooks";
    rev = "${version}";
    sha256 = "1mj0k6ykac332667315kqrvg37j8r8078g48nafv7ini6lw8djas";
  };

  cargoSha256 = "1panzqb7nfv3w92ij7pnczkqmcidzlr4pra6a0vcqd65j1m3s4wk";
  #cargoSha256 = "0l4sa5c1pfjdlbdxrd61wd2qij4zaf8rx1xqac80jicly9rf3859";
  #cargoSha256 = "1ijnh2ank9slmfglw4yhnycl11x26m94m2hiq3hcasmbs6c39zj5";
  #verifyCargoDeps = true;

  meta = with lib; {
    description = "A fast line-oriented regex search tool, similar to ag and ack";
    homepage = "https://github.com/mrvandalo/taskwarrior-hooks";
    license = licenses.gpl3;
    maintainers = [ maintainers.mrVanDalo ];
    platforms = platforms.all;
  };
}
