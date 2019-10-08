{ lib
, buildPythonPackage
, pythonAtLeast
, fetchFromGitHub
, pytz
, aiohttp
, ciso8601
, pytest
, pytest-asyncio
, pytestcov
, pyyaml
, flake8
, pep8-naming
, pygments
, pandas
}:

# TODO: Optional pandas dataframe, cache, etc

buildPythonPackage rec {
  pname = "aioinflux";
  version = "0.9.0";

  disabled = !(pythonAtLeast "3.6");

  src = fetchFromGitHub {
    owner = "gusutabopb";
    repo = "aioinflux";
    rev = "v${version}";
    sha256 = "0cvzkd05i8bzh76m75s7na2gb0kh5msyyz60ajxpj2by9x6qkxmc";
  };

  propagatedBuildInputs = [ aiohttp pytz ciso8601 ];

  checkInputs = [
    pytest
    pytest-asyncio
    pytestcov
    pyyaml
    pytz
    flake8
    pep8-naming
    #flake8-rst-docstrings
    pygments
    pandas
  ];

  meta = with lib; {
    description = "Python client for InfluxDB";
    homepage = https://github.com/influxdb/influxdb-python;
    license = licenses.mit;
    maintainers = with maintainers; [ liamdiprose ];
  };

}
