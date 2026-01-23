#include "AD_Convection.h"

registerMooseObject("freyjaApp", AD_Convection);

InputParameters
AD_Convection::validParams()
{
  InputParameters params = ADKernel::validParams();

  // In this MOOSE version, vector-ness is inferred at fetch time
  params.addRequiredCoupledVar("velocity","Velocity vector variable");

  return params;
}

AD_Convection::AD_Convection(const InputParameters & parameters)
  : ADKernel(parameters),
    _velocity(adCoupledVectorValue("velocity"))
{
}

ADReal
AD_Convection::computeQpResidual()
{
  return (_velocity[_qp] * _grad_u[_qp]) * _test[_i][_qp];
}
