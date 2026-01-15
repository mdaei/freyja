#include "ChargeDensityAux.h"

registerMooseObject("freyjaApp", ChargeDensityAux);

InputParameters
ChargeDensityAux::validParams()
{
  InputParameters params = AuxKernel::validParams();

  params.addRequiredCoupledVar("c_plus", "Cation concentration");
  params.addRequiredCoupledVar("c_minus", "Anion concentration");
  params.addParam<Real>("F", 96485.3329, "Faraday constant");

  return params;
}

ChargeDensityAux::ChargeDensityAux(const InputParameters & parameters)
  : AuxKernel(parameters),
    _c_plus(coupledValue("c_plus")),
    _c_minus(coupledValue("c_minus")),
    _F(getParam<Real>("F"))
{
}

Real
ChargeDensityAux::computeValue()
{
  return _F * (_c_plus[_qp] - _c_minus[_qp]);
}
