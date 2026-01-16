#include "ADFirstOrderReactionBC.h"

registerMooseObject("freyjaApp", ADFirstOrderReactionBC);

InputParameters
ADFirstOrderReactionBC::validParams()
{
  InputParameters params = ADIntegratedBC::validParams();
  params.addRequiredCoupledVar("c", "Concentration");
  params.addRequiredParam<Real>("k", "Reaction rate");
  return params;
}

ADFirstOrderReactionBC::ADFirstOrderReactionBC(const InputParameters & parameters)
  : ADIntegratedBC(parameters),
    _c(adCoupledValue("c")),
    _k(getParam<Real>("k"))
{}

ADReal
ADFirstOrderReactionBC::computeQpResidual()
{
  return _test[_i][_qp] * (_k * _c[_qp]);
}
