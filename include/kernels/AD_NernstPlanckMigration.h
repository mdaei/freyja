#pragma once

#include "ADKernelGrad.h"

/**
 * AD_NernstPlanckMigration implements the electromigration term
 * in the Nernst-Planck equation for ionic species transport.
 * 
 * The weak form is: (z * D * F / (R * T)) * C * grad(phi) . grad(test)
 * 
 * where:
 *   z = charge number of the species
 *   D = diffusion coefficient
 *   F = Faraday constant
 *   R = universal gas constant
 *   T = temperature
 *   C = species concentration
 *   phi = electric potential
 */
class AD_NernstPlanckMigration : public ADKernelGrad
{
public:
  static InputParameters validParams();

  AD_NernstPlanckMigration(const InputParameters & parameters);

protected:
  virtual ADRealVectorValue precomputeQpResidual() override;

  /// Coupled electric potential variable
  const ADVariableValue & _phi;
  
  /// Gradient of electric potential
  const ADVariableGradient & _grad_phi;

  /// Charge number of the ionic species
  const ADMaterialProperty<Real> & _z;

    /// Temperature (K)
  const ADMaterialProperty<Real> & _temperature;

  /// Diffusion coefficient (m^2/s)
  const ADMaterialProperty<Real> & _diffusivity;

  /// Faraday constant (C/mol)
  const Real _faraday;

  /// Universal gas constant (J/(mol*K))
  const Real _gas_constant;
};