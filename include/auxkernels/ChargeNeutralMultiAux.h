#pragma once

#include "AuxKernel.h"

class ChargeNeutralMultiAux : public AuxKernel
{
public:
  static InputParameters validParams();
  ChargeNeutralMultiAux(const InputParameters & parameters);

protected:
  virtual Real computeValue() override;

  const std::vector<const VariableValue *> _species;
  const std::vector<Real> _charges;
  const Real _z_target;
};
