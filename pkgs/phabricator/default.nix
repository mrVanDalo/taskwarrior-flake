{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  requests,
}:

buildPythonPackage rec {
  pname = "phabricator";
  version = "0.9.1";
  pyproject = true;
  build-system = [ setuptools ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-bM2F+VBQMhkJkl4uEg1ASRfrbfcB+nS3PwTaQgequ6I=";
  };

  propagatedBuildInputs = [ requests ];

  pythonImportsCheck = [ "phabricator" ];

  meta = with lib; {
    description = "Phabricator Python API client";
    homepage = "https://github.com/disqus/python-phabricator";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
