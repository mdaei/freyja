#pragma once
#include "ADIntegratedBC.h"

class ADFirstOrderReactionBC : public ADIntegratedBC
{
public:
  static InputParameters validParams();
  ADFirstOrderReactionBC(const InputParameters & parameters);

protected:
  virtual ADReal computeQpResidual() override;

  const ADVariableValue & _c;
  const Real _k;
};
