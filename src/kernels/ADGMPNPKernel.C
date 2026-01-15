#include "ADGMPNPKernel.h"

registerMooseObject("freyjaApp", ADGMPNPKernel);

InputParameters
ADGMPNPKernel::validParams()
{
  InputParameters params = ADKernel::validParams();

  params.addRequiredCoupledVar("phi", "Electric potential");
  params.addRequiredCoupledVar("concentrations",
                               "All concentrations for steric term");

  params.addRequiredParam<Real>("D", "Diffusion coefficient");
  params.addRequiredParam<Real>("z", "Charge number");
  params.addRequiredParam<Real>("ai3", "Ion size cubed (a_i^3)");

  params.addParam<Real>("F", 96485.3329, "Faraday constant");
  params.addParam<Real>("R", 8.314462618, "Gas constant");
  params.addParam<Real>("T", 298.15, "Temperature");

  return params;
}

ADGMPNPKernel::ADGMPNPKernel(const InputParameters & parameters)
  : ADKernel(parameters),
    _grad_phi(adCoupledGradient("phi")),
    _D(getParam<Real>("D")),
    _z(getParam<Real>("z")),
    _ai3(getParam<Real>("ai3")),
    _F(getParam<Real>("F")),
    _R(getParam<Real>("R")),
    _T(getParam<Real>("T"))
{
  const unsigned int n_vars = coupledComponents("concentrations");

  _c_vars.reserve(n_vars);
  _grad_c_vars.reserve(n_vars);

  for (unsigned int i = 0; i < n_vars; ++i)
  {
    _c_vars.push_back(&adCoupledValue("concentrations", i));
    _grad_c_vars.push_back(&adCoupledGradient("concentrations", i));
  }
}

ADReal
ADGMPNPKernel::computeQpResidual()
{
  // s = sum_j a_j^3 c_j
  ADReal steric_sum = 0.0;
  ADRealGradient grad_steric_sum;

  for (unsigned int i = 0; i < _c_vars.size(); ++i)
  {
    steric_sum += _ai3 * (*_c_vars[i])[_qp];
    grad_steric_sum += _ai3 * (*_grad_c_vars[i])[_qp];
  }

  // psi = s / (1 - s)
  const ADReal denom = 1.0 - steric_sum;
  const ADReal inv_denom2 = 1.0 / (denom * denom);

  // grad(psi) = grad(s) / (1 - s)^2
  const ADRealGradient grad_psi = grad_steric_sum * inv_denom2;

  // Diffusion
  ADReal res =
      _D * (_grad_u[_qp] * _grad_test[_i][_qp]);

  // Migration
  res +=
      _D * (_z * _F / (_R * _T)) *
      _u[_qp] *
      (_grad_phi[_qp] * _grad_test[_i][_qp]);

  // Steric correction
  res +=
      _D * _u[_qp] *
      (grad_psi * _grad_test[_i][_qp]);

  return res;
}
