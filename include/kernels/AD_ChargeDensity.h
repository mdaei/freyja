#pragma once

#include "ADKernel.h"

/**
 * Charge density source term:
 *
 *   -F Σ_i z_i C_i
 */
class AD_ChargeDensity : public ADKernel
{
public:
  static InputParameters validParams();
  AD_ChargeDensity(const InputParameters & parameters);

protected:
  virtual ADReal computeQpResidual() override;

  /// Coupled concentrations C_i
  const std::vector<const ADVariableValue *> _c;

  /// Valences z_i
  const std::vector<Real> _z;

  /// Faraday constant
  const Real _F;
};
