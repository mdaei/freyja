#include "AD_NernstPlanckMigration.h"

registerMooseObject("freyjaApp", AD_NernstPlanckMigration);

InputParameters
AD_NernstPlanckMigration::validParams()
{
  InputParameters params = ADKernelGrad::validParams();
  params.addClassDescription("Implements the electromigration term in the Nernst-Planck equation for ionic species transport.");
  params.addRequiredCoupledVar("electric_potential","The electric potential variable (phi)");
  params.addRequiredParam<MaterialPropertyName>("charge","Charge number of the ionic species (e.g., +1 for Li+, -1 for OH-)");
  params.addRequiredParam<MaterialPropertyName>("temperature", "Temperature in Kelvin");
  params.addRequiredParam<MaterialPropertyName>("diffusivity","Diffusion coefficient of the species");
  return params;
}

AD_NernstPlanckMigration::AD_NernstPlanckMigration(const InputParameters & parameters)
  : ADKernelGrad(parameters),
    _phi(adCoupledValue("electric_potential")),
    _grad_phi(adCoupledGradient("electric_potential")),
    _z(getADMaterialProperty<Real>("charge")),
    _temperature(getADMaterialProperty<Real>("temperature")),
    _diffusivity(getADMaterialProperty<Real>("diffusivity")),
    _faraday(96485.33212),      // C/mol
    _gas_constant(8.314462618)  // J/(mol*K)
{
}

ADRealVectorValue
AD_NernstPlanckMigration::precomputeQpResidual()
{
  // Electromigration flux: J_mig = -(z * D * F / (R * T)) * C * grad(phi)
  // The weak form contributes: (z * D * F / (R * T)) * C * grad(phi)
  
  ADReal mobility = _z[_qp] * _diffusivity[_qp] * _faraday / (_gas_constant * _temperature[_qp]);
  return mobility * _u[_qp] * _grad_phi[_qp];
}