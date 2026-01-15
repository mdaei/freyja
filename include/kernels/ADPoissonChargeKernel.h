#pragma once

#include "ADKernel.h"

class ADPoissonChargeKernel : public ADKernel
{
public:
  static InputParameters validParams();
  ADPoissonChargeKernel(const InputParameters & parameters);

protected:
  virtual ADReal computeQpResidual() override;

  std::vector<const ADVariableValue *> _c_vars;
  std::vector<Real> _z;

  const Real _F;
};
