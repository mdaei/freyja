#pragma once

#include "ADKernel.h"

/**
 * Steric / volumetric exclusion flux term:
 *
 *   ∇·[ D_i C_i ( N_A Σ_j a_j^3 ∇C_j ) / ( 1 - N_A Σ_j a_j^3 C_j ) ]
 */
class AD_Steric : public ADKernel
{
public:
  static InputParameters validParams();

  AD_Steric(const InputParameters & parameters);

protected:
  virtual ADReal computeQpResidual() override;

  /// Coupled concentrations C_j
  const std::vector<const ADVariableValue *> _c;

  /// Gradients of coupled concentrations ∇C_j
  const std::vector<const ADVariableGradient *> _grad_c;
  
  /// Diffusivity of species i
  const ADMaterialProperty<Real> & _diffusivity;

  /// Molecular sizes a_j
  const std::vector<Real> _a;

  /// Avogadro's number
  const Real _NA;
};
