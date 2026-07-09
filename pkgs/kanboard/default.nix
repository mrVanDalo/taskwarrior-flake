{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "kanboard";
  version = "1.1.8";
  pyproject = true;
  build-system = [ setuptools ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-om4Ax+nnywNIQPyFBZRvSDT/EHIdperlIlzDsAzjx7s=";
  };

  # no runtime dependencies (ruff is dev-only)

  pythonImportsCheck = [ "kanboard" ];

  meta = with lib; {
    description = "Kanboard Python API client";
    homepage = "https://github.com/kanboard/python-api-client";
    license = licenses.mit;
    maintainers = [ ];
  };
}
