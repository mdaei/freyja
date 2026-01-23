#include "AD_Poisson.h"

registerMooseObject("freyjaApp", AD_Poisson);

InputParameters
AD_Poisson::validParams()
{
  InputParameters params = ADKernel::validParams();
  params.addClassDescription("Poisson dielectric operator ∇·(ε0 εr ∇φ)");
  params.addParam<Real>("eps0", 8.8541878128e-12, "Vacuum permittivity");
  params.addRequiredParam<MaterialPropertyName>("epsr", "Relative permittivity εr");
  return params;
}

AD_Poisson::AD_Poisson(const InputParameters & parameters)
  : ADKernel(parameters),
    _eps0(getParam<Real>("eps0")),
    _epsr(getADMaterialProperty<Real>("epsr"))
{
}

ADReal
AD_Poisson::computeQpResidual()
{
  const ADReal coeff = _eps0 * _epsr[_qp];
  return coeff * (_grad_test[_i][_qp] * _grad_u[_qp]);
}

