#include "AD_ButlerVolmerBC.h"

registerMooseObject("freyjaApp", AD_ButlerVolmerBC);

InputParameters
AD_ButlerVolmerBC::validParams()
{
  InputParameters params = ADIntegratedBC::validParams();

  params.addRequiredCoupledVar("potential", "Electrolyte potential");

  params.addRequiredParam<Real>("i0", "Exchange current density");
  params.addRequiredParam<Real>("alpha_a", "Anodic transfer coefficient");
  params.addRequiredParam<Real>("alpha_c", "Cathodic transfer coefficient");
  params.addRequiredParam<Real>("z", "Charge number");
  params.addRequiredParam<Real>("c_ref", "Reference concentration");
  params.addRequiredParam<Real>("V_metal", "Metal potential");

  params.addParam<Real>("F", 96485.0, "Faraday constant");
  params.addParam<Real>("R", 8.314, "Gas constant");
  params.addParam<Real>("T", 298.0, "Temperature");

  return params;
}

AD_ButlerVolmerBC::AD_ButlerVolmerBC(const InputParameters & parameters)
  : ADIntegratedBC(parameters),
    _phi(adCoupledValue("potential")),
    _i0(getParam<Real>("i0")),
    _alpha_a(getParam<Real>("alpha_a")),
    _alpha_c(getParam<Real>("alpha_c")),
    _z(getParam<Real>("z")),
    _c_ref(getParam<Real>("c_ref")),
    _V(getParam<Real>("V_metal")),
    _F(getParam<Real>("F")),
    _R(getParam<Real>("R")),
    _T(getParam<Real>("T"))
{
}

ADReal
AD_ButlerVolmerBC::computeQpResidual()
{
  const ADReal eta = _V - _phi[_qp];

  const ADReal anodic =
      exp(_alpha_a * _F * eta / (_R * _T));

  const ADReal cathodic =
      (_u[_qp] / _c_ref) *
      exp(-_alpha_c * _F * eta / (_R * _T));

  const ADReal i_n = _i0 * (anodic - cathodic);

  return -_test[_i][_qp] * i_n / (_z * _F);
}
