#pragma once

#include "AuxKernel.h"

class ChargeNeutralAux : public AuxKernel
{
public:
  static InputParameters validParams();
  ChargeNeutralAux(const InputParameters & parameters);

protected:
  virtual Real computeValue() override;

  const VariableValue & _c_plus;
  const Real _z_plus;
  const Real _z_minus;
};
