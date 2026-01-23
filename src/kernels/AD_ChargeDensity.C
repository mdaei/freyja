#include "AD_ChargeDensity.h"

registerMooseObject("freyjaApp", AD_ChargeDensity);

InputParameters
AD_ChargeDensity::validParams()
{
  InputParameters params = ADKernel::validParams();
  params.addClassDescription("Charge density source term -F Σ_i z_i C_i");
  params.addRequiredCoupledVar("concentrations", "List of concentrations C_i");
  params.addRequiredParam<std::vector<Real>>("valences", "Charge numbers z_i");
  params.addParam<Real>("F", "Faraday constant");

  return params;
}

AD_ChargeDensity::AD_ChargeDensity(const InputParameters & parameters)
  : ADKernel(parameters),
    _c(adCoupledValues("concentrations")),
    _z(getParam<std::vector<Real>>("valences")),
    _F(96485.33212)
{
  if (_c.size() != _z.size())
    mooseError("Number of concentrations must match number of valences.");
}

ADReal
AD_ChargeDensity::computeQpResidual()
{
  ADReal rho = 0.0;

  for (unsigned int i = 0; i < _c.size(); ++i)
    rho += _z[i] * (*_c[i])[_qp];

  return -_F * _test[_i][_qp] * rho;
}
