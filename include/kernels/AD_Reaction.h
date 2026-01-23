#pragma once

#include "ADKernel.h"

/**
 * Adds a constant scalar reaction/source term:
 *
 *   R
 */
class AD_Reaction : public ADKernel
{
public:
  static InputParameters validParams();
  AD_Reaction(const InputParameters & parameters);

protected:
  virtual ADReal computeQpResidual() override;

  /// Constant reaction rate
  const Real _R;
};
