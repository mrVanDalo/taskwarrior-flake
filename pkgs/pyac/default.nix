{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyac";
  version = "0.1.5";
  pyproject = true;
  build-system = [ setuptools ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-+TaBzbvuJaYAZKDidE5irDcRa0ZXtnUdlIRWvCf4mjs=";
  };

  # no runtime dependencies

  pythonImportsCheck = [ "pyac" ];

  meta = with lib; {
    description = "ActiveCollab Python API client";
    homepage = "https://github.com/nickrinaldi88/pyac";
    license = licenses.mit;
    maintainers = [ ];
  };
}
