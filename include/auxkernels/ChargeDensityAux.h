#pragma once

#include "AuxKernel.h"

class ChargeDensityAux : public AuxKernel
{
public:
  static InputParameters validParams();
  ChargeDensityAux(const InputParameters & parameters);

protected:
  virtual Real computeValue() override;

  const VariableValue & _c_plus;
  const VariableValue & _c_minus;
  const Real _F;
};
