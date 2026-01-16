#pragma once

#include "ADKernel.h"

class ADMigration : public ADKernel
{
public:
  static InputParameters validParams();
  ADMigration(const InputParameters & parameters);

protected:
  virtual ADReal computeQpResidual() override;

  const ADVariableValue & _c;          // concentration
  const ADMaterialProperty<Real> & _mobility;
  const Function & _phi;
};
