#pragma once

#include "ADKernel.h"

class AD_Convection : public ADKernel
{
public:
  static InputParameters validParams();
  AD_Convection(const InputParameters & parameters);

protected:
  virtual ADReal computeQpResidual() override;

  const ADVectorVariableValue & _velocity;
};
