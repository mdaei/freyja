#include "ADMigration.h"
#include "Function.h"


registerMooseObject("freyjaApp", ADMigration);

InputParameters
ADMigration::validParams()
{
  InputParameters params = ADKernel::validParams();

  params.addRequiredCoupledVar("c", "Concentration variable");
  params.addRequiredParam<MaterialPropertyName>(
      "mobility", "Electrochemical mobility D*z*F/(R*T)");
  params.addRequiredParam<FunctionName>(
      "electric_potential", "Externally imposed electric potential");

  return params;
}

ADMigration::ADMigration(const InputParameters & parameters)
  : ADKernel(parameters),
    _c(adCoupledValue("c")),
    _mobility(getADMaterialProperty<Real>("mobility")),
    _phi(getFunction("electric_potential"))
{
}

ADReal
ADMigration::computeQpResidual()
{
  // Gradient of imposed potential
  const RealGradient grad_phi = _phi.gradient(_t, _q_point[_qp]);
  
  return _mobility[_qp] * _c[_qp] * (_grad_test[_i][_qp] * grad_phi);
}
