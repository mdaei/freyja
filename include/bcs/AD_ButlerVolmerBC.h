#pragma once

#include "ADIntegratedBC.h"

class AD_ButlerVolmerBC : public ADIntegratedBC
{
public:
  static InputParameters validParams();
  AD_ButlerVolmerBC(const InputParameters & parameters);

protected:
  virtual ADReal computeQpResidual() override;

private:
  const ADVariableValue & _phi;

  const Real _i0;
  const Real _alpha_a;
  const Real _alpha_c;
  const Real _z;
  const Real _c_ref;
  const Real _V;

  const Real _F;
  const Real _R;
  const Real _T;
};
