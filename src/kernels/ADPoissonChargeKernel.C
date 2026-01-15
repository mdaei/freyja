#include "ADPoissonChargeKernel.h"

registerMooseObject("freyjaApp", ADPoissonChargeKernel);

InputParameters
ADPoissonChargeKernel::validParams()
{
  InputParameters params = ADKernel::validParams();

  params.addRequiredCoupledVar("concentrations",
                               "All ionic concentrations");

  params.addRequiredParam<std::vector<Real>>(
      "z", "Charge numbers corresponding to concentrations");

  params.addParam<Real>("F", 96485.3329, "Faraday constant");

  return params;
}

ADPoissonChargeKernel::ADPoissonChargeKernel(const InputParameters & parameters)
  : ADKernel(parameters),
    _z(getParam<std::vector<Real>>("z")),
    _F(getParam<Real>("F"))
{
  const unsigned int n_vars = coupledComponents("concentrations");

  if (n_vars != _z.size())
    mooseError("Number of concentrations must match number of charges");

  _c_vars.reserve(n_vars);

  for (unsigned int i = 0; i < n_vars; ++i)
    _c_vars.push_back(&adCoupledValue("concentrations", i));
}

ADReal
ADPoissonChargeKernel::computeQpResidual()
{
  ADReal rho = 0.0;

  for (unsigned int i = 0; i < _c_vars.size(); ++i)
    rho += _z[i] * (*_c_vars[i])[_qp];

  return _test[_i][_qp] * _F * rho;
}
