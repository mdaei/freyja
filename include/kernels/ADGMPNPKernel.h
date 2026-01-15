#pragma once

#include "ADKernel.h"

class ADGMPNPKernel : public ADKernel
{
public:
  static InputParameters validParams();
  ADGMPNPKernel(const InputParameters & parameters);

protected:
  virtual ADReal computeQpResidual() override;

  // Electric potential gradient
  const ADVariableGradient & _grad_phi;

  // Concentrations and their gradients
  std::vector<const ADVariableValue *> _c_vars;
  std::vector<const ADVariableGradient *> _grad_c_vars;

  // Parameters
  const Real _D;
  const Real _z;
  const Real _ai3;

  // Constants
  const Real _F;
  const Real _R;
  const Real _T;
};
