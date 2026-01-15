#pragma once

#include "ADMaterial.h"

class RelativePermittivityMaterial : public ADMaterial
{
public:
  static InputParameters validParams();
  RelativePermittivityMaterial(const InputParameters & parameters);

protected:
  virtual void computeQpProperties() override;

  ADMaterialProperty<Real> & _epsilon;

  std::vector<const ADVariableValue *> _c_vars;
  std::vector<Real> _w;

  const Real _eps0;
  const Real _eps_water;
  const Real _eps_min;
  const Real _M_water;
};
