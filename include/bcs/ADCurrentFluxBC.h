#pragma once

#include "ADIntegratedBC.h"
#include "Function.h"

class ADCurrentFluxBC : public ADIntegratedBC
{
public:
  static InputParameters validParams();
  ADCurrentFluxBC(const InputParameters & parameters);

protected:
  virtual ADReal computeQpResidual() override;

  const Function & _j_tot;
  const Real _gamma;
  const Real _F;
};
