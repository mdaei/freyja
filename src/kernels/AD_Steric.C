#include "AD_Steric.h"

registerMooseObject("freyjaApp", AD_Steric);

InputParameters
AD_Steric::validParams()
{
  InputParameters params = ADKernel::validParams();

  params.addClassDescription("Steric / volumetric exclusion flux term for concentrated electrolytes");
  params.addRequiredCoupledVar("concentrations", "List of all concentrations C_j");
  params.addRequiredParam<MaterialPropertyName>("diffusivity", "Diffusivity D_i of the primary species");
  params.addRequiredParam<std::vector<Real>>("molecular_sizes", "List of molecular sizes a_j (same order as concentrations)");
  params.addParam<Real>("NA", "Avogadro's number");

  return params;
}

AD_Steric::AD_Steric(const InputParameters & parameters)
  : ADKernel(parameters),
    _c(adCoupledValues("concentrations")),
    _grad_c(adCoupledGradients("concentrations")),
    _diffusivity(getADMaterialProperty<Real>("diffusivity")),
    _a(getParam<std::vector<Real>>("molecular_sizes")),
    _NA(6.02214076e23)
{
  if (_c.size() != _a.size())
    mooseError("Number of concentrations must match number of molecular sizes.");
}

ADReal
AD_Steric::computeQpResidual()
{
  ADReal denom = 1.0;
  ADRealVectorValue num;

  for (unsigned int j = 0; j < _c.size(); ++j)
  {
    const Real a3 = _a[j] * _a[j] * _a[j];
    denom -= _NA * a3 * (*_c[j])[_qp];
    num   += _NA * a3 * (*_grad_c[j])[_qp];
  }

  const ADRealVectorValue flux =
      _diffusivity[_qp] * _u[_qp] * num / denom;

  return _grad_test[_i][_qp] * flux;
}