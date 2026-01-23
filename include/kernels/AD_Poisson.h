#pragma once

#include "ADKernel.h"

/**
 * Poisson operator:
 *
 *   ∇·(ε0 εr ∇φ)
 */
class AD_Poisson : public ADKernel
{
public:
  static InputParameters validParams();
  AD_Poisson(const InputParameters & parameters);

protected:
  virtual ADReal computeQpResidual() override;

  /// Vacuum permittivity
  const Real _eps0;

  /// Relative permittivity
  const ADMaterialProperty<Real> & _epsr;
};
