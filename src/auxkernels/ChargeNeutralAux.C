#include "ChargeNeutralAux.h"

registerMooseObject("freyjaApp", ChargeNeutralAux);

InputParameters
ChargeNeutralAux::validParams()
{
  InputParameters params = AuxKernel::validParams();

  params.addRequiredCoupledVar("c_plus", "Cation concentration");
  params.addRequiredParam<Real>("z_plus", "Cation charge");
  params.addRequiredParam<Real>("z_minus", "Anion charge");

  return params;
}

ChargeNeutralAux::ChargeNeutralAux(const InputParameters & parameters)
  : AuxKernel(parameters),
    _c_plus(coupledValue("c_plus")),
    _z_plus(getParam<Real>("z_plus")),
    _z_minus(getParam<Real>("z_minus"))
{
}

Real
ChargeNeutralAux::computeValue()
{
  return -_z_plus / _z_minus * _c_plus[_qp];
}
