#include "ADCurrentFluxBC.h"

registerMooseObject("freyjaApp", ADCurrentFluxBC);

InputParameters
ADCurrentFluxBC::validParams()
{
  InputParameters params = ADIntegratedBC::validParams();

  params.addRequiredParam<FunctionName>(
      "j_tot",
      "Total applied current density as a function of time (A/m^2)");

  params.addRequiredParam<Real>(
      "gamma",
      "Fraction of current carried by this species");

  params.addParam<Real>("F", 96485.3329, "Faraday constant");

  return params;
}

ADCurrentFluxBC::ADCurrentFluxBC(const InputParameters & parameters)
  : ADIntegratedBC(parameters),
    _j_tot(getFunction("j_tot")),
    _gamma(getParam<Real>("gamma")),
    _F(getParam<Real>("F"))
{
}

ADReal
ADCurrentFluxBC::computeQpResidual()
{
  const Real j = _j_tot.value(_t, _q_point[_qp]);
  const ADReal flux = -j * _gamma / _F;

  return _test[_i][_qp] * flux;
}
