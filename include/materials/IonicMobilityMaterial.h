#pragma once

#include "ADMaterial.h"

class IonicMobilityMaterial : public ADMaterial
{
public:
  static InputParameters validParams();
  IonicMobilityMaterial(const InputParameters & parameters);

protected:
  virtual void computeQpProperties() override;

  ADMaterialProperty<Real> & _mobility;

  const Real _D;
  const Real _z;
  const Real _F;
  const Real _R;
  const Real _T;
};
