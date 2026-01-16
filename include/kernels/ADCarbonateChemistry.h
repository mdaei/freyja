#pragma once

#include "ADKernel.h"

class ADCarbonateChemistry : public ADKernel
{
public:
  static InputParameters validParams();
  ADCarbonateChemistry(const InputParameters & parameters);

protected:
  virtual ADReal computeQpResidual() override;

  // Coupled concentrations
  const ADVariableValue & _CO2;
  const ADVariableValue & _H;
  const ADVariableValue & _HCO3;
  const ADVariableValue & _CO3;

  // Reaction rates
  const Real _kf1;
  const Real _kr1;
  const Real _kf2;
  const Real _kr2;

  // Which species this kernel applies to
  const MooseEnum _species;
};
