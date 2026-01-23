#include "AD_Reaction.h"

registerMooseObject("freyjaApp", AD_Reaction);

InputParameters
AD_Reaction::validParams()
{
  InputParameters params = ADKernel::validParams();

  params.addClassDescription(
      "Constant scalar reaction/source term");

  params.addRequiredParam<Real>(
      "reaction_rate", "Constant reaction/source term");

  return params;
}

AD_Reaction::AD_Reaction(const InputParameters & parameters)
  : ADKernel(parameters),
    _R(getParam<Real>("reaction_rate"))
{
}

ADReal
AD_Reaction::computeQpResidual()
{
  return _test[_i][_qp] * _R;
}
